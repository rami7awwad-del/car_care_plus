import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';

class WalletBalanceCard extends StatelessWidget {
  final String balance;
  final VoidCallback? onChargePressed;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    this.onChargePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الرصيد المتاح',
                style: TextStyles.Size15.withColor(
                  AppColors.surfaceWhite.withOpacity(0.8),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.cyanAccent,
                      size: 16.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'محفظتي',
                      style: TextStyles.Size10
                          .withColor(AppColors.surfaceWhite)
                          .withWeight(FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                balance,
                style: TextStyles.Size32
                    .withColor(AppColors.surfaceWhite)
                    .withWeight(FontWeight.bold),
              ),
              SizedBox(width: 6.w),
              Text(
                'ر.س',
                style: TextStyles.Size15
                    .withColor(AppColors.cyanAccent)
                    .withWeight(FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceWhite,
                foregroundColor: AppColors.primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              onPressed: onChargePressed ?? () {},
              icon: Icon(Icons.add_circle_outline_rounded, size: 20.r),
              label: Text(
                'شحن الرصيد',
                style: TextStyles.Size15
                    .withColor(AppColors.primaryBlue)
                    .withWeight(FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}