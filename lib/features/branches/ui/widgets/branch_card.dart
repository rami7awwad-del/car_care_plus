import 'package:car_care_plus/core/helper/launcher_helper.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/branch_model.dart';

class BranchCard extends StatelessWidget {
  final BranchModel branch;

  /// المسافة محسوبة محلياً للعرض فقط، وتكون null إذا لم يُشارك الموقع
  final double? distanceKm;
  final VoidCallback onTap;

  const BranchCard({
    super.key,
    required this.branch,
    required this.onTap,
    this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    final hours = branch.formattedWorkingHours;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueSurface,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    color: AppColors.primaryBlue,
                    size: 24.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.displayName,
                        style: TextStyles.Size15
                            .withColor(AppColors.darkBlueBlack)
                            .withWeight(FontWeight.bold),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        branch.city,
                        style: TextStyles.Size10.withColor(AppColors.coolGrey),
                      ),
                    ],
                  ),
                ),
                if (distanceKm != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${distanceKm!.toStringAsFixed(1)} كم',
                      style: TextStyles.Size10
                          .withColor(AppColors.primaryBlue)
                          .withWeight(FontWeight.bold),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14.r,
                  color: AppColors.coolGrey,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    branch.address,
                    style: TextStyles.Size10
                        .withColor(AppColors.darkBlueBlack)
                        .withHeight(1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                // is_24h هو الإشارة الوحيدة الموثوقة لأوقات العمل
                if (branch.is24h)
                  const _Tag(
                    icon: Icons.access_time_filled_rounded,
                    label: 'مفتوح 24 ساعة',
                    color: AppColors.successColor,
                  )
                else if (hours != null)
                  _Tag(
                    icon: Icons.schedule_rounded,
                    label: hours,
                    color: AppColors.primaryBlue,
                  ),
                // الاتصال مباشرة من القائمة دون فتح التفاصيل
                if (branch.phone.trim().isNotEmpty)
                  _Tag(
                    icon: Icons.call_rounded,
                    label: branch.phone,
                    color: AppColors.successColor,
                    onTap: () async {
                      final launched = await LauncherHelper.callPhone(
                        branch.phone,
                      );
                      if (!context.mounted || launched) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تعذر فتح تطبيق الاتصال'),
                          backgroundColor: AppColors.errorColor,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _Tag({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13.r, color: color),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyles.Size10
                  .withColor(AppColors.darkBlueBlack)
                  .withWeight(FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
