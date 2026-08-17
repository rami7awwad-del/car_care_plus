import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import '../../data/models/booking_quote_response_model.dart';

// تظهر عند الدفع بالباقة دون تحديدها: يختار العميل باقة ثم يُعاد التسعير
class PackageSelectionBottomSheet extends StatelessWidget {
  final List<AvailablePackage> packages;
  final ValueChanged<int> onSelect;

  const PackageSelectionBottomSheet({
    super.key,
    required this.packages,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.7.sh),
      padding: EdgeInsets.fromLTRB(24.r, 12.r, 24.r, 24.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.borderGrey,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'اختر باقة للحجز',
            style: TextStyles.Size24
                .withWeight(FontWeight.bold)
                .withColor(AppColors.darkBlueBlack),
          ),
          SizedBox(height: 4.h),
          Text(
            'اختر الباقة التي تريد استخدامها لتغطية هذا الحجز',
            style: TextStyles.Size15.withColor(AppColors.coolGrey),
          ),
          SizedBox(height: 16.h),
          if (packages.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  'لا توجد باقات متاحة لهذا الحجز',
                  style: TextStyles.Size15.withColor(AppColors.coolGrey),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: packages.length,
                separatorBuilder: (_, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  return InkWell(
                    onTap: () => onSelect(pkg.id),
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.bgLight,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.borderGrey),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46.w,
                            height: 46.h,
                            decoration: BoxDecoration(
                              color: AppColors.lightGoldSurface,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Icon(
                              Icons.card_giftcard_rounded,
                              color: AppColors.goldAccent,
                              size: 24.r,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Text(
                              pkg.name,
                              style: TextStyles.Size15
                                  .withWeight(FontWeight.bold)
                                  .withColor(AppColors.darkBlueBlack),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.r,
                            color: AppColors.coolGrey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
