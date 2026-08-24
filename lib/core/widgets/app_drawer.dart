import 'package:car_care_plus/Localization/l10n/app_localization.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/widgets/language_switcher.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_state.dart';
import 'package:car_care_plus/features/branches/ui/views/branches_view.dart';
import 'package:car_care_plus/features/notifications/logic/notifications_cubit.dart';
import 'package:car_care_plus/features/notifications/logic/notifications_state.dart';
import 'package:car_care_plus/features/notifications/ui/views/notifications_view.dart';
import 'package:car_care_plus/features/orders/logic/order_cubit.dart';
import 'package:car_care_plus/features/orders/presentation/orders_page.dart';
import 'package:car_care_plus/features/wallet_and_payments/ui/screens/wallet_screen.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// قائمة التنقّل الجانبية.
/// تُفتح من الصورة الرمزية في هيدر الصفحة الرئيسية.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _open(BuildContext context, Widget page) async {
    // نغلق القائمة أولاً حتى لا تبقى مفتوحة خلف الشاشة الجديدة
    Navigator.pop(context);
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(l10n.confirmLogoutTitle),
        content: Text(l10n.confirmLogoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // تفريغ شارة الإشعارات وإيقاف الاستطلاع قبل الخروج
              context.read<NotificationsCubit>().clear();
              context.read<AuthCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                (route) => false,
              );
            },
            child: Text(l10n.exit, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColors.bgLight,
      child: Column(
        children: [
          const _DrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              children: [
                _DrawerItem(
                  icon: Icons.storefront_rounded,
                  label: l10n.ourBranches,
                  onTap: () => _open(context, const BranchesView()),
                ),
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  buildWhen: (previous, current) =>
                      previous.unreadCount != current.unreadCount,
                  builder: (context, state) {
                    return _DrawerItem(
                      icon: Icons.notifications_rounded,
                      label: l10n.notifications,
                      badgeCount: state.unreadCount,
                      onTap: () => _open(context, const NotificationsView()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.receipt_long_rounded,
                  label: l10n.orderHistory,
                  onTap: () => _open(
                    context,
                    BlocProvider(
                      create: (_) => OrderCubit(ApiService())..fetchUserOrders(),
                      child: const OrdersPage(),
                    ),
                  ),
                ),
                _DrawerItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: l10n.wallet,
                  onTap: () => _open(context, const WalletScreen()),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: const Divider(color: AppColors.borderGrey),
                ),

                // ==================== مبدّل اللغة ====================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: const LanguageSwitcher(),
                ),
                SizedBox(height: 14.h),

                _DrawerItem(
                  icon: Icons.logout_rounded,
                  label: l10n.logout,
                  color: AppColors.errorColor,
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.mainAppGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 24.h),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              // الاسم والبريد يظهران فقط بعد تحميل البروفايل
              final user = state is AuthSuccess ? state.user : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.cyanAccent,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundColor: AppColors.royalBlue,
                      child: Text(
                        (user?.name.trim().isNotEmpty ?? false)
                            ? user!.name.trim().characters.first.toUpperCase()
                            : 'U',
                        style: TextStyles.Size24
                            .withColor(AppColors.surfaceWhite)
                            .withWeight(FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    user?.name ?? AppLocalizations.of(context)!.welcome,
                    style: TextStyles.Size18
                        .withColor(AppColors.surfaceWhite)
                        .withWeight(FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (user != null && user.email.trim().isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      user.email,
                      style: TextStyles.Size10.withColor(
                        AppColors.surfaceWhite.withOpacity(0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badgeCount;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColors.darkBlueBlack;

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: (color ?? AppColors.primaryBlue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  size: 20.r,
                  color: color ?? AppColors.primaryBlue,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyles.Size15
                      .withColor(itemColor)
                      .withWeight(FontWeight.w600),
                ),
              ),
              if (badgeCount > 0)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    badgeCount > 99 ? '+99' : '$badgeCount',
                    style: TextStyles.Size10
                        .withColor(AppColors.surfaceWhite)
                        .withWeight(FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
