import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/notifications/logic/notifications_cubit.dart';
import 'package:car_care_plus/features/rating/ui/views/create_rating_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/booking_model.dart';
import '../data/order_rules.dart';
import '../data/repos/order_actions_repo.dart';
import '../logic/order_actions_cubit.dart';
import '../logic/order_actions_state.dart';
import 'rebook_page.dart';
import 'widgets/cancel_booking_sheet.dart';
import 'widgets/order_timeline_widget.dart';

/// تفاصيل الطلب مع إجراءاته: إعادة الحجز وإلغاء الحجز.
///
/// تُرجع `true` عند مغادرتها إذا تغيّر شيء يستدعي تحديث سجل الطلبات.
class OrderDetailsPage extends StatelessWidget {
  final BookingModel order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderActionsCubit(OrderActionsRepo())..loadOrderTimeline(order.id),
      child: _OrderDetailsBody(order: order),
    );
  }
}

class _OrderDetailsBody extends StatefulWidget {
  final BookingModel order;

  const _OrderDetailsBody({required this.order});

  @override
  State<_OrderDetailsBody> createState() => _OrderDetailsBodyState();
}

class _OrderDetailsBodyState extends State<_OrderDetailsBody> {
  late BookingModel _order = widget.order;

  /// هل حدث تغيير يستدعي تحديث القائمة عند الرجوع؟
  bool _didChange = false;

  Future<void> _onCancelPressed() async {
    final blockedReason = OrderRules.cancelBlockedReason(_order);
    if (blockedReason != null) {
      _showMessage(blockedReason);
      return;
    }

    final reason = await CancelBookingSheet.show(context, _order);
    if (reason == null || !mounted) return;

    await context.read<OrderActionsCubit>().cancelBooking(
      bookingId: _order.id,
      cancelReason: reason,
    );
  }

  Future<void> _onRebookPressed() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => RebookPage(order: _order)),
    );
    if (created == true && mounted) {
      setState(() => _didChange = true);
      _showMessage('تم إنشاء الحجز الجديد', isError: false);
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          backgroundColor: isError
              ? AppColors.errorColor
              : AppColors.successColor,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _didChange);
      },
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        body: BlocConsumer<OrderActionsCubit, OrderActionsState>(
          listener: (context, state) {
            if (state is CancelBookingSuccessState) {
              // الردّ يعود بالحجز محمّلاً بالكامل، فنحدّث الشاشة منه مباشرة
              setState(() {
                _order = state.cancelledBooking;
                _didChange = true;
              });
              _showMessage('تم إلغاء الحجز بنجاح', isError: false);
              // الإلغاء يغيّر المحفظة والنقاط ويُرسل إشعاراً بعد ثوانٍ
              context.read<NotificationsCubit>().refreshUnreadCount();
            }

            if (state is OrderTimelineSuccessState) {
              // نسخة التفاصيل أحدث وأكمل من كائن القائمة
              final fresh = context.read<OrderActionsCubit>().freshOrder;
              if (fresh != null) setState(() => _order = fresh);
            }

            if (state is CancelBookingErrorState) {
              _showMessage(state.message);
            }
          },
          builder: (context, state) {
            final isCancelling = state is CancelBookingLoadingState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(order: _order),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                    children: [
                      _SummaryCard(order: _order),
                      SizedBox(height: 16.h),
                      // مراحل دورة حياة الطلب
                      OrderTimelineWidget(
                        order: _order,
                        history: context
                            .read<OrderActionsCubit>()
                            .statusHistory,
                        isLoadingHistory: state is OrderTimelineLoadingState,
                      ),
                      SizedBox(height: 16.h),
                      _DetailsCard(order: _order),
                      SizedBox(height: 20.h),
                      _ActionsSection(
                        order: _order,
                        isCancelling: isCancelling,
                        onRebook: _onRebookPressed,
                        onCancel: _onCancelPressed,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final BookingModel order;

  const _Header({required this.order});

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 22.h),
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
                  'تفاصيل الطلب',
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
              ),
              _StatusPill(status: order.status),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            order.service?.nameAr ?? order.service?.name ?? 'خدمة',
            style: TextStyles.Size18
                .withColor(AppColors.surfaceWhite)
                .withWeight(FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            'رقم الطلب #${order.id}',
            style: TextStyles.Size10.withColor(
              AppColors.surfaceWhite.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final BookingModel order;

  const _SummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(order.totalPrice) ?? 0.0;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: AppColors.darkCardGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.12),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الإجمالي المدفوع',
                style: TextStyles.Size10.withColor(
                  AppColors.surfaceWhite.withOpacity(0.75),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '${price.toStringAsFixed(0)} ل.س',
                style: TextStyles.Size28
                    .withColor(AppColors.cyanAccent)
                    .withWeight(FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 32.r,
              color: AppColors.cyanAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final BookingModel order;

  const _DetailsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final scheduled = OrderRules.scheduledAt(order);
    final deadline = OrderRules.cancelDeadline(order);
    final canCancel = OrderRules.canCancel(order);

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.04),
            blurRadius: 14.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.event_rounded,
            label: 'الموعد',
            value: OrderRules.formatDateTime(scheduled),
          ),
          if (order.car != null)
            _DetailRow(
              icon: Icons.directions_car_rounded,
              label: 'السيارة',
              value: '${order.car!.model} (${order.car!.plateNumber})',
            ),
          if (order.workshop != null)
            _DetailRow(
              icon: Icons.storefront_rounded,
              label: 'الورشة',
              value: order.workshop!.nameAr.isNotEmpty
                  ? order.workshop!.nameAr
                  : order.workshop!.name,
            ),
          _DetailRow(
            icon: Icons.info_outline_rounded,
            label: 'الحالة',
            value: OrderRules.statusLabel(order.status),
          ),
          if (order.notes != null && order.notes!.trim().isNotEmpty)
            _DetailRow(
              icon: Icons.sticky_note_2_outlined,
              label: 'ملاحظات',
              value: order.notes!,
            ),
          // نُظهر المهلة قبل أن يصطدم المستخدم برفض من السيرفر
          if (canCancel && deadline != null)
            _DetailRow(
              icon: Icons.timer_outlined,
              label: 'الإلغاء متاح حتى',
              value: OrderRules.formatDateTime(deadline),
              isLast: true,
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: AppColors.lightBlueSurface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 18.r, color: AppColors.primaryBlue),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyles.Size10.withColor(AppColors.coolGrey),
                ),
                SizedBox(height: 3.h),
                Text(
                  value,
                  style: TextStyles.Size15
                      .withColor(AppColors.darkBlueBlack)
                      .withWeight(FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  final BookingModel order;
  final bool isCancelling;
  final VoidCallback onRebook;
  final VoidCallback onCancel;

  const _ActionsSection({
    required this.order,
    required this.isCancelling,
    required this.onRebook,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final canRebook = OrderRules.canRebook(order);
    final canCancel = OrderRules.canCancel(order);
    final blockedReason = OrderRules.cancelBlockedReason(order);
    final isCompleted = OrderRules.normalizeStatus(order.status) == 'completed';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canRebook) ...[
          SizedBox(
            height: 52.h,
            child: ElevatedButton.icon(
              onPressed: onRebook,
              icon: Icon(
                Icons.refresh_rounded,
                size: 20.r,
                color: AppColors.surfaceWhite,
              ),
              label: Text(
                'إعادة الطلب',
                style: TextStyles.Size15
                    .withColor(AppColors.surfaceWhite)
                    .withWeight(FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],

        if (isCompleted) ...[
          SizedBox(
            height: 52.h,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateRatingView(orderId: order.id),
                ),
              ),
              icon: Icon(
                Icons.star_rounded,
                size: 20.r,
                color: AppColors.goldAccent,
              ),
              label: Text(
                'قيّم الخدمة',
                style: TextStyles.Size15
                    .withColor(AppColors.goldAccent)
                    .withWeight(FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.goldAccent, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],

        if (canCancel)
          SizedBox(
            height: 52.h,
            child: OutlinedButton.icon(
              onPressed: isCancelling ? null : onCancel,
              icon: isCancelling
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.errorColor,
                      ),
                    )
                  : Icon(
                      Icons.event_busy_rounded,
                      size: 20.r,
                      color: AppColors.errorColor,
                    ),
              label: Text(
                isCancelling ? 'جارٍ الإلغاء' : 'إلغاء الحجز',
                style: TextStyles.Size15
                    .withColor(AppColors.errorColor)
                    .withWeight(FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.errorColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          )
        // بدل زر معطّل بلا تفسير، نوضّح لماذا لا يمكن الإلغاء
        else if (blockedReason != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.lightBlueSurface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey.withOpacity(0.6)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18.r,
                  color: AppColors.coolGrey,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    blockedReason,
                    style: TextStyles.Size10.withColor(AppColors.darkBlueBlack),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.surfaceWhite.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        OrderRules.statusLabel(status),
        style: TextStyles.Size10
            .withColor(AppColors.surfaceWhite)
            .withWeight(FontWeight.bold),
      ),
    );
  }
}