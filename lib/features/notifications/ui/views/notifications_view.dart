import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/notifications_cubit.dart';
import '../../logic/notifications_state.dart';
import '../notification_deep_link.dart';
import '../widgets/notification_item_widget.dart';

/// شاشة الإشعارات — تعتمد على NotificationsCubit المتاح على مستوى التطبيق
/// حتى تبقى شارة العدد في الواجهة الرئيسية متزامنة مع ما يجري هنا
class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NotificationsCubit>().fetchNotifications();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300.h) {
      context.read<NotificationsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: BlocConsumer<NotificationsCubit, NotificationsState>(
        listenWhen: (previous, current) =>
            current.errorMessage != null &&
            current.status == NotificationsStatus.success &&
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          // أخطاء العمليات (تعليم كمقروء) تُعرض كتنبيه دون كسر القائمة
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.errorColor,
              ),
            );
        },
        builder: (context, state) {
          final cubit = context.read<NotificationsCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(state: state, onMarkAllRead: cubit.markAllAsRead),
              _FilterBar(
                unreadOnly: state.unreadOnly,
                onChanged: cubit.toggleUnreadOnly,
              ),
              Expanded(child: _buildBody(context, state, cubit)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationsState state,
    NotificationsCubit cubit,
  ) {
    if (state.status == NotificationsStatus.loading && state.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      );
    }

    if (state.status == NotificationsStatus.error && state.items.isEmpty) {
      return _ErrorRetry(
        message: state.errorMessage ?? 'تعذر جلب الإشعارات',
        onRetry: cubit.fetchNotifications,
      );
    }

    if (state.items.isEmpty) {
      return _EmptyNotifications(unreadOnly: state.unreadOnly);
    }

    return RefreshIndicator(
      color: AppColors.primaryBlue,
      onRefresh: cubit.fetchNotifications,
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
        itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryBlue),
              ),
            );
          }

          final notification = state.items[index];
          return NotificationItemWidget(
            notification: notification,
            onTap: () async {
              // تحديث تفاؤلي أولاً ثم الانتقال للشاشة المرتبطة إن وُجدت
              await cubit.markAsRead(notification);
              if (!context.mounted) return;
              await NotificationDeepLink.open(context, notification);
            },
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final NotificationsState state;
  final Future<void> Function() onMarkAllRead;

  const _Header({required this.state, required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    final unreadCount = state.unreadCount;

    return GradientHeader(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.surfaceWhite,
                  size: 22.r,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'الإشعارات',
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
              ),
              Icon(
                Icons.notifications_active_rounded,
                color: AppColors.cyanAccent,
                size: 26.r,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  unreadCount > 0
                      ? 'لديك $unreadCount إشعار غير مقروء'
                      : 'لا توجد إشعارات غير مقروءة',
                  style: TextStyles.Size15.withColor(
                    unreadCount > 0
                        ? AppColors.cyanAccent
                        : AppColors.surfaceWhite.withOpacity(0.75),
                  ),
                ),
              ),
              if (unreadCount > 0)
                InkWell(
                  onTap: onMarkAllRead,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.surfaceWhite.withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.done_all_rounded,
                          color: AppColors.surfaceWhite,
                          size: 15.r,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'تعليم الكل',
                          style: TextStyles.Size10
                              .withColor(AppColors.surfaceWhite)
                              .withWeight(FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final bool unreadOnly;
  final ValueChanged<bool> onChanged;

  const _FilterBar({required this.unreadOnly, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      child: Row(
        children: [
          _FilterChip(
            label: 'الكل',
            isSelected: !unreadOnly,
            onTap: () => onChanged(false),
          ),
          SizedBox(width: 10.w),
          _FilterChip(
            label: 'غير المقروءة',
            isSelected: unreadOnly,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderGrey,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.Size10
              .withColor(
                isSelected ? AppColors.surfaceWhite : AppColors.darkBlueBlack,
              )
              .withWeight(FontWeight.bold),
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  final bool unreadOnly;

  const _EmptyNotifications({required this.unreadOnly});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.w,
              height: 88.h,
              decoration: BoxDecoration(
                color: AppColors.lightBlueSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                unreadOnly
                    ? Icons.mark_email_read_rounded
                    : Icons.notifications_off_rounded,
                size: 40.r,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              unreadOnly ? 'لا توجد إشعارات غير مقروءة' : 'لا توجد إشعارات بعد',
              style: TextStyles.Size18
                  .withColor(AppColors.darkBlueBlack)
                  .withWeight(FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              unreadOnly
                  ? 'اطّلعت على كل شيء 👌'
                  : 'ستصلك هنا تحديثات طلباتك ومحفظتك',
              textAlign: TextAlign.center,
              style: TextStyles.Size15.withColor(AppColors.coolGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.r,
              color: AppColors.errorColor,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              child: Text(
                'إعادة المحاولة',
                style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
