import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/packages/data/models/package_service_model.dart';
import 'package:car_care_plus/features/packages/logic/packages_cubit.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';

class PackageDetailsBottomSheet extends StatelessWidget {
  final PackageServiceModel packageService;

  const PackageDetailsBottomSheet({super.key, required this.packageService});

  @override
  Widget build(BuildContext context) {
    final package = packageService.package;
    final service = packageService.service;

    return BlocListener<PackagesCubit, PackagesState>(
      listener: (context, state) {
        if (state is SubscribePackageSuccess) {
          final messenger = ScaffoldMessenger.of(context);

          // 1. إغلاق النافذة السفلية
          Navigator.pop(context);

          // 2. إظهار رسالة النجاح
          messenger.showSnackBar(
            SnackBar(
              content: Text('تم الاشتراك في باقة "${package.name}" بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );

          // 3. 🔄 إعادة تحميل قائمة الباقات لتحديث الشاشة وعدم تركها بيضاء
          context.read<PackagesCubit>().emitGetPackageServices();
        } else if (state is PackagesError) {
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
        child: SingleChildScrollView(
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
                    value: '${package.price} ر.س',
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
              SizedBox(height: 16.h),

              // كارت تفاصيل الخدمة المشمولة
              Text(
                'الخدمة المشمولة',
                style: TextStyles.Size15.withWeight(
                  FontWeight.bold,
                ).withColor(AppColors.darkBlueBlack),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cleaning_services_rounded,
                          color: AppColors.primaryBlue,
                          size: 20.r,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            service.nameAr,
                            style: TextStyles.Size15.withWeight(
                              FontWeight.bold,
                            ).withColor(AppColors.darkBlueBlack),
                          ),
                        ),
                      ],
                    ),
                    if (service.description != null &&
                        service.description!.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        service.description!,
                        style: TextStyles.Size10.withColor(AppColors.coolGrey),
                      ),
                    ],
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'عدد المرات المتاحة: ${packageService.allowedCount}',
                          style: TextStyles.Size10.withWeight(
                            FontWeight.w600,
                          ).withColor(AppColors.darkBlueBlack),
                        ),
                        Text(
                          'المدة: ${service.durationMinutes} دقيقة',
                          style: TextStyles.Size10.withColor(
                            AppColors.coolGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // 🔒 قسم زر الاشتراك مع شرط المنع عند وجود باقة نشطة
              BlocBuilder<PackagesCubit, PackagesState>(
                builder: (context, state) {
                  final isLoading = state is SubscribePackageLoading;

                  // 🚫 التحقق مما إذا كانت هذه الباقة أو أي باقة أخرى مفعلة حالياً لدى المستخدم
                  bool hasActivePackage = package.isActive == true;
                  if (!hasActivePackage && state is PackageServicesSuccess) {
                    hasActivePackage = state.packageServices.any(
                      (item) => item.package.isActive == true,
                    );
                  }

                  // 🛑 في حال وجود باقة نشطة لدى المستخدم
                  if (hasActivePackage) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.orange.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange.shade800,
                                size: 22.r,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'لديك باقة مفعلة حالياً. لا يمكنك الاشتراك في باقة جديدة حتى تنتهي باقتك النشطة.',
                                  style: TextStyles.Size10.withColor(
                                    Colors.orange.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: null, // 🔒 الزر معطل
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.coolGrey.withOpacity(0.2),
                              disabledBackgroundColor:
                                  AppColors.coolGrey.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'غير متاح للاشتراك حالياً',
                              style: TextStyles.Size15.withWeight(
                                FontWeight.bold,
                              ).withColor(AppColors.coolGrey),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // ✅ في حال لا توجد أي باقة مفعلة
                  return SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context
                                  .read<PackagesCubit>()
                                  .emitSubscribeToPackage(package.id);
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
                              'الاشترك في الباقة الآن',
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
        ),
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