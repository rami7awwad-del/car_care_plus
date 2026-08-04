import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import '../../data/repos/service_details_repo.dart';
import '../../logic/service_details_cubit.dart';
import '../../logic/service_details_state.dart';
import '../widgets/booking_bottom_bar.dart';
import '../widgets/service_info_section.dart';

class ServiceDetailsView extends StatelessWidget {
  final int serviceId;

  const ServiceDetailsView({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ServiceDetailsCubit(ServiceDetailsRepo(ApiService()))
            ..getServiceDetails(serviceId),
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
                      onPressed: () => context
                          .read<ServiceDetailsCubit>()
                          .getServiceDetails(serviceId),
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
                        // صورة الخدمة مع زر العودة
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
                              height: 70.h,width: 200.w,
                              'assets/images/logo.png',
                              //fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        // محتوى تفاصيل الخدمة
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(20.r),
                            child: ServiceInfoSection(service: service),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // شريط الحجز السفلي
                  BookingBottomBar(
                    price: service.basePrice,
                    discountPrice: service.vipExtraPrice,
                    onBookingPressed: () {
                      // للانتقال إلى الخطوة التالية (اختيار التاريخ والتوقيت)
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
}
