import 'ai_diagnosis_model.dart';

enum AiMessageSender { bot, user }

/// رسالة واحدة داخل شريط المحادثة.
///
/// رسالة التشخيص تحمل الكائن كاملاً بدل نص جاهز، لأن الكرت يعرض الأسباب
/// والخدمة المقترحة وزر إضافتها إلى الطلب
class AiChatMessage {
  final AiMessageSender sender;
  final String text;
  final AiDiagnosis? diagnosis;

  const AiChatMessage._({
    required this.sender,
    required this.text,
    this.diagnosis,
  });

  const AiChatMessage.user(String text)
      : this._(sender: AiMessageSender.user, text: text);

  const AiChatMessage.bot(String text)
      : this._(sender: AiMessageSender.bot, text: text);

  AiChatMessage.result(AiDiagnosis diagnosis)
      : this._(
          sender: AiMessageSender.bot,
          text: diagnosis.advice,
          diagnosis: diagnosis,
        );

  bool get isDiagnosis => diagnosis != null;
}
