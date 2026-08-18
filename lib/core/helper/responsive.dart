import 'package:flutter/widgets.dart';

/// نقاط الانكسار المعتمدة في التطبيق (بالبكسل المنطقي، قبل أي تحويل بـ ScreenUtil).
///
/// نعتمد على العرض الفعلي للنافذة لا على نوع الجهاز، حتى يعمل نفس المنطق على
/// الهاتف بالوضع العرضي وعلى التابلت وعلى النوافذ المقسّمة.
abstract class Breakpoints {
  /// أقل من هذا العرض: عمود واحد (هاتف بالوضع الطولي)
  static const double compact = 600;

  /// عمودان (هاتف بالوضع العرضي وتابلت صغير)
  static const double medium = 900;

  /// ثلاثة أعمدة (تابلت كبير وشاشات سطح المكتب)
  static const double expanded = 1200;
}

enum ScreenSize { compact, medium, expanded }

/// اختصارات القياس المتجاوب.
///
/// كل القيم تُقرأ عبر `MediaQuery.*Of` حتى يُعاد بناء الودجت المستدعي وحده عند
/// تغيّر الأبعاد بدل إعادة بناء الشجرة كاملة.
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;
  bool get isPortrait => !isLandscape;

  ScreenSize get screenSize {
    final width = screenWidth;
    if (width >= Breakpoints.expanded) return ScreenSize.expanded;
    if (width >= Breakpoints.compact) return ScreenSize.medium;
    return ScreenSize.compact;
  }

  bool get isCompact => screenSize == ScreenSize.compact;

  /// شريط تنقّل جانبي بدل السفلي في الوضع العرضي:
  /// الارتفاع هو المورد النادر هناك، والشريط السفلي يقتطع منه ~90 بكسل.
  bool get useSideNavigation => isLandscape;

  /// عدد أعمدة شبكة البطاقات (الخدمات والباقات).
  int get contentColumns {
    switch (screenSize) {
      case ScreenSize.expanded:
        return 3;
      case ScreenSize.medium:
        return 2;
      case ScreenSize.compact:
        return 1;
    }
  }

  /// الهامش الأفقي للمحتوى — يتّسع تدريجياً على الشاشات العريضة حتى لا يمتد
  /// النص بعرض الشاشة كاملاً فيصعب تتبّعه.
  double get contentGutter {
    switch (screenSize) {
      case ScreenSize.expanded:
        return 32;
      case ScreenSize.medium:
        return 24;
      case ScreenSize.compact:
        return 20;
    }
  }

  /// أقصى عرض يُسمح للمحتوى بأخذه على الشاشات الكبيرة جداً
  double get maxContentWidth => 1100;
}

/// يحصر عرض المحتوى ويوسّطه على الشاشات العريضة، ويمرّره كما هو على الهاتف.
class ResponsiveContentBox extends StatelessWidget {
  final Widget child;

  const ResponsiveContentBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.maxContentWidth),
        child: child,
      ),
    );
  }
}
