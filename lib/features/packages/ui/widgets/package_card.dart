import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// بطاقة باقة في القائمة.
///
/// تأخذ ثلاثة أشكال:
/// - **باقتك الحالية**: مميّزة بالأخضر بلا زر اشتراك.
/// - **مقفلة**: باهتة مع سبب واضح (يوجد اشتراك نشط، أو الباقة غير متاحة).
/// - **متاحة**: بزر اشتراك فعّال.
class PackageCard extends StatelessWidget {
  final PackageModel package;
  final bool isCurrentSubscription;
  final bool isLocked;
  final String? lockedReason;
  final bool isSubscribing;
  final VoidCallback onTap;

  /// `null` يعني أن الاشتراك غير مسموح الآن
  final VoidCallback? onSubscribe;

  const PackageCard({
    super.key,
    required this.package,
    required this.onTap,
    this.isCurrentSubscription = false,
    this.isLocked = false,
    this.lockedReason,
    this.isSubscribing = false,
    this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isCurrentSubscription
        ? AppColors.successColor
        : AppColors.primaryBlue;
    // الباقات المقفلة تبهت بصرياً حتى لا تنافس الباقة المتاحة على الانتباه
    final isDimmed = isLocked && !isCurrentSubscription;

    return Opacity(
      opacity: isDimmed ? 0.62 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isCurrentSubscription
                  ? AppColors.successColor
                  : AppColors.borderGrey,
              width: isCurrentSubscription ? 1.5 : 1,
            ),
            boxShadow: isDimmed
                ? null
                : [
                    BoxShadow(
                      color: AppColors.darkBlueBlack.withOpacity(0.05),
                      blurRadius: 14.r,
                      offset: Offset(0, 5.h),
                    ),
                  ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        isCurrentSubscription
                            ? Icons.verified_rounded
                            : Icons.card_membership_rounded,
                        color: accent,
                        size: 25.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  package.name,
                                  style: TextStyles.Size15
                                      .withColor(AppColors.darkBlueBlack)
                                      .withWeight(FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isCurrentSubscription) ...[
                                SizedBox(width: 8.w),
                                _Chip(
                                  label: 'باقتك الحالية',
                                  color: AppColors.successColor,
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            package.description?.trim().isNotEmpty == true
                                ? package.description!.trim()
                                : 'باقة خدمات من كار كير بلس',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.Size10
                                .withColor(AppColors.coolGrey)
                                .withHeight(1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),
                Row(
                  children: [
                    _Meta(
                      icon: Icons.build_rounded,
                      label: '${package.servicesCount} خدمات',
                    ),
                    SizedBox(width: 8.w),
                    _Meta(
                      icon: Icons.calendar_month_rounded,
                      label: '${package.validDays} يوم',
                    ),
                    if (_discountLabel != null) ...[
                      SizedBox(width: 8.w),
                      _Meta(
                        icon: Icons.local_offer_rounded,
                        label: _discountLabel!,
                        color: AppColors.goldAccent,
                      ),
                    ],
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: const Divider(height: 1, color: AppColors.borderGrey),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السعر',
                          style: TextStyles.Size10.withColor(
                            AppColors.coolGrey,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${package.price} ل.س',
                          style: TextStyles.Size18
                              .withColor(accent)
                              .withWeight(FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildAction(),
                  ],
                ),

                // سبب القفل يُشرح بدل ترك زر معطّل بلا تفسير
                if (isDimmed && lockedReason != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 9.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgLight,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14.r,
                          color: AppColors.coolGrey,
                        ),
                        SizedBox(width: 7.w),
                        Expanded(
                          child: Text(
                            lockedReason!,
                            style: TextStyles.Size10
                                .withColor(AppColors.coolGrey)
                                .withHeight(1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAction() {
    if (isCurrentSubscription) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 16.r,
            color: AppColors.successColor,
          ),
          SizedBox(width: 5.w),
          Text(
            'مفعّلة',
            style: TextStyles.Size10
                .withColor(AppColors.successColor)
                .withWeight(FontWeight.bold),
          ),
        ],
      );
    }

    if (onSubscribe == null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: AppColors.bgLight,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          'غير متاح',
          style: TextStyles.Size10
              .withColor(AppColors.coolGrey)
              .withWeight(FontWeight.bold),
        ),
      );
    }

    return SizedBox(
      height: 38.h,
      child: ElevatedButton(
        onPressed: isSubscribing ? null : onSubscribe,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          disabledBackgroundColor: AppColors.coolGrey,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: isSubscribing
            ? SizedBox(
                width: 15.r,
                height: 15.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.surfaceWhite,
                ),
              )
            : Text(
                'اشترك',
                style: TextStyles.Size10
                    .withColor(AppColors.surfaceWhite)
                    .withWeight(FontWeight.bold),
              ),
      ),
    );
  }

  String? get _discountLabel {
    final raw = package.discountPct;
    if (raw == null || raw.trim().isEmpty) return null;
    final value = double.tryParse(raw);
    if (value == null || value <= 0) return null;
    return 'خصم ${value.toStringAsFixed(0)}%';
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _Meta({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final tone = color ?? AppColors.coolGrey;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: tone.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.r, color: tone),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyles.Size10
                .withColor(AppColors.darkBlueBlack)
                .withWeight(FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyles.Size10.withColor(color).withWeight(FontWeight.bold),
      ),
    );
  }
}
