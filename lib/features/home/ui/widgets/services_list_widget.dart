import 'package:car_care_plus/core/helper/responsive.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/service_details/ui/views/service_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/service_model.dart';

/// شبكة الخدمات المتاحة.
///
/// نستخدم `Wrap` لا `GridView`: ارتفاع البطاقة يتبع طول اسم الخدمة ووصفها،
/// وأي ارتفاع ثابت في الشبكة يعني تجاوزاً في الوضع العرضي أو مع تكبير الخط.
class ServicesListWidget extends StatelessWidget {
  final List<ServiceModel> services;

  const ServicesListWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const _EmptyServices();
    }

    final columns = context.contentColumns;

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 14.w;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 14.h,
          children: [
            for (final service in services)
              SizedBox(
                width: itemWidth,
                child: ServiceCard(service: service),
              ),
          ],
        );
      },
    );
  }
}

class _EmptyServices extends StatelessWidget {
  const _EmptyServices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 46.r, color: AppColors.coolGrey),
            SizedBox(height: 10.h),
            Text(
              'لا توجد خدمات متاحة حالياً لهذا القسم',
              textAlign: TextAlign.center,
              style: TextStyles.Size15.withColor(AppColors.coolGrey),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة خدمة واحدة — تتمدّد لعرض العمود المتاح ويتبع ارتفاعها محتواها.
class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({super.key, required this.service});

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceDetailsView(serviceId: service.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20.r);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: radius,
        border: Border.all(color: AppColors.borderGrey.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openDetails(context),
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50.r,
                      height: 50.r,
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.car_repair_rounded,
                        color: AppColors.surfaceWhite,
                        size: 26.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service.nameAr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.Size18
                                      .withWeight(FontWeight.bold)
                                      .withColor(AppColors.darkBlueBlack),
                                ),
                              ),
                              if (service.isVipAvailable) ...[
                                SizedBox(width: 6.w),
                                const _VipBadge(),
                              ],
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            service.description ??
                                'خدمة عالية الجودة ومضمونة مع أفضل الفنيين.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.Size10
                                .withColor(AppColors.coolGrey)
                                .withHeight(1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Divider(color: AppColors.borderGrey.withOpacity(0.6), height: 1),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 15.r,
                      color: AppColors.primaryBlue,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        '${service.durationMinutes} دقيقة',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.Size10
                            .withWeight(FontWeight.w600)
                            .withColor(AppColors.darkBlueBlack),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // FittedBox يحمي السعر الطويل من دفع الصف خارج البطاقة
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          '${service.basePrice.toStringAsFixed(0)} د.أ',
                          maxLines: 1,
                          style: TextStyles.Size24
                              .withWeight(FontWeight.bold)
                              .withColor(AppColors.primaryBlue),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _BookNowButton(onTap: () => _openDetails(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VipBadge extends StatelessWidget {
  const _VipBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.darkBlueBlack,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        'VIP ⭐',
        style: TextStyles.Size10
            .withColor(AppColors.cyanAccent)
            .withWeight(FontWeight.bold),
      ),
    );
  }
}

class _BookNowButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BookNowButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12.r);

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradient,
              borderRadius: radius,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                'احجز الآن',
                textAlign: TextAlign.center,
                style: TextStyles.Size15
                    .withColor(AppColors.surfaceWhite)
                    .withWeight(FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
