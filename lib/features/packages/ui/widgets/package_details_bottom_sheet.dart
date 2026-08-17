import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:car_care_plus/features/packages/logic/packages_cubit.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';

class PackageDetailsBottomSheet extends StatefulWidget {
  final int packageId;
  final double packagePrice;

  const PackageDetailsBottomSheet({
    super.key,
    required this.packageId,
    required this.packagePrice,
  });

  @override
  State<PackageDetailsBottomSheet> createState() => _PackageDetailsBottomSheetState();
}

class _PackageDetailsBottomSheetState extends State<PackageDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    // جلب تفاصيل الباقة عند الفتح (وليس الاشتراك)
    context.read<PackagesCubit>().emitGetPackageDetails(widget.packageId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PackagesCubit, PackagesState>(
      listener: (context, state) {
    if (state is SubscribePackageSuccess) {
      final messenger = ScaffoldMessenger.of(context);
      final cubit = context.read<PackagesCubit>();

      Navigator.pop(context);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('تم الاشتراك بالباقة بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
      cubit.emitFetchPackagesData();
    } else if (state is PackagesError) {
      // إظهار رسالة الخطأ (مثل: رصيد المحفظة غير كافٍ)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: BlocBuilder<PackagesCubit, PackagesState>(
          builder: (context, state) {
            if (state is PackageDetailsLoading) {
              return SizedBox(
                height: 250.h,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (state is PackageDetailsSuccess) {
              final package = state.packageDetails;
              return _buildPackageDetailsContent(context, package);
            }

            return SizedBox(
              height: 200.h,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPackageDetailsContent(BuildContext context, PackageModel package) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // مقبض السحب السفلي
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: AppColors.coolGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // عنوان الباقة ونوعها
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  package.name,
                  style: TextStyles.Size15.withWeight(
                    FontWeight.bold,
                  ).withColor(AppColors.darkBlueBlack),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  package.type,
                  style: TextStyles.Size10.withWeight(
                    FontWeight.bold,
                  ).withColor(AppColors.primaryBlue),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // الإحصائيات (السعر / عدد الخدمات / مدة الصلاحية)
          Row(
            children: [
              _buildInfoBadge(
                icon: Icons.payments_outlined,
                title: 'السعر',
                value: '${package.price} ل.س',
                color: Colors.green,
              ),
              SizedBox(width: 8.w),
              _buildInfoBadge(
                icon: Icons.build_outlined,
                title: 'الخدمات',
                value: '${package.servicesCount} خدمات',
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 8.w),
              _buildInfoBadge(
                icon: Icons.calendar_today_outlined,
                title: 'الصلاحية',
                value: '${package.validDays} يوم',
                color: Colors.orange,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // وصف الباقة
          Text(
            'تفاصيل الباقة',
            style: TextStyles.Size15.withWeight(
              FontWeight.bold,
            ).withColor(AppColors.darkBlueBlack),
          ),
          SizedBox(height: 8.h),
          Text(
            package.description ?? 'لا يوجد وصف إضافي لهذه الباقة.',
            style: TextStyles.Size15.withColor(AppColors.coolGrey),
          ),
          SizedBox(height: 20.h),

          // زر الاشتراك
          BlocBuilder<PackagesCubit, PackagesState>(
            builder: (context, state) {
              final isLoading = state is SubscribePackageLoading;

              return SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: isLoading
      ? null
      : () {
          context.read<PackagesCubit>().emitSubscribeToPackage(
                packageId: package.id,
              );
        },
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
    ),
  ),
  child: isLoading
      ? const CircularProgressIndicator(color: Colors.white)
      : Text(
          'الاشتراك في الباقة الآن',
          style: TextStyles.Size15.withWeight(
            FontWeight.bold,
          ).withColor(Colors.white),
        ),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20.r),
            SizedBox(height: 4.h),
            Text(title, style: TextStyles.Size10.withColor(AppColors.coolGrey)),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyles.Size10.withWeight(
                FontWeight.bold,
              ).withColor(AppColors.darkBlueBlack),
            ),
          ],
        ),
      ),
    );
  }
}