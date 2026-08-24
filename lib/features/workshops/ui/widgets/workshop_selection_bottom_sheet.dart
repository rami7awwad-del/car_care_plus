import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import '../../data/models/workshop_model.dart';
import '../../data/repos/workshops_repo.dart';
import '../../logic/workshops_cubit.dart';
import '../../logic/workshops_state.dart';

// ورقة اختيار ورشة الصيانة القريبة (تُفتح بعد تحديد موقع العميل)
class WorkshopSelectionBottomSheet extends StatelessWidget {
  final double latitude;
  final double longitude;
  final ValueChanged<WorkshopModel> onSelect;

  const WorkshopSelectionBottomSheet({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkshopsCubit(WorkshopsRepo(ApiService()))
        ..getNearbyWorkshops(latitude: latitude, longitude: longitude),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.8.sh),
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
              'اختر ورشة الصيانة',
              style: TextStyles.Size24
                  .withWeight(FontWeight.bold)
                  .withColor(AppColors.darkBlueBlack),
            ),
            SizedBox(height: 4.h),
            Text(
              'الورش النشطة القريبة من موقعك، مرتّبة بالأقرب',
              style: TextStyles.Size15.withColor(AppColors.coolGrey),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: BlocBuilder<WorkshopsCubit, WorkshopsState>(
                builder: (context, state) {
                  if (state is WorkshopsLoadingState) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    );
                  }

                  if (state is WorkshopsErrorState) {
                    return _CenterMessage(
                      icon: Icons.error_outline_rounded,
                      color: AppColors.errorColor,
                      message: state.message,
                    );
                  }

                  if (state is WorkshopsSuccessState) {
                    if (state.workshops.isEmpty) {
                      return const _CenterMessage(
                        icon: Icons.location_off_rounded,
                        color: AppColors.coolGrey,
                        message: 'لا توجد ورش نشطة قريبة من موقعك',
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.workshops.length,
                      separatorBuilder: (_, i) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) => _WorkshopCard(
                        workshop: state.workshops[index],
                        onTap: () => onSelect(state.workshops[index]),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  final WorkshopModel workshop;
  final VoidCallback onTap;

  const _WorkshopCard({required this.workshop, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.lightBlueSurface,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.build_circle_outlined,
                color: AppColors.primaryBlue,
                size: 26.r,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workshop.displayName,
                    style: TextStyles.Size15
                        .withWeight(FontWeight.bold)
                        .withColor(AppColors.darkBlueBlack),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (workshop.city != null && workshop.city!.isNotEmpty) ...[
                        Icon(Icons.location_on_outlined,
                            size: 13.r, color: AppColors.coolGrey),
                        SizedBox(width: 3.w),
                        Text(
                          workshop.city!,
                          style: TextStyles.Size10.withColor(AppColors.coolGrey),
                        ),
                        SizedBox(width: 10.w),
                      ],
                      if (workshop.distanceKm != null) ...[
                        Icon(Icons.route_rounded,
                            size: 13.r, color: AppColors.coolGrey),
                        SizedBox(width: 3.w),
                        Text(
                          '${workshop.distanceKm!.toStringAsFixed(1)} كم',
                          style: TextStyles.Size10.withColor(AppColors.coolGrey),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (workshop.ratingAvg != null)
              Row(
                children: [
                  Icon(Icons.star_rounded,
                      size: 16.r, color: AppColors.goldAccent),
                  SizedBox(width: 3.w),
                  Text(
                    workshop.ratingAvg!.toStringAsFixed(1),
                    style: TextStyles.Size10
                        .withWeight(FontWeight.bold)
                        .withColor(AppColors.darkBlueBlack),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CenterMessage extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;

  const _CenterMessage({
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44.r, color: color),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.Size15.withColor(AppColors.coolGrey),
            ),
          ],
        ),
      ),
    );
  }
}
