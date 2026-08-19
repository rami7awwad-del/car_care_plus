import '../data/models/ai_chat_message.dart';
import '../data/models/ai_diagnosis_model.dart';

enum AiChatStatus {
  /// لم يصف المستخدم مشكلته بعد
  initial,

  /// طلب قيد التنفيذ — يجب تعطيل الإرسال
  sending,

  /// وصل سؤال بانتظار إجابة المستخدم
  awaitingAnswer,

  /// وصل التشخيص النهائي
  finished,

  /// فشل آخر طلب — سجل الإجابات محفوظ ويمكن إعادة المحاولة يدوياً
  error,
}

class AiChatState {
  final AiChatStatus status;
  final List<AiChatMessage> messages;

  /// نص المشكلة يُعاد إرساله كما هو في كل طلب — عليه يقوم التشخيص والمطابقة
  final String problem;

  /// سجل الأسئلة والأجوبة كاملاً — السيرفر بلا جلسة، ونحن من يحفظه
  final List<AiQnA> answers;

  /// نص السؤال المعروض حالياً كما وصل من السيرفر حرفياً
  final String? pendingQuestion;

  /// رقم طلب الصيانة إن فُتحت المحادثة من طلب قائم
  final int? orderId;

  final bool isApplyingService;
  final bool isServiceApplied;

  /// خطأ مصنَّف — الواجهة هي من تترجمه عند العرض
  final AiChatFailure? failure;

  const AiChatState({
    this.status = AiChatStatus.initial,
    this.messages = const [],
    this.problem = '',
    this.answers = const [],
    this.pendingQuestion,
    this.orderId,
    this.isApplyingService = false,
    this.isServiceApplied = false,
    this.failure,
  });

  bool get isBusy => status == AiChatStatus.sending;

  /// هناك محادثة جارية يمكن تصفيرها
  bool get hasConversation => messages.isNotEmpty;

  /// زر إضافة الخدمة إلى الطلب يظهر فقط لطلب يملكه المستخدم فعلاً
  bool get canApplyService => orderId != null;

  AiChatState copyWith({
    AiChatStatus? status,
    List<AiChatMessage>? messages,
    String? problem,
    List<AiQnA>? answers,
    String? pendingQuestion,
    int? orderId,
    bool? isApplyingService,
    bool? isServiceApplied,
    AiChatFailure? failure,
    bool clearFailure = false,
    bool clearPendingQuestion = false,
  }) {
    return AiChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      problem: problem ?? this.problem,
      answers: answers ?? this.answers,
      pendingQuestion:
          clearPendingQuestion ? null : (pendingQuestion ?? this.pendingQuestion),
      orderId: orderId ?? this.orderId,
      isApplyingService: isApplyingService ?? this.isApplyingService,
      isServiceApplied: isServiceApplied ?? this.isServiceApplied,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
