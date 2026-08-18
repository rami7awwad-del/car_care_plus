import 'dart:async';

import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/booking_model.dart';
import '../../data/models/order_status_history_model.dart';
import '../../data/order_rules.dart';
import '../../data/order_timeline.dart';

/// مراحل دورة حياة الطلب.
///
/// الأوقات تأتي من الطلب نفسه، وسجل الحالات يضيف اسم من نفّذ كل انتقال فقط،
/// لذلك تُرسم المراحل حتى لو تعذّر جلب السجل.
class OrderTimelineWidget extends StatefulWidget {
  final BookingModel order;
  final List<OrderStatusHistoryModel> history;
  final bool isLoadingHistory;

  const OrderTimelineWidget({
    super.key,
    required this.order,
    required this.history,
    this.isLoadingHistory = false,
  });

  @override
  State<OrderTimelineWidget> createState() => _OrderTimelineWidgetState();
}

class _OrderTimelineWidgetState extends State<OrderTimelineWidget> {
  /// الطلب الجاري يحتاج عدّاداً حيّاً للوقت المنقضي
  Timer? _elapsedTicker;

  @override
  void initState() {
    super.initState();
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant OrderTimelineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTicker();
  }

  void _syncTicker() {
    final isRunning =
        OrderRules.normalizeStatus(widget.order.status) == 'in_progress';
    if (isRunning && _elapsedTicker == null) {
      _elapsedTicker = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) setState(() {});
      });
    } else if (!isRunning) {
      _elapsedTicker?.cancel();
      _elapsedTicker = null;
    }
  }

  @override
  void dispose() {
    _elapsedTicker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stages = OrderTimeline.build(widget.order, widget.history);
    final metrics = _buildMetrics(widget.order);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.timeline_rounded,
                size: 18.r,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 8.w),
              Text(
                'مراحل الطلب',
                style: TextStyles.Size15
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.bold),
              ),
              const Spacer(),
              if (widget.isLoadingHistory)
                SizedBox(
                  width: 14.r,
                  height: 14.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryBlue,
                  ),
                ),
            ],
          ),
          SizedBox(height: 18.h),

          ...List.generate(stages.length, (index) {
            return _StageRow(
              stage: stages[index],
              isLast: index == stages.length - 1,
            );
          }),

          if (metrics.isNotEmpty) ...[
            SizedBox(height: 6.h),
            const Divider(color: AppColors.borderGrey, height: 1),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: metrics
                  .map((metric) => _MetricChip(metric: metric))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// المدد كلها محسوبة في العميل — الباك اند لا يخزّن أي مدة
  List<_Metric> _buildMetrics(BookingModel order) {
    final metrics = <_Metric>[];

    final elapsed = OrderTimeline.elapsedSinceStart(order);
    if (elapsed != null) {
      metrics.add(
        _Metric(
          icon: Icons.play_circle_outline_rounded,
          label: 'جارٍ منذ',
          value: OrderTimeline.formatDuration(elapsed),
          color: AppColors.primaryBlue,
        ),
      );
    }

    final work = OrderTimeline.workDuration(order);
    if (work != null) {
      metrics.add(
        _Metric(
          icon: Icons.timer_outlined,
          label: 'مدة التنفيذ',
          value: OrderTimeline.formatDuration(work),
          color: AppColors.successColor,
        ),
      );
    }

    final punctuality = OrderTimeline.punctuality(order);
    if (punctuality != null && punctuality.inMinutes.abs() >= 5) {
      final isLate = punctuality.isNegative == false;
      metrics.add(
        _Metric(
          icon: isLate ? Icons.trending_up_rounded : Icons.trending_down_rounded,
          label: isLate ? 'تأخر البدء' : 'بدأ مبكراً',
          value: OrderTimeline.formatDuration(punctuality),
          color: isLate ? AppColors.goldAccent : AppColors.successColor,
        ),
      );
    }

    return metrics;
  }
}

class _StageRow extends StatelessWidget {
  final OrderStage stage;
  final bool isLast;

  const _StageRow({required this.stage, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(stage);
    final isReached = stage.isDone || stage.isCurrent;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العمود الزمني: نقطة المرحلة والخط الواصل
          Column(
            children: [
              Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                  color: isReached ? color : AppColors.bgLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isReached ? color : AppColors.borderGrey,
                    width: 2,
                  ),
                ),
                child: Icon(
                  _iconFor(stage),
                  size: 14.r,
                  color: isReached ? AppColors.surfaceWhite : AppColors.coolGrey,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    color: stage.isDone ? color : AppColors.borderGrey,
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          stage.title,
                          style: TextStyles.Size15
                              .withColor(
                                isReached
                                    ? AppColors.darkBlueBlack
                                    : AppColors.coolGrey,
                              )
                              .withWeight(
                                stage.isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                              ),
                        ),
                      ),
                      if (stage.isCurrent) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            'الحالة الحالية',
                            style: TextStyles.Size10
                                .withColor(color)
                                .withWeight(FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    // مرحلة بلغها الطلب لكن وقتها لم يصل من السيرفر تبقى
                    // محسوبة كمنجزة، فلا نقول عنها "لم تتم بعد"
                    stage.at != null
                        ? OrderRules.formatDateTime(stage.at)
                        : (isReached ? 'الوقت غير متاح' : 'لم تتم بعد'),
                    style: TextStyles.Size10.withColor(AppColors.coolGrey),
                  ),

                  // من نفّذ الانتقال — يأتي من سجل الحالات وحده
                  if (stage.actorName != null) ...[
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(
                          Icons.engineering_rounded,
                          size: 13.r,
                          color: AppColors.coolGrey,
                        ),
                        SizedBox(width: 5.w),
                        Flexible(
                          child: Text(
                            stage.actorName!,
                            style: TextStyles.Size10.withColor(
                              AppColors.darkBlueBlack,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (stage.detail != null) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        'السبب: ${stage.detail}',
                        style: TextStyles.Size10
                            .withColor(AppColors.darkBlueBlack)
                            .withHeight(1.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(OrderStage stage) {
    if (stage.key == OrderStageKey.cancelled) return AppColors.errorColor;
    if (stage.key == OrderStageKey.completed && stage.isDone) {
      return AppColors.successColor;
    }
    return AppColors.primaryBlue;
  }

  IconData _iconFor(OrderStage stage) {
    switch (stage.key) {
      case OrderStageKey.placed:
        return Icons.receipt_long_rounded;
      case OrderStageKey.assigned:
        return Icons.engineering_rounded;
      case OrderStageKey.inProgress:
        return Icons.build_rounded;
      case OrderStageKey.completed:
        return Icons.check_rounded;
      case OrderStageKey.cancelled:
        return Icons.close_rounded;
    }
  }
}

class _Metric {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _MetricChip extends StatelessWidget {
  final _Metric metric;

  const _MetricChip({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: metric.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(metric.icon, size: 15.r, color: metric.color),
          SizedBox(width: 7.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.label,
                style: TextStyles.Size10.withColor(AppColors.coolGrey),
              ),
              SizedBox(height: 2.h),
              Text(
                metric.value,
                style: TextStyles.Size10
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
