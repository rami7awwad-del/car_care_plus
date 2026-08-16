import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:car_care_plus/features/packages/data/models/user_package_model.dart';
import 'package:car_care_plus/features/packages/logic/packages_cubit.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';
import 'package:car_care_plus/features/packages/ui/widgets/package_details_bottom_sheet.dart';

class PackagesCatalogView extends StatefulWidget {
  const PackagesCatalogView({super.key});

  @override
  State<PackagesCatalogView> createState() => _PackagesCatalogViewState();
}

class _PackagesCatalogViewState extends State<PackagesCatalogView> {
  @override
  void initState() {
    super.initState();
    context.read<PackagesCubit>().emitFetchPackagesData();
  }

  void _showPackageDetails(BuildContext context, int packageId, String packagePriceStr) {
  // 1️⃣ حفظ مرجع الـ Cubit من الـ Context الرئيسي قبل فتح الـ BottomSheet
  final packagesCubit = context.read<PackagesCubit>();
  
  // تحويل السعر من String إلى double
  final packagePrice = double.tryParse(packagePriceStr) ?? 0.0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) {
      // 2️⃣ تمرير المتغيرات المحلية بدلاً من محاولة الوصول للـ context الداخلي
      return BlocProvider.value(
        value: packagesCubit,
        child: PackageDetailsBottomSheet(
          packageId: packageId,
          packagePrice: packagePrice,
        ),
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
            context.read<PackagesCubit>().emitFetchPackagesData();
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
          } else if (state is PackagesLoadedSuccess) {
            final activeUserPackage = state.activeUserPackage;
            final availablePackages = state.availablePackages;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟢 1. قسم اشتراك المستخدم الحالي
                  Text(
                    'اشتراكك الحالي',
                    style: TextStyles.Size15.withWeight(FontWeight.bold)
                        .withColor(AppColors.darkBlueBlack),
                  ),
                  SizedBox(height: 10.h),
                  if (activeUserPackage != null)
                    _buildActivePackageCard(context, activeUserPackage)
                  else
                    _buildNoActivePackageCard(),

                  SizedBox(height: 24.h),
                  const Divider(),
                  SizedBox(height: 16.h),

                  // 🔵 2. قائمة كافة الباقات المتاحة
                  Text(
                    'كافة الباقات والخدمات',
                    style: TextStyles.Size15.withWeight(FontWeight.bold)
                        .withColor(AppColors.darkBlueBlack),
                  ),
                  SizedBox(height: 10.h),
                  if (availablePackages.isEmpty)
                    const Center(child: Text('لا توجد باقات متاحة حالياً'))
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: availablePackages.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final package = availablePackages[index];
                        return _buildPackageCard(context, package);
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

  /// 🟢 كارت الباقة المفعلة للمستخدم الحالي
  Widget _buildActivePackageCard(BuildContext context, UserPackageModel userPackage) {
    final package = userPackage.packageDetails;
    if (package == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _showPackageDetails(context, package.id, package.price),
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
                  '${package.price} ل.س',
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

  /// ⚪ كارت في حالة عدم وجود باقة نشطة
  Widget _buildNoActivePackageCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.coolGrey, size: 24.r),
          SizedBox(width: 12.w),
          Text(
            'ليس لديك باقة مفعلة حالياً',
            style: TextStyles.Size15.withColor(AppColors.coolGrey),
          ),
        ],
      ),
    );
  }

  /// 🔵 كارت الباقة العامة
  Widget _buildPackageCard(BuildContext context, PackageModel package) {
    return GestureDetector(
      onTap: () => _showPackageDetails(context, package.id, package.price),
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
                  '${package.price} ل.س',
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