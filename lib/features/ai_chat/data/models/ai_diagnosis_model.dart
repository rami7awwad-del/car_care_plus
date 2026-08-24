// نماذج المساعد الذكي.
//
// ⚠️ نقطتا `/api/ai/diagnose` و `/api/ai/apply-service` لا تستخدمان المغلّف
// العام `{status, data, message, ...}` بل شكلاً خاصاً `{success, ...}`،
// لذلك لا نمرّر استجابتهما على أي منطق يفكّ المغلّف.

// ==================== سؤال وجواب ====================

/// عنصر واحد من سجل المحادثة.
///
/// ⚠️ السيرفر يطابق `question` بمقارنة صارمة (`===`) مع نصوصه المكتوبة داخل
/// الكود، لذا يجب تخزين نص السؤال كما وصل حرفاً بحرف وإعادته دون أي تعديل
/// (لا تشذيب ولا ترجمة ولا حذف علامة الاستفهام)، وإلا أعاد السيرفر السؤال
/// نفسه إلى ما لا نهاية ولن تصل المحادثة إلى التشخيص أبداً.
class AiQnA {
  final String question;
  final String answer;

  const AiQnA({required this.question, required this.answer});

  Map<String, dynamic> toJson() => {'question': question, 'answer': answer};
}

// ==================== درجة الخطورة ====================

enum AiSeverity {
  low,
  medium,
  high;

  /// السيرفر يضبط القيمة أصلاً ضمن هذه الثلاثة، والافتراضي `medium`
  static AiSeverity fromApi(dynamic value) {
    switch (value?.toString().trim().toLowerCase()) {
      case 'low':
        return AiSeverity.low;
      case 'high':
        return AiSeverity.high;
      default:
        return AiSeverity.medium;
    }
  }
}

// ==================== الخدمة المقترحة ====================

class AiRecommendedService {
  final int id;
  final String name;
  final String nameAr;

  /// السيرفر يُرجع السعر كنص (عمود decimal) مثل "80.00" — نحوّله هنا مرة واحدة
  /// حتى لا تتسرّب عمليات الجمع النصية إلى الواجهة
  final double price;
  final int durationMinutes;

  const AiRecommendedService({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.price,
    required this.durationMinutes,
  });

  /// الاسم بلغة الواجهة، مع الرجوع إلى اللغة الأخرى حين يصل أحدهما فارغاً
  String displayName({required bool isArabic}) {
    final preferred = isArabic ? nameAr : name;
    final fallback = isArabic ? name : nameAr;
    return preferred.trim().isNotEmpty ? preferred : fallback;
  }

  factory AiRecommendedService.fromJson(Map<String, dynamic> json) {
    return AiRecommendedService(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      nameAr: _asString(json['name_ar']),
      price: _asDouble(json['price']),
      durationMinutes: _asInt(json['duration_minutes']),
    );
  }
}

// ==================== التشخيص ====================

class AiDiagnosis {
  final String problem;

  /// قد تعود فارغة — يجب التحقق قبل عرضها
  final List<String> possibleCauses;

  /// النص الأساسي المعروض. قد يحتوي أسطراً أو بقايا Markdown، لذا يُعرض كنص
  /// عادي فقط ولا يُحقن كـ HTML
  final String advice;
  final AiSeverity severity;

  /// الاسم الإنجليزي الذي اختاره الذكاء الاصطناعي — للتشخيص البرمجي فقط
  final String serviceName;

  /// `null` عندما لا تطابق أي خدمة في قاعدة البيانات
  final AiRecommendedService? recommendedService;

  /// `database_rule` (قاعدة معتمدة) أو `openrouter` (إجابة مولّدة)
  final String source;

  const AiDiagnosis({
    required this.problem,
    required this.possibleCauses,
    required this.advice,
    required this.severity,
    required this.serviceName,
    required this.recommendedService,
    required this.source,
  });

  /// إجابات نموذج اللغة تحتاج تنبيهاً للمستخدم، أما قواعد قاعدة البيانات فمعتمدة
  bool get isAiGenerated => source == 'openrouter';

  factory AiDiagnosis.fromJson(Map<String, dynamic> json, {required String source}) {
    final rawCauses = json['possible_causes'];
    final rawService = json['recommended_service'];

    return AiDiagnosis(
      problem: _asString(json['problem']),
      possibleCauses: rawCauses is List
          ? rawCauses
              .map(_asString)
              .where((cause) => cause.trim().isNotEmpty)
              .toList()
          : const <String>[],
      advice: _asString(json['advice']),
      severity: AiSeverity.fromApi(json['severity']),
      serviceName: _asString(json['service_name']),
      recommendedService: rawService is Map
          ? AiRecommendedService.fromJson(Map<String, dynamic>.from(rawService))
          : null,
      source: source,
    );
  }
}

// ==================== نتيجة نداء diagnose ====================

/// النداء نفسه يعيد إما السؤال التالي وإما التشخيص النهائي، وكلاهما بحالة 200،
/// لذا التفريع يكون على `finished` وليس على رمز الحالة
class AiDiagnoseResult {
  final bool finished;
  final String? question;
  final AiDiagnosis? diagnosis;

  const AiDiagnoseResult.question(String this.question)
      : finished = false,
        diagnosis = null;

  const AiDiagnoseResult.diagnosis(AiDiagnosis this.diagnosis)
      : finished = true,
        question = null;
}

// ==================== نتيجة نداء apply-service ====================

class AiAppliedService {
  final int orderId;
  final AiRecommendedService? service;
  final double totalPrice;

  const AiAppliedService({
    required this.orderId,
    required this.service,
    required this.totalPrice,
  });

  factory AiAppliedService.fromJson(Map<String, dynamic> json) {
    final rawService = json['service'];
    return AiAppliedService(
      orderId: _asInt(json['order_id']),
      service: rawService is Map
          ? AiRecommendedService.fromJson(Map<String, dynamic>.from(rawService))
          : null,
      totalPrice: _asDouble(json['total_price']),
    );
  }
}

// ==================== الأخطاء ====================

enum AiFailureKind {
  /// فشل نداء التشخيص — غالباً تعطّل مزوّد الذكاء الاصطناعي
  diagnoseUnavailable,

  /// فشل ربط الخدمة المقترحة بالطلب
  applyServiceFailed,

  /// السيرفر يعيد السؤال ذاته بلا نهاية، فأوقفنا الحلقة
  conversationLoop,
}

/// خطأ مصنَّف بدل نص جاهز، حتى تُترجم الرسالة لحظة عرضها لا لحظة وقوعها.
///
/// [serverMessage] يُعرض كما هو حين يصل، لأنه أدقّ من أي رسالة عامة — ولارافل
/// يترجمه حسب ترويسة `Accept-Language` التي نرسلها مع كل طلب
class AiChatFailure {
  final AiFailureKind kind;
  final String? serverMessage;

  const AiChatFailure(this.kind, {this.serverMessage});
}

// ==================== مساعدات التحويل ====================

String _asString(dynamic value) => value?.toString() ?? '';

int _asInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}
