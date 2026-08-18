import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// لافتة العرض الترويجي أسفل الهيدر مباشرة.
///
/// المحتوى ثابت حالياً — لا يوجد endpoint للعروض في الباك اند بعد.
class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: AppColors.cyanGlowGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withOpacity(0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkBlueBlack.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'خصم خاص 20%',
                    style: TextStyles.Size10
                        .withWeight(FontWeight.bold)
                        .withColor(AppColors.surfaceWhite),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'عناية كاملة بسيارتك',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.Size18
                      .withWeight(FontWeight.bold)
                      .withColor(AppColors.darkBlueBlack),
                ),
                SizedBox(height: 4.h),
                Text(
                  'احجز باقة الغسيل والتلميع الشامل الآن',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.Size10.withColor(
                    AppColors.darkBlueBlack.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Icon(
            Icons.directions_car_filled_rounded,
            size: 54.r,
            color: AppColors.darkBlueBlack.withOpacity(0.85),
          ),
        ],
      ),
    );
  }
}
