import 'package:car_care_plus/features/packages/ui/widgets/package_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/packages/data/models/package_service_model.dart';
import 'package:car_care_plus/features/packages/logic/packages_cubit.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';

class PackagesCatalogView extends StatefulWidget {
  const PackagesCatalogView({super.key});

  @override
  State<PackagesCatalogView> createState() => _PackagesCatalogViewState();
}

class _PackagesCatalogViewState extends State<PackagesCatalogView> {
  @override
  void initState() {
    super.initState();
    context.read<PackagesCubit>().emitGetPackageServices();
  }

  void _showPackageDetails(BuildContext context, PackageServiceModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return BlocProvider.value(
          value: context.read<PackagesCubit>(),
          child: PackageDetailsBottomSheet(packageService: item),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        title: Text(
          'باقات الصيانة والخدمات',
          style: TextStyles.Size18.withWeight(FontWeight.bold)
              .withColor(AppColors.darkBlueBlack),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<PackagesCubit, PackagesState>(
        listener: (context, state) {
          if (state is SubscribePackageSuccess) {
            context.read<PackagesCubit>().emitGetPackageServices();
          }
        },
        builder: (context, state) {
          if (state is PackagesLoading || state is SubscribePackageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PackagesError) {
            return Center(
              child: Text(
                state.error,
                style: TextStyles.Size15.withColor(Colors.red),
              ),
            );
          } else if (state is PackageServicesSuccess) {
            final list = state.packageServices;

            if (list.isEmpty) {
              return const Center(child: Text('لا توجد باقات متاحة حالياً'));
            }

            // تصفية الباقات المفعلة عن غير المفعلة
            final activeItems = list.where((item) => item.package.isActive == true).toList();

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟢 1. قسم الباقة المفعلة حالياً (يظهر فقط إذا كان هناك اشتراك نشط)
                  if (activeItems.isNotEmpty) ...[
                    Text(
                      'باقتك المفعلة حالياً',
                      style: TextStyles.Size15.withWeight(FontWeight.bold)
                          .withColor(AppColors.darkBlueBlack),
                    ),
                    SizedBox(height: 10.h),
                    ...activeItems.map((item) => _buildActivePackageCard(context, item)),
                    SizedBox(height: 24.h),
                    const Divider(),
                    SizedBox(height: 16.h),
                  ],

                  // 🔵 2. قائمة كافة الباقات المتاحة
                  Text(
                    'كافة الباقات والخدمات',
                    style: TextStyles.Size15.withWeight(FontWeight.bold)
                        .withColor(AppColors.darkBlueBlack),
                  ),
                  SizedBox(height: 10.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return _buildPackageCard(context, item);
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  /// 🟢 كارت الباقة المفعلة (أعلى الصفحة)
  Widget _buildActivePackageCard(BuildContext context, PackageServiceModel item) {
    final package = item.package;
    return GestureDetector(
      onTap: () => _showPackageDetails(context, item),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.green, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadowColor,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شارة الاشتراك النشط
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.white, size: 14.r),
                      SizedBox(width: 4.w),
                      Text(
                        'مفعلة ونشطة',
                        style: TextStyles.Size10.withWeight(FontWeight.bold)
                            .withColor(Colors.white),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${package.price} ر.س',
                  style: TextStyles.Size15.withWeight(FontWeight.bold)
                      .withColor(Colors.green),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.green,
                    size: 28.r,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.name,
                        style: TextStyles.Size15.withWeight(FontWeight.bold)
                            .withColor(AppColors.darkBlueBlack),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'تتضمن ${package.servicesCount} خدمات • صالحة لمدة ${package.validDays} يوم',
                        style: TextStyles.Size10.withColor(AppColors.coolGrey),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  size: 20.r,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔵 كارت الباقة العادية
  Widget _buildPackageCard(BuildContext context, PackageServiceModel item) {
    final package = item.package;
    return GestureDetector(
      onTap: () => _showPackageDetails(context, item),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadowColor,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.card_membership_rounded,
                color: AppColors.primaryBlue,
                size: 28.r,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name,
                    style: TextStyles.Size15.withWeight(FontWeight.bold)
                        .withColor(AppColors.darkBlueBlack),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'تتضمن ${package.servicesCount} خدمات • صالحة لمدة ${package.validDays} يوم',
                    style: TextStyles.Size10.withColor(AppColors.coolGrey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${package.price} ر.س',
                  style: TextStyles.Size15.withWeight(FontWeight.bold)
                      .withColor(AppColors.primaryBlue),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      'التفاصيل',
                      style: TextStyles.Size10.withColor(AppColors.coolGrey),
                    ),
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 16.r,
                      color: AppColors.coolGrey,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}