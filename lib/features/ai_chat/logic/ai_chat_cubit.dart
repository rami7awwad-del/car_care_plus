import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/ai_chat_message.dart';
import '../data/models/ai_diagnosis_model.dart';
import '../data/repos/ai_chat_repo.dart';
import 'ai_chat_state.dart';

/// يدير محادثة المساعد الذكي كاملة.
///
/// السيرفر بلا جلسة ولا معرّف محادثة: نحتفظ نحن بنص المشكلة وبسجل الأسئلة
/// والأجوبة ونعيد إرسالهما كاملين في كل طلب. لذلك يُوفَّر هذا الـ Cubit على
/// مستوى التطبيق حتى لا تضيع المحادثة عند مغادرة الشاشة والعودة إليها.
///
/// لا يحمل هذا الكلاس أي نص معروض — رسالة الترحيب ونصوص الأخطاء تُترجم في
/// الواجهة، فيبقى المحتوى متجاوباً مع تبديل اللغة أثناء المحادثة
class AiChatCubit extends Cubit<AiChatState> {
  final AiChatRepo _repo;

  AiChatCubit(this._repo) : super(const AiChatState());

  /// الأسئلة المكتوبة في الباك اند ستة. نضع سقفاً أوسع منها كصمّام أمان: لو
  /// اختلّت مطابقة نص سؤال ما لأي سبب لأعاد السيرفر السؤال ذاته بلا نهاية،
  /// فنوقف الحلقة برسالة بدل أن تدور الواجهة إلى الأبد
  static const int _maxAnswers = 12;

  /// تُستدعى عند فتح الشاشة. لا تمسّ محادثة جارية حتى لا تُفقد الإجابات
  void openChat({int? orderId}) {
    if (orderId != null && orderId != state.orderId) {
      emit(state.copyWith(orderId: orderId));
    }
  }

  /// بدء محادثة جديدة بوصف المشكلة
  Future<void> startConversation(String problem) async {
    final trimmed = problem.trim();
    if (trimmed.isEmpty || state.isBusy) return;

    emit(state.copyWith(
      problem: trimmed,
      answers: const [],
      messages: [...state.messages, AiChatMessage.user(trimmed)],
      clearPendingQuestion: true,
      clearFailure: true,
      isServiceApplied: false,
    ));

    await _sendToServer();
  }

  /// إرسال إجابة على السؤال المعروض حالياً
  Future<void> submitAnswer(String answer) async {
    final trimmed = answer.trim();
    final question = state.pendingQuestion;
    if (trimmed.isEmpty || question == null || state.isBusy) return;

    emit(state.copyWith(
      // نص السؤال يُخزَّن كما وصل من السيرفر حرفياً — المطابقة عنده صارمة
      answers: [...state.answers, AiQnA(question: question, answer: trimmed)],
      messages: [...state.messages, AiChatMessage.user(trimmed)],
      clearPendingQuestion: true,
      clearFailure: true,
    ));

    await _sendToServer();
  }

  /// إعادة المحاولة يدوياً بعد فشل — الإجابات المحفوظة تُرسل كما هي.
  /// لا نعيد المحاولة تلقائياً لأن الطلب الأخير قد يستهلك نداء نموذج لغوي
  Future<void> retry() async {
    if (state.isBusy || state.problem.isEmpty) return;
    await _sendToServer();
  }

  Future<void> _sendToServer() async {
    if (state.answers.length > _maxAnswers) {
      emit(state.copyWith(
        status: AiChatStatus.error,
        failure: const AiChatFailure(AiFailureKind.conversationLoop),
      ));
      return;
    }

    emit(state.copyWith(status: AiChatStatus.sending, clearFailure: true));

    try {
      final result = await _repo.diagnose(
        problem: state.problem,
        answers: state.answers,
        orderId: state.orderId,
      );
      if (isClosed) return;

      // كلتا الاستجابتين تعودان بالحالة 200 — التفريع على `finished` وحده
      if (result.finished) {
        emit(state.copyWith(
          status: AiChatStatus.finished,
          messages: [...state.messages, AiChatMessage.result(result.diagnosis!)],
          clearPendingQuestion: true,
        ));
      } else {
        emit(state.copyWith(
          status: AiChatStatus.awaitingAnswer,
          pendingQuestion: result.question,
          messages: [...state.messages, AiChatMessage.bot(result.question!)],
        ));
      }
    } on AiChatFailure catch (failure) {
      if (isClosed) return;
      emit(state.copyWith(status: AiChatStatus.error, failure: failure));
    }
  }

  /// إضافة الخدمة المقترحة إلى طلب الصيانة.
  ///
  /// ⚠️ العملية تستبدل خدمة الطلب وتعيد ضبط سعره الإجمالي، لذا تُستدعى فقط
  /// بعد تأكيد صريح من المستخدم
  Future<void> applyRecommendedService(AiRecommendedService service) async {
    final orderId = state.orderId;
    if (orderId == null || state.isApplyingService || state.isServiceApplied) {
      return;
    }

    emit(state.copyWith(isApplyingService: true, clearFailure: true));
    try {
      await _repo.applyService(orderId: orderId, serviceId: service.id);
      if (isClosed) return;
      emit(state.copyWith(isApplyingService: false, isServiceApplied: true));
    } on AiChatFailure catch (failure) {
      if (isClosed) return;
      emit(state.copyWith(isApplyingService: false, failure: failure));
    }
  }

  /// تصفير المحادثة والبدء من جديد
  void reset() {
    emit(AiChatState(orderId: state.orderId));
  }
}
