import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

/// فتح تطبيقات النظام (الاتصال والخرائط).
///
/// كل دالة تعيد `true` عند النجاح و`false` عند تعذّر الفتح، حتى تقرر الواجهة
/// ما تعرضه بدل أن يفشل الإجراء بصمت.
class LauncherHelper {
  const LauncherHelper._();

  /// فتح تطبيق الاتصال برقم الفرع.
  /// نستخدم DIAL لا CALL لأنه لا يحتاج إذن اتصال ويترك القرار للمستخدم.
  static Future<bool> callPhone(String phone) async {
    final sanitized = _sanitizePhone(phone);
    if (sanitized.isEmpty) return false;

    return _launch(Uri(scheme: 'tel', path: sanitized));
  }

  /// فتح موقع على الخريطة.
  ///
  /// نجرّب مخطّط `geo:` أولاً (يفتح تطبيق الخرائط المثبّت مباشرة)، ثم نعود
  /// إلى رابط الويب الذي يعمل على كل المنصات بما فيها المتصفح.
  static Future<bool> openMap({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final coordinates = '$latitude,$longitude';

    if (!kIsWeb && (Platform.isAndroid)) {
      final geoUri = Uri.parse(
        label == null || label.trim().isEmpty
            ? 'geo:$coordinates?q=$coordinates'
            : 'geo:$coordinates?q=$coordinates(${Uri.encodeComponent(label)})',
      );
      if (await _launch(geoUri)) return true;
    }

    if (!kIsWeb && Platform.isIOS) {
      final appleUri = Uri.parse('https://maps.apple.com/?ll=$coordinates&q=${Uri.encodeComponent(label ?? 'Location')}');
      if (await _launch(appleUri)) return true;
    }

    // الاحتياط: خرائط جوجل عبر المتصفح
    return _launch(
      Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$coordinates',
      ),
    );
  }

  static Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // جهاز بلا تطبيق مناسب أو رفض النظام الفتح
      return false;
    }
  }

  /// أرقام الهواتف نص حرّ بلا أي ضمان للصيغة، فنُبقي الأرقام و + فقط
  static String _sanitizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }
}
