import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/booking/data/repos/booking_repo.dart';
import 'package:car_care_plus/features/booking/logic/booking_cubit.dart';
import 'package:car_care_plus/features/booking/ui/views/booking_setup_view.dart';
import 'package:car_care_plus/features/cars/data/models/car_model.dart';
import 'package:car_care_plus/features/cars/data/repos/cars_repo.dart';
import 'package:car_care_plus/features/cars/logic/cars_cubit.dart';
import 'package:car_care_plus/features/cars/logic/cars_state.dart';
import 'package:car_care_plus/features/materials/data/models/material_model.dart';
import 'package:car_care_plus/features/materials/data/repos/materials_repo.dart';
import 'package:car_care_plus/features/materials/logic/materials_cubit.dart';
import 'package:car_care_plus/features/service_details/data/repos/service_details_repo.dart';
import 'package:car_care_plus/features/service_details/logic/service_details_cubit.dart';
import 'package:car_care_plus/features/service_details/logic/service_details_state.dart';
import 'package:car_care_plus/features/sub_services/data/repo/sub_service_repo.dart';
import 'package:car_care_plus/features/sub_services/logic/sub_service_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/booking_bottom_bar.dart';
import '../widgets/service_info_section.dart';

class ServiceDetailsView extends StatefulWidget {
  final int serviceId;

  const ServiceDetailsView({super.key, required this.serviceId});

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView> {
  // السيارة المحددة من بيانات السيرفر
  CarModel? selectedCar;

  // معرفات المواد المحددة
  final List<int> selectedMaterialIds = [];

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ServiceDetailsCubit(ServiceDetailsRepo(apiService))
                ..getServiceDetails(widget.serviceId),
        ),
        BlocProvider(
          create: (context) =>
              SubServiceCubit(SubServiceRepo(apiService))
                ..fetchSubServices(widget.serviceId),
        ),
        BlocProvider(
          create: (context) => CarsCubit(CarsRepo(apiService))..getUserCars(),
        ),
        BlocProvider(
          create: (context) =>
              MaterialsCubit(MaterialsRepo(apiService))..fetchMaterials(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        body: BlocBuilder<ServiceDetailsCubit, ServiceDetailsState>(
          builder: (context, state) {
            if (state is ServiceDetailsLoadingState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 48.r,
                      height: 48.r,
                      child: const CircularProgressIndicator(
                        color: AppColors.primaryBlue,
                        strokeWidth: 3.5,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'جاري تحضير تفاصيل الخدمة...',
                      style: TextStyles.Size15.withColor(AppColors.coolGrey),
                    ),
                  ],
                ),
              );
            }

            if (state is ServiceDetailsErrorState) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: AppColors.errorColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.errorColor,
                          size: 48.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyles.Size15.withColor(
                          AppColors.darkBlueBlack,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<ServiceDetailsCubit>().getServiceDetails(
                                widget.serviceId,
                              );
                          context.read<SubServiceCubit>().fetchSubServices(
                                widget.serviceId,
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 28.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                        label: Text(
                          'إعادة المحاولة',
                          style: TextStyles.Size15.withWeight(FontWeight.bold)
                              .withColor(AppColors.surfaceWhite),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ServiceDetailsSuccessState) {
              final service = state.serviceDetails;

              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // ==================== SliverAppBar عصري وبدون أي صور ====================
                        SliverAppBar(
                          expandedHeight: 180.h,
                          pinned: true,
                          elevation: 0,
                          backgroundColor: AppColors.darkBlueBlack,
                          leading: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: AppColors.headerGradient,
                              ),
                              child: Stack(
                                children: [
                                  // عناصر جمالية خلفية
                                  Positioned(
                                    top: -40.h,
                                    right: -30.w,
                                    child: Container(
                                      width: 140.r,
                                      height: 140.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.cyanAccent.withOpacity(0.08),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 40.h,
                                    left: -20.w,
                                    child: Container(
                                      width: 100.r,
                                      height: 100.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryBlue.withOpacity(0.15),
                                      ),
                                    ),
                                  ),
                                  // كبسولة العنوان الرئيسية
                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20.h),
                                        Container(
                                          padding: EdgeInsets.all(14.r),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: AppColors.buttonGradient,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primaryBlue.withOpacity(0.4),
                                                blurRadius: 20,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.auto_awesome_rounded,
                                            color: AppColors.surfaceWhite,
                                            size: 30.sp,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          service.name,
                                          style: TextStyles.Size24
                                              .withWeight(FontWeight.bold)
                                              .withColor(AppColors.surfaceWhite),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // انحناء أسفل الهيدر
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 20.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.bgLight,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(24.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 1. معلومات الخدمة
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: ServiceInfoSection(service: service),
                          ),
                        ),

                        // 2. اختيار السيارة
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  title: 'اختيار السيارة',
                                  icon: Icons.directions_car_filled_rounded,
                                ),
                                SizedBox(height: 12.h),
                                _buildCarSelectionTile(),
                              ],
                            ),
                          ),
                        ),

                        // 3. الخدمات الفرعية
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  title: 'الخدمات الفرعية والإضافات',
                                  icon: Icons.tune_rounded,
                                ),
                                SizedBox(height: 12.h),
                                _buildSubServicesSection(),
                              ],
                            ),
                          ),
                        ),

                        // 4. المواد والقطع المضافة
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              24.h,
                              20.w,
                              28.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  title: 'المواد والقطع المضافة',
                                  icon: Icons.widgets_rounded,
                                ),
                                SizedBox(height: 12.h),
                                _buildMaterialsSection(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==================== الشريط السفلي لحساب التكلفة ====================
                  BlocBuilder<SubServiceCubit, SubServiceState>(
                    builder: (context, subState) {
                      final subCubit = context.read<SubServiceCubit>();
                      final materialsCubit = context.watch<MaterialsCubit>();

                      double subServicesPrice = subCubit.selectedSubServices
                          .fold(0.0, (sum, item) => sum + item.price);

                      double materialsPrice = materialsCubit.materials
                          .where(
                            (item) => selectedMaterialIds.contains(item.id),
                          )
                          .fold(0.0, (sum, item) => sum + item.price);

                      double finalPrice =
                          service.basePrice + subServicesPrice + materialsPrice;

                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkBlueBlack.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, -6),
                            ),
                          ],
                        ),
                        child: BookingBottomBar(
                          price: finalPrice,
                          discountPrice: service.vipExtraPrice != null
                              ? (service.vipExtraPrice! +
                                  subServicesPrice +
                                  materialsPrice)
                              : null,
                          onBookingPressed: () {
                            if (selectedCar == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8.w),
                                      const Text('يرجى تحديد السيارة أولاً'),
                                    ],
                                  ),
                                  backgroundColor: AppColors.errorColor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              );
                              return;
                            }

                            final selectedSubServiceIds = subCubit
                                .selectedSubServices
                                .map((e) => e.id)
                                .toList();

                            final selectedMaterials = selectedMaterialIds.map((
                              id,
                            ) {
                              return {
                                'material_id': id,
                                'quantity': 1,
                              };
                            }).toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => BookingCubit(
                                    BookingRepo(apiService),
                                  ),
                                  child: BookingSetupView(
                                    serviceId: widget.serviceId,
                                    carIds: [selectedCar!.id],
                                    categoryName: service.category?.name,
                                    subServiceIds:
                                        selectedSubServiceIds.isNotEmpty
                                            ? selectedSubServiceIds
                                            : null,
                                    materials: selectedMaterials.isNotEmpty
                                        ? selectedMaterials
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// رأس القسم المميز بأيقونة وكبسولة نيون
  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 20.r,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyles.Size18.withWeight(FontWeight.bold)
              .withColor(AppColors.darkBlueBlack),
        ),
      ],
    );
  }

  /// زر بطاقة اختيار السيارة
  Widget _buildCarSelectionTile() {
    final hasSelectedCar = selectedCar != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showCarSelectionSheet(context),
        borderRadius: BorderRadius.circular(18.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: hasSelectedCar
                  ? AppColors.primaryBlue
                  : AppColors.borderGrey,
              width: hasSelectedCar ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: hasSelectedCar
                    ? AppColors.primaryBlue.withOpacity(0.12)
                    : AppColors.cardShadowColor,
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: hasSelectedCar
                      ? AppColors.primaryBlue.withOpacity(0.1)
                      : AppColors.bgLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_car_filled_rounded,
                  color: hasSelectedCar
                      ? AppColors.primaryBlue
                      : AppColors.coolGrey,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasSelectedCar
                          ? '${selectedCar!.model} (${selectedCar!.year})'
                          : 'اضغط لاختيار السيارة من الكاراج',
                      style: TextStyles.Size15.withWeight(
                        FontWeight.bold,
                      ).withColor(
                        hasSelectedCar
                            ? AppColors.darkBlueBlack
                            : AppColors.coolGrey,
                      ),
                    ),
                    if (hasSelectedCar) ...[
                      SizedBox(height: 2.h),
                      Text(
                        'رقم اللوحة: ${selectedCar!.plateNumber}',
                        style: TextStyles.Size10.withColor(AppColors.coolGrey),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.swap_vert_rounded,
                color: hasSelectedCar
                    ? AppColors.primaryBlue
                    : AppColors.coolGrey,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// القائمة السفلية لاختيار السيارات
  void _showCarSelectionSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: parentContext.read<CarsCubit>(),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            padding: EdgeInsets.only(
              left: 20.r,
              right: 20.r,
              top: 12.r,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20.r,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.borderGrey,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'اختر السيارة المحددة للحجز',
                  style: TextStyles.Size18.withWeight(FontWeight.bold)
                      .withColor(AppColors.darkBlueBlack),
                ),
                SizedBox(height: 16.h),
                Flexible(
                  child: BlocBuilder<CarsCubit, CarsState>(
                    builder: (context, state) {
                      if (state is CarsLoadingState) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        );
                      }

                      final carsList = context.read<CarsCubit>().cars;

                      if (carsList.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Center(
                            child: Text(
                              'لا توجد سيارات مضافة بالكاراج الخاص بك.',
                              style: TextStyles.Size15.withColor(
                                AppColors.coolGrey,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: carsList.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final car = carsList[index];
                          final isSelected = selectedCar?.id == car.id;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCar = car;
                                });
                                Navigator.pop(sheetContext);
                              },
                              borderRadius: BorderRadius.circular(16.r),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.all(14.r),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryBlue.withOpacity(0.06)
                                      : AppColors.surfaceWhite,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : AppColors.borderGrey,
                                    width: isSelected ? 1.8 : 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.directions_car_rounded,
                                      color: isSelected
                                          ? AppColors.primaryBlue
                                          : AppColors.coolGrey,
                                      size: 26.sp,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${car.model} (${car.year})',
                                            style: TextStyles.Size15.withWeight(
                                              FontWeight.bold,
                                            ).withColor(
                                              AppColors.darkBlueBlack,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            'اللوحة: ${car.plateNumber}',
                                            style: TextStyles.Size10.withColor(
                                              AppColors.coolGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.primaryBlue,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// قسم الخدمات الفرعية
  Widget _buildSubServicesSection() {
    return BlocBuilder<SubServiceCubit, SubServiceState>(
      builder: (context, state) {
        final cubit = context.read<SubServiceCubit>();

        if (state is SubServiceLoadingState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
          );
        }

        final subServicesList =
            state is SubServiceSuccessState ? state.subServices : [];

        if (subServicesList.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Text(
              'لا توجد خدمات فرعية متاحة حالياً.',
              style: TextStyles.Size15.withColor(AppColors.coolGrey),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subServicesList.length,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final subService = subServicesList[index];
            final isSelected = cubit.selectedSubServices.contains(subService);

            return Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.borderGrey,
                    width: isSelected ? 1.8 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppColors.primaryBlue.withOpacity(0.08)
                          : AppColors.cardShadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CheckboxListTile(
                  activeColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 4.h,
                  ),
                  title: Text(
                    subService.nameAr.isNotEmpty
                        ? subService.nameAr
                        : subService.name,
                    style: TextStyles.Size15.withWeight(
                      FontWeight.bold,
                    ).withColor(AppColors.darkBlueBlack),
                  ),
                  subtitle: Text(
                    subService.description,
                    style: TextStyles.Size10.withColor(AppColors.coolGrey),
                  ),
                  secondary: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '+${subService.price} ل.س',
                      style: TextStyles.Size15.withWeight(
                        FontWeight.bold,
                      ).withColor(AppColors.primaryBlue),
                    ),
                  ),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      cubit.toggleSubServiceSelection(subService);
                    });
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// قسم المواد والقطع المضافة
  Widget _buildMaterialsSection() {
    return BlocBuilder<MaterialsCubit, MaterialsState>(
      builder: (context, state) {
        if (state is MaterialsLoadingState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
          );
        }

        if (state is MaterialsErrorState) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.errorColor.withOpacity(0.4)),
            ),
            child: Text(
              'حدث خطأ أثناء جلب المواد: ${state.message}',
              style: TextStyles.Size15.withColor(AppColors.errorColor),
            ),
          );
        }

        final List<MaterialModel> materialsList =
            state is MaterialsSuccessState
                ? state.materials
                : context.read<MaterialsCubit>().materials;

        if (materialsList.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Text(
              'لا توجد مواد مضافة مسجلة.',
              style: TextStyles.Size15.withColor(AppColors.coolGrey),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: materialsList.length,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final material = materialsList[index];
            final isSelected = selectedMaterialIds.contains(material.id);

            return Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.borderGrey,
                    width: isSelected ? 1.8 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppColors.primaryBlue.withOpacity(0.08)
                          : AppColors.cardShadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CheckboxListTile(
                  activeColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 4.h,
                  ),
                  title: Text(
                    material.nameAr.isNotEmpty
                        ? material.nameAr
                        : material.name,
                    style: TextStyles.Size15.withWeight(
                      FontWeight.bold,
                    ).withColor(AppColors.darkBlueBlack),
                  ),
                  subtitle: material.description != null
                      ? Text(
                          material.description!,
                          style: TextStyles.Size10.withColor(AppColors.coolGrey),
                        )
                      : null,
                  secondary: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '+${material.price} ل.س',
                      style: TextStyles.Size15.withWeight(
                        FontWeight.bold,
                      ).withColor(AppColors.primaryBlue),
                    ),
                  ),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (isSelected) {
                        selectedMaterialIds.remove(material.id);
                      } else {
                        selectedMaterialIds.add(material.id);
                      }
                    });
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}