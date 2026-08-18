import 'package:car_care_plus/core/helper/responsive.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/widgets/app_drawer.dart';
import 'package:car_care_plus/features/auth/presentation/companyProfilePage.dart';
import 'package:car_care_plus/features/cars/ui/views/my_cars_view.dart';
import 'package:car_care_plus/features/home/ui/views/home_view.dart';
import 'package:car_care_plus/features/packages/ui/views/packages_catalog_view.dart';
import 'package:flutter/material.dart';

import 'widgets/app_navigation.dart';

/// القائمة الخاصة بالشركة — تشترك مع الزبون في الهوم والباقات وتختلف في
/// البروفايل وتسميات الأسطول والطلبات.
const List<AppNavDestination> _companyDestinations = [
  AppNavDestination(
    icon: Icons.business_outlined,
    activeIcon: Icons.business_rounded,
    label: 'حساب الشركة',
  ),
  AppNavDestination(
    icon: Icons.directions_car_outlined,
    activeIcon: Icons.directions_car_filled_rounded,
    label: 'الأسطول',
  ),
  AppNavDestination(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'الرئيسية',
  ),
  AppNavDestination(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long_rounded,
    label: 'طلبات الشركة',
  ),
];

class CompanyMainLayout extends StatefulWidget {
  const CompanyMainLayout({super.key});

  @override
  State<CompanyMainLayout> createState() => _CompanyMainLayoutState();
}

class _CompanyMainLayoutState extends State<CompanyMainLayout> {
  int _currentIndex = 2;

  // القائمة الجانبية مركّبة على هذا الـ Scaffold لتغطي الشاشة كاملة
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _pages = [
    const CompanyProfilePage(),
    const MyCarsView(),
    // نفس الهوم المشترك، والصورة الرمزية فيه تفتح القائمة الجانبية
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
        destinations: _companyDestinations,
        currentIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        onMenuPressed: _openDrawer,
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: useSideNav
          ? null
          : AppBottomNavigationBar(
              destinations: _companyDestinations,
              currentIndex: _currentIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
    );
  }
}
