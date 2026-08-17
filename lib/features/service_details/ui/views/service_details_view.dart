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
  // السيارة المحددة من بيانات السيرفر Real Data
  CarModel? selectedCar;

  // معرفات المواد المحددة Real Data
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
        backgroundColor: const Color(0xFFF8FAFC),
        body: BlocBuilder<ServiceDetailsCubit, ServiceDetailsState>(
          builder: (context, state) {
            if (state is ServiceDetailsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryBlue),
              );
            }

            if (state is ServiceDetailsErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.errorColor,
                      size: 48.sp,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      state.message,
                      style: TextStyles.Size15.withColor(
                        AppColors.darkBlueBlack,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
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
                      ),
                      child: Text(
                        'إعادة المحاولة',
                        style: TextStyles.Size15.withColor(
                          AppColors.surfaceWhite,
                        ),
                      ),
                    ),
                  ],
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
                        SliverAppBar(
                          expandedHeight: 250.h,
                          pinned: true,
                          backgroundColor: AppColors.surfaceWhite,
                          leading: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: CircleAvatar(
                              backgroundColor: Colors.black26,
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
                            background: Image.asset(
                              'assets/images/logo.png',
                              height: 70.h,
                              width: 200.w,
                            ),
                          ),
                        ),

                        // 1. معلومات الخدمة
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(20.r),
                            child: ServiceInfoSection(service: service),
                          ),
                        ),

                        // 2. اختيار السيارة من قاعدة البيانات
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'اختر السيارة',
                                  style: TextStyles.Size18.withWeight(
                                    FontWeight.bold,
                                  ).withColor(AppColors.darkBlueBlack),
                                ),
                                SizedBox(height: 10.h),
                                _buildCarSelectionTile(),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),

                        // 3. الخدمات الفرعية
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الخدمات الفرعية والإضافات',
                                  style: TextStyles.Size18.withWeight(
                                    FontWeight.bold,
                                  ).withColor(AppColors.darkBlueBlack),
                                ),
                                SizedBox(height: 12.h),
                                _buildSubServicesSection(),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),

                        // 4. المواد والقطع المضافة من قاعدة البيانات
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'المواد والقطع المضافة',
                                  style: TextStyles.Size18.withWeight(
                                    FontWeight.bold,
                                  ).withColor(AppColors.darkBlueBlack),
                                ),
                                SizedBox(height: 12.h),
                                _buildMaterialsSection(),
                                SizedBox(height: 24.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // الشريط السفلي وتجميع التكلفة النهائية
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

                      return BookingBottomBar(
                        price: finalPrice,
                        discountPrice: service.vipExtraPrice != null
                            ? (service.vipExtraPrice! +
                                  subServicesPrice +
                                  materialsPrice)
                            : null,
                        onBookingPressed: () {
                          // 1. التحقق من اختيار السيارة
                          if (selectedCar == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يرجى تحديد السيارة أولاً'),
                                backgroundColor: AppColors.errorColor,
                              ),
                            );
                            return;
                          }

                          // 2. تجهيز معرّفات الخدمات الفرعية المحددة
                          final selectedSubServiceIds = subCubit
                              .selectedSubServices
                              .map((e) => e.id)
                              .toList();

                          // 3. تجهيز قائمة المواد المحددة بالصيغة المطلوبة للباك إند
                          final selectedMaterials = selectedMaterialIds.map((
                            id,
                          ) {
                            return {
                              'material_id': id,
                              'quantity': 1, // الكمية الافتراضية
                            };
                          }).toList();

                          // 4. الانتقال إلى شاشة الحجز وتوفير الـ BookingCubit عبر BlocProvider
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) =>
                                    BookingCubit(BookingRepo(apiService)),
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

  /// ويدجيت الزر التفاعلي لاختيار السيارة
  Widget _buildCarSelectionTile() {
    return InkWell(
      onTap: () => _showCarSelectionSheet(context),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selectedCar != null
                ? AppColors.primaryBlue
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.directions_car_rounded,
              color: selectedCar != null ? AppColors.primaryBlue : Colors.grey,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCar != null
                        ? '${selectedCar!.model} (${selectedCar!.year})'
                        : 'اضغط لاختيار السيارة من الكاراج',
                    style: TextStyles.Size15.withWeight(
                      FontWeight.bold,
                    ).withColor(AppColors.darkBlueBlack),
                  ),
                  if (selectedCar != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      'رقم اللوحة: ${selectedCar!.plateNumber}',
                      style: TextStyles.Size10.withColor(Colors.grey[600]!),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey[600],
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  /// القائمة السفلية مع ربط حقيقي لسيارات الكاراج القادمة من الـ API
  /// القائمة السفلية مع ربط حقيقي لسيارات الكاراج القادمة من الـ API
  void _showCarSelectionSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true, // <--- 1. لإعطاء الشيت مرونة أكبر في الارتفاع
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: parentContext.read<CarsCubit>(),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.r,
              right: 20.r,
              top: 20.r,
              // أخذ مراعاة الكيبورد أو الحواف السفلية للأجهزة
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20.r,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // محاولة ضغط المحتوى
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر السيارة المحددة للحجز',
                  style: TextStyles.Size18.withWeight(
                    FontWeight.bold,
                  ).withColor(AppColors.darkBlueBlack),
                ),
                SizedBox(height: 16.h),

                // 2. استخدام Flexible يمنع الـ RenderFlex Overflow نهائياً
                Flexible(
                  child: BlocBuilder<CarsCubit, CarsState>(
                    builder: (context, state) {
                      if (state is CarsLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                        );
                      }

                      final carsList = context.read<CarsCubit>().cars;

                      if (carsList.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(16.r),
                          child: const Text(
                            'لا توجد سيارات مضافة بالكاراج الخاص بك.',
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap:
                            true, // تجعل القائمة تأخذ حجم عناصرها فقط إذا كانت قليلة
                        physics: const BouncingScrollPhysics(),
                        itemCount: carsList.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final car = carsList[index];
                          final isSelected = selectedCar?.id == car.id;

                          return Material(
                            color: isSelected
                                ? AppColors.primaryBlue.withOpacity(0.05)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              leading: const Icon(
                                Icons.directions_car,
                                color: AppColors.primaryBlue,
                              ),
                              title: Text(
                                '${car.model} (${car.year})',
                                style: TextStyles.Size15.withWeight(
                                  FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('اللوحة: ${car.plateNumber}'),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primaryBlue,
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedCar = car;
                                });
                                Navigator.pop(sheetContext);
                              },
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
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
          );
        }

        final subServicesList = state is SubServiceSuccessState
            ? state.subServices
            : [];

        if (subServicesList.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'لا توجد خدمات فرعية متاحة حالياً.',
              style: TextStyles.Size15.withColor(Colors.grey),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: CheckboxListTile(
                  activeColor: AppColors.primaryBlue,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
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
                    style: TextStyles.Size10.withColor(Colors.grey),
                  ),
                  secondary: Text(
                    '+${subService.price} د.أ',
                    style: TextStyles.Size15.withWeight(
                      FontWeight.bold,
                    ).withColor(AppColors.primaryBlue),
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

  /// قسم المواد المضافة بربط الـ API من DB
  /// قسم المواد المضافة بربط الـ API من DB
  Widget _buildMaterialsSection() {
    return BlocBuilder<MaterialsCubit, MaterialsState>(
      builder: (context, state) {
        if (state is MaterialsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (state is MaterialsErrorState) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'حدث خطأ أثناء جلب المواد: ${state.message}',
              style: TextStyles.Size15.withColor(AppColors.errorColor),
            ),
          );
        }

        // ⚠️ الاستفادة مباشرة من حالة النجاح SuccessState
        final List<MaterialModel> materialsList = state is MaterialsSuccessState
            ? state.materials
            : context.read<MaterialsCubit>().materials;

        if (materialsList.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'لا توجد مواد مضافة مسجلة.',
              style: TextStyles.Size15.withColor(Colors.grey),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: CheckboxListTile(
                  activeColor: AppColors.primaryBlue,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
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
                          style: TextStyles.Size10.withColor(Colors.grey),
                        )
                      : null,
                  secondary: Text(
                    '+${material.price} د.أ',
                    style: TextStyles.Size15.withWeight(
                      FontWeight.bold,
                    ).withColor(AppColors.primaryBlue),
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
