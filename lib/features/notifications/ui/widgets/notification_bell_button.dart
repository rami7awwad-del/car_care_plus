import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/notifications_cubit.dart';
import '../../logic/notifications_state.dart';
import '../views/notifications_view.dart';

/// جرس الإشعارات مع شارة العدد.
///
/// لا يوجد Push من الباك اند حالياً (قناة FCM معطّلة ولا يوجد endpoint لتسجيل
/// التوكن)، لذلك يقوم هذا الودجت بتشغيل استطلاع خفيف لعدد غير المقروء أثناء
/// وجود التطبيق في المقدمة فقط، ويوقفه عند ذهابه للخلفية.
class NotificationBellButton extends StatefulWidget {
  /// لون الأيقونة — فاتح فوق الهيدر المتدرّج وداكن فوق الخلفيات البيضاء
  final Color iconColor;
  final Color backgroundColor;

  const NotificationBellButton({
    super.key,
    this.iconColor = AppColors.surfaceWhite,
    this.backgroundColor = const Color(0x26FFFFFF),
  });

  @override
  State<NotificationBellButton> createState() => _NotificationBellButtonState();
}

class _NotificationBellButtonState extends State<NotificationBellButton>
    with WidgetsBindingObserver {
  // نحتفظ بمرجع للـ Cubit لأن قراءة context ممنوعة داخل dispose
  late final NotificationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cubit = context.read<NotificationsCubit>();
    _cubit.startBadgePolling();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cubit.startBadgePolling();
    } else {
      _cubit.stopBadgePolling();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // لا نترك مؤقتاً يعمل بعد اختفاء الجرس
    _cubit.stopBadgePolling();
    super.dispose();
  }

  Future<void> _openNotifications() async {
    final cubit = _cubit;
    await Navigator.push(
      context,
      MaterialPageRoute(
        // الشاشة تستخدم نفس الـ Cubit حتى تبقى الشارة متزامنة معها
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const NotificationsView(),
        ),
      ),
    );
    if (!mounted) return;
    await cubit.refreshUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      buildWhen: (previous, current) =>
          previous.unreadCount != current.unreadCount,
      builder: (context, state) {
        final count = state.unreadCount;

        return InkWell(
          onTap: _openNotifications,
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  count > 0
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  color: widget.iconColor,
                  size: 23.r,
                ),
              ),
              if (count > 0)
                Positioned(
                  top: -2.h,
                  right: -2.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: count > 9 ? 5.w : 0,
                    ),
                    constraints: BoxConstraints(minWidth: 18.w),
                    height: 18.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.errorColor,
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(
                        color: AppColors.surfaceWhite,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      count > 99 ? '+99' : '$count',
                      textAlign: TextAlign.center,
                      style: TextStyles.Size10
                          .withColor(AppColors.surfaceWhite)
                          .withWeight(FontWeight.bold)
                          .withSize(9),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
