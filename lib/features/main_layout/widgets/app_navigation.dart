import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';

/// عنصر تنقّل واحد — مصدر مشترك للشريط السفلي وللشريط الجانبي حتى لا يتفرّق
/// التعريف بين الوضعين.
class AppNavDestination {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AppNavDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// شريط التنقّل السفلي — الوضع الطولي.
class AppBottomNavigationBar extends StatelessWidget {
  final List<AppNavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNavigationBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        currentIndex: currentIndex,
        onTap: onDestinationSelected,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.coolGrey,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyles.Size10.withWeight(FontWeight.bold),
        unselectedLabelStyle: TextStyles.Size10,
        items: [
          for (final destination in destinations)
            BottomNavigationBarItem(
              icon: Icon(destination.icon),
              activeIcon: Icon(destination.activeIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}

/// شريط التنقّل الجانبي — الوضع العرضي.
///
/// ملفوف بـ SingleChildScrollView + IntrinsicHeight (النمط الموصى به في توثيق
/// NavigationRail) حتى لا يتجاوز حدوده على الشاشات القصيرة جداً.
class AppSideNavigationRail extends StatelessWidget {
  final List<AppNavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onMenuPressed;

  const AppSideNavigationRail({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceWhite,
      elevation: 2,
      shadowColor: AppColors.darkBlueBlack.withOpacity(0.2),
      child: SafeArea(
        right: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: onDestinationSelected,
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: AppColors.surfaceWhite,
                    indicatorColor: AppColors.primaryBlue.withOpacity(0.12),
                    selectedIconTheme: const IconThemeData(
                      color: AppColors.primaryBlue,
                    ),
                    unselectedIconTheme: const IconThemeData(
                      color: AppColors.coolGrey,
                    ),
                    selectedLabelTextStyle: TextStyles.Size10
                        .withColor(AppColors.primaryBlue)
                        .withWeight(FontWeight.bold),
                    unselectedLabelTextStyle:
                        TextStyles.Size10.withColor(AppColors.coolGrey),
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: IconButton(
                        onPressed: onMenuPressed,
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: AppColors.darkBlueBlack,
                        ),
                        tooltip: 'القائمة',
                      ),
                    ),
                    destinations: [
                      for (final destination in destinations)
                        NavigationRailDestination(
                          icon: Icon(destination.icon),
                          selectedIcon: Icon(destination.activeIcon),
                          label: Text(destination.label),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// يجمع الصفحات مع شريط التنقّل المناسب للاتجاه الحالي.
///
/// الشريط السفلي في الوضع الطولي، والجانبي في الوضع العرضي حيث الارتفاع هو
/// المورد النادر ويقتطع الشريط السفلي ~90 بكسل من أصل ~375.
class AppNavigationScaffoldBody extends StatelessWidget {
  final bool useSideNavigation;
  final List<AppNavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onMenuPressed;
  final Widget child;

  const AppNavigationScaffoldBody({
    super.key,
    required this.useSideNavigation,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.onMenuPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!useSideNavigation) return child;

    return Row(
      children: [
        AppSideNavigationRail(
          destinations: destinations,
          currentIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          onMenuPressed: onMenuPressed,
        ),
        Expanded(child: child),
      ],
    );
  }
}
