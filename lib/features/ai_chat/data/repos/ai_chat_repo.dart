import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:dio/dio.dart';

import '../models/ai_diagnosis_model.dart';

class AiChatRepo {
  final ApiService _apiService;

  AiChatRepo(this._apiService);

  /// الباك اند يمنح مزوّد الذكاء الاصطناعي 60 ثانية، والمهلة العامة لـ Dio
  /// ثلاثون ثانية فقط — لذا نرفعها لهذا النداء وحده وإلا قُطع طلب سليم
  static const Duration _diagnoseTimeout = Duration(seconds: 90);

  /// نداء واحد يخدم الحالتين: إرجاع السؤال التالي، أو التشخيص النهائي عند
  /// اكتمال الأسئلة الستة. لا جلسة على السيرفر — نرسل `problem` و`answers`
  /// كاملين في كل مرة
  Future<AiDiagnoseResult> diagnose({
    required String problem,
    List<AiQnA> answers = const [],
    int? orderId,
  }) async {
    final Map<String, dynamic> json;
    try {
      final response = await _apiService.post(
        endpoint: ApiConstants.aiDiagnose,
        data: {
          'problem': problem,
          'answers': answers.map((qna) => qna.toJson()).toList(),
          // اختياري لكنه يحسّن التشخيص: منه يقرأ السيرفر ماركة السيارة ونوعها
          'order_id': ?orderId,
        },
        options: Options(
          receiveTimeout: _diagnoseTimeout,
          sendTimeout: _diagnoseTimeout,
        ),
      );
      json = _asMap(response.data);
    } catch (error) {
      throw AiChatFailure(
        AiFailureKind.diagnoseUnavailable,
        serverMessage: _serverMessage(error),
      );
    }

    if (_isFinished(json['finished'])) {
      final data = json['data'];
      if (data is Map) {
        return AiDiagnoseResult.diagnosis(
          AiDiagnosis.fromJson(
            Map<String, dynamic>.from(data),
            source: json['source']?.toString() ?? '',
          ),
        );
      }
      throw const AiChatFailure(AiFailureKind.diagnoseUnavailable);
    }

    // استجابة السؤال لا تحتوي مفتاح `data` إطلاقاً
    final question = json['question'];
    if (question is String && question.trim().isNotEmpty) {
      return AiDiagnoseResult.question(question);
    }

    throw const AiChatFailure(AiFailureKind.diagnoseUnavailable);
  }

  /// ربط الخدمة المقترحة بطلب صيانة قائم.
  ///
  /// ⚠️ العملية إحلالية على السيرفر: تستبدل خدمة الطلب وتعيد ضبط سعره الإجمالي
  /// إلى سعر الخدمة الأساسي، كما أنها لا تتحقق من ملكية الطلب — لذا تُستدعى
  /// فقط بعد تأكيد المستخدم ولطلباته هو
  Future<AiAppliedService> applyService({
    required int orderId,
    required int serviceId,
  }) async {
    final Map<String, dynamic> json;
    try {
      final response = await _apiService.post(
        endpoint: ApiConstants.aiApplyService,
        data: {'order_id': orderId, 'service_id': serviceId},
      );
      json = _asMap(response.data);
    } catch (error) {
      throw AiChatFailure(
        AiFailureKind.applyServiceFailed,
        serverMessage: _serverMessage(error),
      );
    }

    final data = json['data'];
    if (data is Map) {
      return AiAppliedService.fromJson(Map<String, dynamic>.from(data));
    }
    throw const AiChatFailure(AiFailureKind.applyServiceFailed);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return const {};
  }

  bool _isFinished(dynamic value) =>
      value == true || value == 1 || value == '1' || value == 'true';

  /// أخطاء هذه المسارات قد تصل بلا رسالة مفيدة: خطأ 500 عند تعطّل مزوّد
  /// الذكاء الاصطناعي يعيد `message: ""` أو صفحة HTML. نُرجع `null` عندها
  /// ليتولّى العارض إظهار رسالة مترجمة بدلاً من نص فارغ
  String? _serverMessage(Object error) {
    final message = error is String ? error.trim() : error.toString().trim();
    return message.isEmpty ? null : message;
  }
}
