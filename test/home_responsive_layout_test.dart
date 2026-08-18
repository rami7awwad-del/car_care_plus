import 'package:car_care_plus/core/helper/responsive.dart';
import 'package:car_care_plus/features/home/data/models/category_model.dart';
import 'package:car_care_plus/features/home/data/models/service_model.dart';
import 'package:car_care_plus/features/home/ui/widgets/categories_list_widget.dart';
import 'package:car_care_plus/features/home/ui/widgets/home_promo_banner.dart';
import 'package:car_care_plus/features/home/ui/widgets/services_list_widget.dart';
import 'package:car_care_plus/features/main_layout/widgets/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// أحجام تغطّي الوضعين الطولي والعرضي على الهاتف والتابلت.
/// (العرض، الارتفاع) بالبكسل المنطقي.
const _viewports = <String, Size>{
  'هاتف صغير - طولي': Size(320, 640),
  'هاتف - طولي': Size(375, 812),
  'هاتف - عرضي': Size(812, 375),
  'هاتف كبير - عرضي': Size(915, 411),
  'تابلت - طولي': Size(768, 1024),
  'تابلت - عرضي': Size(1024, 768),
};

/// مقاس التصميم المرجعي يتبع الاتجاه — نفس المنطق المطبّق في `main.dart`
Size _designSizeFor(Size viewport) => viewport.width > viewport.height
    ? const Size(812, 375)
    : const Size(375, 812);

List<ServiceModel> _services({int count = 5}) => List.generate(
      count,
      (index) => ServiceModel(
        id: index + 1,
        categoryId: 1,
        name: 'Service $index',
        // اسم طويل عمداً لاختبار القص لا التجاوز
        nameAr: 'غسيل وتلميع شامل بالبخار للسيارات الكبيرة $index',
        description:
            'خدمة متكاملة تشمل التنظيف الداخلي والخارجي وتلميع الهيكل '
            'ومعالجة الخدوش السطحية وتعقيم المقصورة بالكامل.',
        basePrice: 129.75,
        isVipAvailable: index.isEven,
        vipExtraPrice: 15,
        durationMinutes: 120,
      ),
    );

List<CategoryModel> _categories({int count = 6}) => List.generate(
      count,
      (index) => CategoryModel(
        id: index + 1,
        name: 'Category $index',
        nameAr: 'قسم الصيانة الدورية $index',
        isActive: true,
      ),
    );

/// يبني الودجت داخل نفس بيئة التطبيق: RTL و ScreenUtil ومقاس شاشة محدّد.
Future<void> _pumpAtSize(
  WidgetTester tester,
  Size viewport,
  Widget child, {
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: _designSizeFor(viewport),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MediaQuery(
        data: MediaQueryData(
          size: viewport,
          textScaler: TextScaler.linear(textScale),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: child),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('شبكة الخدمات لا تتجاوز حدودها', () {
    _viewports.forEach((name, viewport) {
      testWidgets(name, (tester) async {
        await _pumpAtSize(
          tester,
          viewport,
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ServicesListWidget(services: _services()),
            ),
          ),
        );

        // أي تجاوز في التخطيط يرفع استثناءً يلتقطه tester
        expect(tester.takeException(), isNull);
        expect(find.byType(ServiceCard), findsNWidgets(5));
      });
    });

    testWidgets('عمود واحد في الوضع الطولي وعمودان في العرضي', (tester) async {
      // طولي: كل بطاقة تأخذ العرض كاملاً
      await _pumpAtSize(
        tester,
        const Size(375, 812),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ServicesListWidget(services: _services(count: 2)),
        ),
      );
      final portraitWidth = tester.getSize(find.byType(ServiceCard).first).width;
      expect(portraitWidth, closeTo(375 - 40, 1));

      // عرضي: بطاقتان جنباً إلى جنب، أي أقل من نصف العرض المتاح
      await _pumpAtSize(
        tester,
        const Size(812, 375),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ServicesListWidget(services: _services(count: 2)),
        ),
      );
      final landscapeWidth =
          tester.getSize(find.byType(ServiceCard).first).width;
      expect(landscapeWidth, lessThan((812 - 40) / 2 + 1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('لا تجاوز مع تكبير الخط لأقصى حد مسموح (1.3)', (tester) async {
      await _pumpAtSize(
        tester,
        const Size(812, 375),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ServicesListWidget(services: _services(count: 3)),
          ),
        ),
        textScale: 1.3,
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('شريط الأقسام واللافتة الترويجية', () {
    _viewports.forEach((name, viewport) {
      testWidgets('الأقسام - $name', (tester) async {
        await _pumpAtSize(
          tester,
          viewport,
          CategoriesListWidget(
            categories: _categories(),
            selectedCategoryId: 2,
            onCategorySelected: (_) {},
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('اللافتة الترويجية - $name', (tester) async {
        await _pumpAtSize(
          tester,
          viewport,
          const Padding(
            padding: EdgeInsets.all(20),
            child: HomePromoBanner(),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    });
  });

  group('شريط التنقّل', () {
    const destinations = [
      AppNavDestination(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'حسابي',
      ),
      AppNavDestination(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'الرئيسية',
      ),
    ];

    testWidgets('الشريط السفلي في الطولي والجانبي في العرضي', (tester) async {
      Widget body(bool useSideNavigation) => AppNavigationScaffoldBody(
            useSideNavigation: useSideNavigation,
            destinations: destinations,
            currentIndex: 1,
            onDestinationSelected: (_) {},
            onMenuPressed: () {},
            child: const SizedBox.expand(),
          );

      await _pumpAtSize(tester, const Size(375, 812), body(false));
      expect(find.byType(NavigationRail), findsNothing);
      expect(tester.takeException(), isNull);

      await _pumpAtSize(tester, const Size(812, 375), body(true));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('الشريط الجانبي لا يتجاوز حدوده على شاشة قصيرة جداً',
        (tester) async {
      await _pumpAtSize(
        tester,
        const Size(640, 300),
        Row(
          children: [
            AppSideNavigationRail(
              destinations: destinations,
              currentIndex: 0,
              onDestinationSelected: (_) {},
              onMenuPressed: () {},
            ),
            const Expanded(child: SizedBox.expand()),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('نقاط الانكسار', () {
    testWidgets('عدد الأعمدة والتنقّل الجانبي يتبعان العرض والاتجاه',
        (tester) async {
      late BuildContext capturedContext;

      Future<void> pump(Size viewport) => _pumpAtSize(
            tester,
            viewport,
            Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          );

      await pump(const Size(375, 812));
      expect(capturedContext.contentColumns, 1);
      expect(capturedContext.useSideNavigation, isFalse);
      expect(capturedContext.isPortrait, isTrue);

      await pump(const Size(812, 375));
      expect(capturedContext.contentColumns, 2);
      expect(capturedContext.useSideNavigation, isTrue);

      await pump(const Size(1280, 800));
      expect(capturedContext.contentColumns, 3);
    });
  });
}
