import 'package:flutter/material.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/home/presentation/home_page.dart';
import 'package:car_care_plus/features/orders/presentation/orders_page.dart';
import 'package:car_care_plus/features/profile/presentation/profile_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // نبدأ افتراضياً على الواجهة الوسطى (الرئيسية)
  int _currentIndex = 1;

  // الترتيب مع RTL: البروفايل يميناً، الرئيسية وسطاً، الطلبات يساراً
  final List<Widget> _pages = const [
    ProfilePage(),
    HomePage(),
    OrdersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueSurface,
      body: IndexedStack(index: _currentIndex, children: _pages),
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
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'حسابي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'طلباتي',
            ),
          ],
        ),
      ),
    );
  }
}
