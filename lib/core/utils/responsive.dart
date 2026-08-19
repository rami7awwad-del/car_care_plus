import 'package:flutter/material.dart';

/// أدوات التجاوب المشتركة.
///
/// القاعدة في التطبيق: لا نكتب أرقاماً ثابتة لارتفاع الشاشة ولا نفترض أن
/// الجهاز في الوضع الطولي. كل شاشة تسأل الـ context عن حالته وتبني تخطيطها
/// عليها، حتى تعمل الواجهة على الهاتف والجهاز اللوحي وفي الوضعين الطولي
/// والعرضي بدون كسر أو تجاوز في التخطيط.
extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  /// الوضع العرضي — الارتفاع المتاح فيه شحيح جداً على الهواتف
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// جهاز لوحي (أقصر ضلع ٦٠٠ فأكثر)
  bool get isTablet => screenSize.shortestSide >= 600;

  /// شاشة قصيرة: هاتف مستلقٍ أو نافذة مقسّمة — نقلّل الارتفاعات فيها
  bool get isShortScreen => screenHeight < 520;

  /// عدد أعمدة شبكة البطاقات بحسب العرض المتاح
  int get contentColumns {
    final width = screenWidth;
    if (width >= 1150) return 3;
    if (width >= 680) return 2;
    return 1;
  }

  /// الهامش الأفقي الموحّد للمحتوى
  double get hPadding {
    if (isTablet) return 28;
    return isLandscape ? 24 : 20;
  }
}

/// يحسب عدد الأعمدة من عرض فعلي (داخل LayoutBuilder مثلاً) لا من عرض الشاشة
int columnsForWidth(double width) {
  if (width >= 1150) return 3;
  if (width >= 680) return 2;
  return 1;
}
