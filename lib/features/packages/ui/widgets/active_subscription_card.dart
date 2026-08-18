import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/packages/data/models/user_package_model.dart';
import 'package:car_care_plus/features/packages/logic/packages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// بطاقة الاشتراك النشط — العنصر الأبرز في الشاشة،
/// تعرض ما تبقّى من الخدمات والأيام بلمحة واحدة.
class ActiveSubscriptionCard extends StatelessWidget {
  final UserPackageModel userPackage;
  final VoidCallback onTap;

  const ActiveSubscriptionCard({
    super.key,
    required this.userPackage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final package = userPackage.packageDetails;
    final daysRemaining = userPackage.daysRemaining;
    final usage = userPackage.usageRatio(package);
    final totalServices = package?.servicesCount ?? 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Ink(
        decoration: BoxDecoration(
          gradient: AppColors.darkCardGradient,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.18),
              blurRadius: 20.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: const BoxDecoration(
                            color: AppColors.successColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'اشتراك نشط',
                          style: TextStyles.Size10
                              .withColor(AppColors.successColor)
                              .withWeight(FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: AppColors.cyanAccent,
                    size: 26.r,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              Text(
                package?.name ?? 'باقتك الحالية',
                style: TextStyles.Size24
                    .withColor(AppColors.surfaceWhite)
                    .withWeight(FontWeight.bold),
              ),

              if (package?.description != null &&
                  package!.description!.trim().isNotEmpty) ...[
                SizedBox(height: 6.h),
                Text(
                  package.description!.trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.Size10
                      .withColor(AppColors.surfaceWhite.withOpacity(0.7))
                      .withHeight(1.5),
                ),
              ],

              SizedBox(height: 18.h),

              // شريط ما تبقّى من الخدمات
              if (usage != null) ...[
                Row(
                  children: [
                    Text(
                      'الخدمات المتبقية',
                      style: TextStyles.Size10.withColor(
                        AppColors.surfaceWhite.withOpacity(0.75),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${userPackage.remainingCount} من $totalServices',
                      style: TextStyles.Size10
                          .withColor(AppColors.surfaceWhite)
                          .withWeight(FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: usage,
                    minHeight: 7.h,
                    backgroundColor: AppColors.surfaceWhite.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation(
                      usage <= 0.25
                          ? AppColors.goldAccent
                          : AppColors.cyanAccent,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              Row(
                children: [
                  _Stat(
                    icon: Icons.confirmation_number_outlined,
                    label: 'متبقّي',
                    value: '${userPackage.remainingCount}',
                  ),
                  SizedBox(width: 10.w),
                  _Stat(
                    icon: Icons.event_available_rounded,
                    label: 'ينتهي خلال',
                    value: daysRemaining == null
                        ? 'غير محدد'
                        : (daysRemaining == 0
                              ? 'اليوم'
                              : '$daysRemaining يوم'),
                  ),
                ],
              ),

              SizedBox(height: 14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'عرض التفاصيل',
                    style: TextStyles.Size10
                        .withColor(AppColors.cyanAccent)
                        .withWeight(FontWeight.bold),
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 11.r,
                    color: AppColors.cyanAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _Stat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.r, color: AppColors.cyanAccent),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyles.Size10.withColor(
                      AppColors.surfaceWhite.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.Size10
                        .withColor(AppColors.surfaceWhite)
                        .withWeight(FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
