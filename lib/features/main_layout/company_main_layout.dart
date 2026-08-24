import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/widgets/app_drawer.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/auth/presentation/companyProfilePage.dart';
import 'package:car_care_plus/features/cars/ui/views/my_cars_view.dart';
import 'package:car_care_plus/features/home/ui/views/home_view.dart';
import 'package:car_care_plus/features/packages/ui/views/packages_catalog_view.dart';
import 'package:flutter/material.dart';

class CompanyMainLayout extends StatefulWidget {
  const CompanyMainLayout({super.key});

  @override
  State<CompanyMainLayout> createState() => _CompanyMainLayoutState();
}

class _CompanyMainLayoutState extends State<CompanyMainLayout> {
  int _currentIndex = 2;

  // القائمة الجانبية مركّبة على هذا الـ Scaffold لتغطي الشاشة كاملة
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // القائمة الخاصة بالشركة (تشترك في الهوم والطلبات وتختلف في البروفايل)
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const CompanyProfilePage(), // 👈 شاشة البروفايل الخاصة بالشركة
      const MyCarsView(),
      // 👈 نفس الهوم المشترك، والصورة الرمزية فيه تفتح القائمة الجانبية
      HomeView(onMenuPressed: () => _scaffoldKey.currentState?.openDrawer()),
      const PackagesCatalogView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: AppColors.lightBlueSurface,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBlueBlack.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surfaceWhite,
          elevation: 0,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.coolGrey,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyles.Size10.withWeight(FontWeight.bold),
          unselectedLabelStyle: TextStyles.Size10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.business_outlined),
              activeIcon: Icon(Icons.business_rounded),
              label: 'حساب الشركة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_outlined),
              activeIcon: Icon(Icons.directions_car_filled_rounded),
              label: 'الأسطول',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'طلبات الشركة',
            ),
          ],
        ),
      ),
    );
  }
}