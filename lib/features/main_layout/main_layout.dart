import 'package:car_care_plus/features/auth/presentation/profile_page.dart';
import 'package:car_care_plus/features/cars/ui/views/my_cars_view.dart';
import 'package:car_care_plus/features/home/ui/views/home_view.dart';
import 'package:car_care_plus/features/packages/ui/views/packages_catalog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/widgets/app_drawer.dart';
import 'package:car_care_plus/core/resources/text_style.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // نبدأ افتراضياً على الواجهة الرئيسية (Index 2)
  int _currentIndex = 2;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // الترتيب من اليمين لليسار (RTL):
  // 0: حسابي (البروفايل)
  // 1: الكراج (سياراتي)
  // 2: الرئيسية
  // 3: الباقات
  late final List<Widget> _pages = [
    const ProfilePage(),
    const MyCarsView(),
    HomeView(onMenuPressed: () => _scaffoldKey.currentState?.openDrawer()),
    const PackagesCatalogView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: AppColors.lightBlueSurface,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildCustomNavigationBar(),
    );
  }

  /// بناء شريط التنقل السفلي بتدرج داكن ولمسات ذهبية
  Widget _buildCustomNavigationBar() {
    return Container(
      margin: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
      ),
      height: 70.h,
      decoration: BoxDecoration(
        // تدرج الخلفية الداكن للتطبيق
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.35),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'حسابي',
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.directions_car_outlined,
              activeIcon: Icons.directions_car_filled_rounded,
              label: 'الكراج',
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'الرئيسية',
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.inventory_2_outlined,
              activeIcon: Icons.inventory_2_rounded,
              label: 'الباقات',
            ),
          ],
        ),
      ),
    );
  }

  /// عنصر التنقل الفردي
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    // تحديد لون الأيقونة والنص (ذهبي عند التحديد، وأبيض هادئ عند عدم التحديد)
    final unselectedColor = AppColors.surfaceWhite.withOpacity(0.75);

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16.w : 0,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                // خلفية شفافة باللون الذهبي عند التحديد
                color: isSelected
                    ? AppColors.goldAccent.withOpacity(0.18)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                // ذهبي للمحدد، وأبيض شفاف للغير محدد
                color: isSelected ? AppColors.goldAccent : unselectedColor,
                size: 24.r,
              ),
            ),
            SizedBox(height: 2.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: isSelected
                  ? TextStyles.Size10.withWeight(FontWeight.bold).withColor(AppColors.goldAccent)
                  : TextStyles.Size10.withColor(unselectedColor),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}