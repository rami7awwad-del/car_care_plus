import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:car_care_plus/features/packages/logic/packages_cubit.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageDetailsBottomSheet extends StatefulWidget {
  final int packageId;

  const PackageDetailsBottomSheet({super.key, required this.packageId});

  @override
  State<PackageDetailsBottomSheet> createState() =>
      _PackageDetailsBottomSheetState();
}

class _PackageDetailsBottomSheetState extends State<PackageDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<PackagesCubit>().emitGetPackageDetails(widget.packageId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackagesCubit, PackagesState>(
      listenWhen: (previous, current) =>
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        // نغلق الورقة بعد نجاح الاشتراك، والشاشة خلفها تعرض الرسالة
        if (state.successMessage != null && mounted) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: state.isLoadingDetails || state.selectedPackage == null
              ? SizedBox(
                  height: 220.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                )
              : _buildContent(context, state, state.selectedPackage!),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    PackagesState state,
    PackageModel package,
  ) {
    final isCurrent = state.isCurrentSubscription(package.id);
    final canSubscribe = state.canSubscribeTo(package);
    final blockedReason = state.blockedReasonFor(package);
    final isSubscribing = state.subscribingPackageId == package.id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 44.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.borderGrey,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(height: 18.h),

        Flexible(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color:
                            (isCurrent
                                    ? AppColors.successColor
                                    : AppColors.primaryBlue)
                                .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        isCurrent
                            ? Icons.verified_rounded
                            : Icons.card_membership_rounded,
                        color: isCurrent
                            ? AppColors.successColor
                            : AppColors.primaryBlue,
                        size: 26.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package.name,
                            style: TextStyles.Size18
                                .withColor(AppColors.darkBlueBlack)
                                .withWeight(FontWeight.bold),
                          ),
                          if (package.type.trim().isNotEmpty) ...[
                            SizedBox(height: 6.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 9.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlueSurface,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                package.type,
                                style: TextStyles.Size10
                                    .withColor(AppColors.primaryBlue)
                                    .withWeight(FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                Row(
                  children: [
                    _InfoTile(
                      icon: Icons.payments_outlined,
                      title: 'السعر',
                      value: '${package.price} ل.س',
                      color: AppColors.successColor,
                    ),
                    SizedBox(width: 10.w),
                    _InfoTile(
                      icon: Icons.build_outlined,
                      title: 'الخدمات',
                      value: '${package.servicesCount}',
                      color: AppColors.primaryBlue,
                    ),
                    SizedBox(width: 10.w),
                    _InfoTile(
                      icon: Icons.calendar_today_outlined,
                      title: 'الصلاحية',
                      value: '${package.validDays} يوم',
                      color: AppColors.goldAccent,
                    ),
                  ],
                ),
                SizedBox(height: 22.h),

                Text(
                  'عن الباقة',
                  style: TextStyles.Size15
                      .withColor(AppColors.darkBlueBlack)
                      .withWeight(FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text(
                  package.description?.trim().isNotEmpty == true
                      ? package.description!.trim()
                      : 'لا يوجد وصف إضافي لهذه الباقة.',
                  style: TextStyles.Size15
                      .withColor(AppColors.coolGrey)
                      .withHeight(1.7),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),

        // حالة الاشتراك: لا يُسمح بأكثر من باقة نشطة في الوقت نفسه
        if (blockedReason != null) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppColors.successColor.withOpacity(0.08)
                  : AppColors.lightGoldSurface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color:
                    (isCurrent
                            ? AppColors.successColor
                            : AppColors.goldAccent)
                        .withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isCurrent
                      ? Icons.check_circle_rounded
                      : Icons.info_outline_rounded,
                  size: 17.r,
                  color: isCurrent
                      ? AppColors.successColor
                      : AppColors.goldAccent,
                ),
                SizedBox(width: 9.w),
                Expanded(
                  child: Text(
                    blockedReason,
                    style: TextStyles.Size10
                        .withColor(AppColors.darkBlueBlack)
                        .withHeight(1.5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
        ],

        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            // الزر معطّل تماماً ما دام هناك اشتراك نشط
            onPressed: (!canSubscribe || isSubscribing)
                ? null
                : () => _confirmSubscribe(context, package),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              disabledBackgroundColor: AppColors.borderGrey,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: isSubscribing
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.surfaceWhite,
                    ),
                  )
                : Text(
                    isCurrent
                        ? 'أنت مشترك في هذه الباقة'
                        : (canSubscribe ? 'اشترك الآن' : 'غير متاح حالياً'),
                    style: TextStyles.Size15
                        .withColor(
                          canSubscribe
                              ? AppColors.surfaceWhite
                              : AppColors.coolGrey,
                        )
                        .withWeight(FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmSubscribe(
    BuildContext context,
    PackageModel package,
  ) async {
    final cubit = context.read<PackagesCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        title: Text(
          'تأكيد الاشتراك',
          style: TextStyles.Size18
              .withColor(AppColors.darkBlueBlack)
              .withWeight(FontWeight.bold),
        ),
        content: Text(
          'سيتم الاشتراك في «${package.name}» وخصم ${package.price} ل.س من محفظتك.\n'
          'لا يمكنك الاشتراك بباقة أخرى قبل انتهاء هذه الباقة.',
          style: TextStyles.Size15
              .withColor(AppColors.darkBlueBlack)
              .withHeight(1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('تراجع'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: Text(
              'تأكيد',
              style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.emitSubscribeToPackage(packageId: package.id);
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20.r),
            SizedBox(height: 7.h),
            Text(
              title,
              style: TextStyles.Size10.withColor(AppColors.coolGrey),
            ),
            SizedBox(height: 3.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.Size10
                  .withColor(AppColors.darkBlueBlack)
                  .withWeight(FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
