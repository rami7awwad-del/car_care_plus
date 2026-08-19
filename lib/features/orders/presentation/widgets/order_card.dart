import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/notifications/logic/notifications_cubit.dart';
import 'package:car_care_plus/features/orders/data/booking_model.dart';
import 'package:car_care_plus/features/orders/data/order_rules.dart';
import 'package:car_care_plus/features/orders/data/repos/order_actions_repo.dart';
import 'package:car_care_plus/features/orders/logic/order_actions_cubit.dart';
import 'package:car_care_plus/features/orders/logic/order_actions_state.dart';
import 'package:car_care_plus/features/orders/presentation/order_details_page.dart';
import 'package:car_care_plus/features/orders/presentation/rebook_page.dart';
import 'package:car_care_plus/features/orders/presentation/widgets/cancel_booking_sheet.dart';
import 'package:car_care_plus/features/rating/ui/views/create_rating_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCard extends StatelessWidget {
  final BookingModel order;

  /// يُستدعى بعد أي إجراء يغيّر الطلب (إلغاء أو إنشاء حجز جديد) لتحديث السجل
  final VoidCallback? onChanged;

  const OrderCard({super.key, required this.order, this.onChanged});

  @override
  Widget build(BuildContext context) {
    // الـ Cubit خاص بهذه البطاقة حتى لا تتأثر بقية البطاقات بحالة التحميل
    return BlocProvider(
      create: (_) => OrderActionsCubit(OrderActionsRepo()),
      child: _OrderCardBody(order: order, onChanged: onChanged),
    );
  }
}

class _OrderCardBody extends StatelessWidget {
  final BookingModel order;
  final VoidCallback? onChanged;

  const _OrderCardBody({required this.order, this.onChanged});

  Future<void> _openDetails(BuildContext context) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailsPage(order: order)),
    );
    if (changed == true) onChanged?.call();
  }

  Future<void> _openRebook(BuildContext context) async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => RebookPage(order: order)),
    );
    if (created == true) onChanged?.call();
  }

  Future<void> _cancel(BuildContext context) async {
    final blockedReason = OrderRules.cancelBlockedReason(order);
    if (blockedReason != null) {
      _showMessage(context, blockedReason);
      return;
    }

    final reason = await CancelBookingSheet.show(context, order);
    if (reason == null || !context.mounted) return;

    await context.read<OrderActionsCubit>().cancelBooking(
      bookingId: order.id,
      cancelReason: reason,
    );
  }

  void _showMessage(BuildContext context, String message, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: isError
              ? AppColors.errorColor
              : AppColors.successColor,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final double parsedPrice = double.tryParse(order.totalPrice) ?? 0.0;
    final bool isCompleted =
        OrderRules.normalizeStatus(order.status) == 'completed';
    final bool canRebook = OrderRules.canRebook(order);
    final bool canCancel = OrderRules.canCancel(order);

    return BlocConsumer<OrderActionsCubit, OrderActionsState>(
      listener: (context, state) {
        if (state is CancelBookingSuccessState) {
          _showMessage(context, 'تم إلغاء الحجز بنجاح', isError: false);
          // الإلغاء يعيد المبلغ والنقاط ويُرسل إشعاراً بعد ثوانٍ
          context.read<NotificationsCubit>().refreshUnreadCount();
          onChanged?.call();
        }
        if (state is CancelBookingErrorState) {
          _showMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final isCancelling = state is CancelBookingLoadingState;

        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderGrey.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBlueBlack.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _openDetails(context),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: الخدمة والحالة
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.lightBlueSurface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.build_circle_rounded,
                            color: AppColors.primaryBlue,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.service?.nameAr ??
                                    order.service?.name ??
                                    'خدمة صيانة',
                                style: TextStyles.Size15
                                    .withColor(AppColors.darkBlueBlack)
                                    .withWeight(FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'رقم الطلب: #${order.id}',
                                style: TextStyles.Size10.withColor(
                                  AppColors.coolGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusChip(status: order.status),
                      ],
                    ),

                    // التفاصيل الإضافية (اسم الورشة / السيارة إن وجدوا)
                    if (order.workshop != null || order.car != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueSurface.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            if (order.workshop != null) ...[
                              const Icon(
                                Icons.storefront_rounded,
                                size: 15,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  order.workshop?.nameAr ??
                                      order.workshop?.name ??
                                      '',
                                  style: TextStyles.Size10
                                      .withColor(AppColors.darkBlueBlack)
                                      .withWeight(FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            if (order.workshop != null && order.car != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  width: 1,
                                  height: 12,
                                  color: AppColors.borderGrey,
                                ),
                              ),
                            if (order.car != null) ...[
                              const Icon(
                                Icons.directions_car_rounded,
                                size: 15,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${order.car?.model} (${order.car?.plateNumber})',
                                style: TextStyles.Size10
                                    .withColor(AppColors.darkBlueBlack)
                                    .withWeight(FontWeight.w500),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: AppColors.borderGrey),
                    ),

                    // Footer: التاريخ والسعر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: AppColors.coolGrey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              OrderRules.formatDateTime(
                                OrderRules.scheduledAt(order),
                              ),
                              style: TextStyles.Size10.withColor(
                                AppColors.coolGrey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${parsedPrice.toStringAsFixed(0)} ل.س',
                          style: TextStyles.Size15
                              .withColor(AppColors.primaryBlue)
                              .withWeight(FontWeight.bold),
                        ),
                      ],
                    ),

                    // أزرار الإجراءات.
                    if (canRebook || canCancel) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (canRebook)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _openRebook(context),
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 16,
                                  color: AppColors.primaryBlue,
                                ),
                                label: Text(
                                  'إعادة الطلب',
                                  style: TextStyles.Size10
                                      .withColor(AppColors.primaryBlue)
                                      .withWeight(FontWeight.bold),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.primaryBlue,
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),

                          if (canRebook && isCompleted) const SizedBox(width: 8),

                          if (isCompleted)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CreateRatingView(orderId: order.id),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: AppColors.surfaceWhite,
                                ),
                                label: Text(
                                  'قيّم الخدمة',
                                  style: TextStyles.Size10
                                      .withColor(AppColors.surfaceWhite)
                                      .withWeight(FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.goldAccent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),

                          if (canCancel)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: isCancelling
                                    ? null
                                    : () => _cancel(context),
                                icon: isCancelling
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.errorColor,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.event_busy_rounded,
                                        size: 16,
                                        color: AppColors.errorColor,
                                      ),
                                label: Text(
                                  isCancelling ? 'جارٍ الإلغاء' : 'إلغاء الحجز',
                                  style: TextStyles.Size10
                                      .withColor(AppColors.errorColor)
                                      .withWeight(FontWeight.bold),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.errorColor,
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  Color _getStatusColor(String status) {
    switch (OrderRules.normalizeStatus(status)) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'assigned':
        return Colors.teal;
      case 'cancelled':
        return Colors.red;
      case 'in_progress':
        return Colors.blue;
      default:
        return AppColors.coolGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Text(
        OrderRules.statusLabel(status),
        style: TextStyles.Size10.withColor(color).withWeight(FontWeight.bold),
      ),
    );
  }
}