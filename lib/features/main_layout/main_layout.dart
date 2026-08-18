import 'package:car_care_plus/core/helper/responsive.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/widgets/app_drawer.dart';
import 'package:car_care_plus/features/auth/presentation/profile_page.dart';
import 'package:car_care_plus/features/cars/ui/views/my_cars_view.dart';
import 'package:car_care_plus/features/home/ui/views/home_view.dart';
import 'package:car_care_plus/features/packages/ui/views/packages_catalog_view.dart';
import 'package:flutter/material.dart';

import 'widgets/app_navigation.dart';

/// الترتيب من اليمين لليسار (RTL):
/// 0 حسابي · 1 الكراج · 2 الرئيسية · 3 طلباتي
const List<AppNavDestination> _customerDestinations = [
  AppNavDestination(
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    label: 'حسابي',
  ),
  AppNavDestination(
    icon: Icons.directions_car_outlined,
    activeIcon: Icons.directions_car_filled_rounded,
    label: 'الكراج',
  ),
  AppNavDestination(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'الرئيسية',
  ),
  AppNavDestination(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long_rounded,
    label: 'طلباتي',
  ),
];

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // نبدأ افتراضياً على الواجهة الرئيسية (Index 2)
  int _currentIndex = 2;

  // القائمة الجانبية مركّبة على هذا الـ Scaffold لتغطي الشاشة كاملة،
  // والصفحات الداخلية لها Scaffold خاص بها، لذلك نفتحها عبر مفتاح
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _pages = [
    const ProfilePage(),
    const MyCarsView(),
    HomeView(onMenuPressed: _openDrawer),
    const PackagesCatalogView(),
  ];

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _onDestinationSelected(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final useSideNav = context.useSideNavigation;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: AppColors.lightBlueSurface,
      body: AppNavigationScaffoldBody(
        useSideNavigation: useSideNav,
        destinations: _customerDestinations,
        currentIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        onMenuPressed: _openDrawer,
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: useSideNav
          ? null
          : AppBottomNavigationBar(
              destinations: _customerDestinations,
              currentIndex: _currentIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
    );
  }
}
