import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/routing/app_routes.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueSurface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.hourglass_top_rounded,
                  size: 50.r,
                  color: Colors.amber[700],
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'الحساب قيد المراجعة',
                style: TextStyles.Size24
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'تم تسجيل حساب الشركة بنجاح. جاري مراجعة طلبك وتفعيل الحساب من قبل الإدارة، يرجى الانتظار.',
                style: TextStyles.Size15.withColor(AppColors.coolGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 36.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.login,
                      (route) => false,
                    );
                  },
                  child: Text(
                    'تسجيل الخروج والعودة',
                    style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}