import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:car_care_plus/features/packages/logic/packages_cubit.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';
import 'package:car_care_plus/features/packages/ui/widgets/active_subscription_card.dart';
import 'package:car_care_plus/features/packages/ui/widgets/package_card.dart';
import 'package:car_care_plus/features/packages/ui/widgets/package_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  void _openDetails(int packageId) {
    // نمرّر نفس الـ Cubit حتى ترى الورقة السفلية الاشتراك النشط
    final cubit = context.read<PackagesCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: PackageDetailsBottomSheet(packageId: packageId),
      ),
    );
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? AppColors.errorColor
              : AppColors.successColor,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: BlocConsumer<PackagesCubit, PackagesState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.successMessage != current.successMessage,
        listener: (context, state) {
          if (state.successMessage != null) {
            _showMessage(state.successMessage!, isError: false);
            context.read<PackagesCubit>().clearMessages();
          } else if (state.errorMessage != null &&
              state.status == PackagesStatus.success) {
            _showMessage(state.errorMessage!, isError: true);
            context.read<PackagesCubit>().clearMessages();
          }
        },
        builder: (context, state) {
          final cubit = context.read<PackagesCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(state: state),
              Expanded(child: _buildBody(context, state, cubit)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PackagesState state,
    PackagesCubit cubit,
  ) {
    if (state.status == PackagesStatus.loading &&
        state.availablePackages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      );
    }

    if (state.status == PackagesStatus.error &&
        state.availablePackages.isEmpty) {
      return _ErrorRetry(
        message: state.errorMessage ?? 'تعذر جلب الباقات',
        onRetry: cubit.emitFetchPackagesData,
      );
    }

    final packages = state.availablePackages;

    return RefreshIndicator(
      color: AppColors.primaryBlue,
      onRefresh: cubit.emitFetchPackagesData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
        children: [
          // 1. الاشتراك النشط أو دعوة لاختيار باقة
          if (state.activeUserPackage != null)
            ActiveSubscriptionCard(
              userPackage: state.activeUserPackage!,
              onTap: () {
                final packageId = state.activeUserPackage!.packageId;
                if (packageId > 0) _openDetails(packageId);
              },
            )
          else
            const _NoSubscriptionCard(),

          SizedBox(height: 26.h),

          // 2. الباقات المتاحة
          Row(
            children: [
              Text(
                'الباقات المتاحة',
                style: TextStyles.Size18
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.bold),
              ),
              const Spacer(),
              if (packages.isNotEmpty)
                Text(
                  '${packages.length} باقة',
                  style: TextStyles.Size10.withColor(AppColors.coolGrey),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            state.hasActiveSubscription
                ? 'يمكنك الاشتراك بباقة جديدة بعد انتهاء اشتراكك الحالي'
                : 'اختر الباقة التي تناسب استخدامك',
            style: TextStyles.Size10.withColor(AppColors.coolGrey),
          ),
          SizedBox(height: 16.h),

          if (packages.isEmpty)
            const _EmptyPackages()
          else
            ...List.generate(packages.length, (index) {
              final package = packages[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: PackageCard(
                  package: package,
                  isCurrentSubscription: state.isCurrentSubscription(
                    package.id,
                  ),
                  // الباقات الأخرى تُقفل ما دام هناك اشتراك نشط
                  isLocked: !state.canSubscribeTo(package) &&
                      !state.isCurrentSubscription(package.id),
                  lockedReason: state.blockedReasonFor(package),
                  isSubscribing: state.subscribingPackageId == package.id,
                  onTap: () => _openDetails(package.id),
                  onSubscribe: state.canSubscribeTo(package)
                      ? () => _confirmSubscribe(context, package)
                      : null,
                ),
              );
            }),
        ],
      ),
    );
  }

  /// الاشتراك يخصم من المحفظة، لذلك نؤكّد قبل التنفيذ
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

class _Header extends StatelessWidget {
  final PackagesState state;

  const _Header({required this.state});

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'الباقات',
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
              ),
              Icon(
                Icons.workspace_premium_rounded,
                color: AppColors.cyanAccent,
                size: 26.r,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            state.hasActiveSubscription
                ? 'لديك اشتراك نشط'
                : 'وفّر أكثر مع باقات الصيانة والغسيل',
            style: TextStyles.Size15.withColor(
              state.hasActiveSubscription
                  ? AppColors.cyanAccent
                  : AppColors.surfaceWhite.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoSubscriptionCard extends StatelessWidget {
  const _NoSubscriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.h,
            decoration: BoxDecoration(
              color: AppColors.lightBlueSurface,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.card_membership_outlined,
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
                  'لا يوجد اشتراك نشط',
                  style: TextStyles.Size15
                      .withColor(AppColors.darkBlueBlack)
                      .withWeight(FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  'اختر باقة من الأسفل للبدء',
                  style: TextStyles.Size10
                      .withColor(AppColors.coolGrey)
                      .withHeight(1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPackages extends StatelessWidget {
  const _EmptyPackages();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 38.r,
            color: AppColors.coolGrey,
          ),
          SizedBox(height: 12.h),
          Text(
            'لا توجد باقات متاحة حالياً',
            style: TextStyles.Size15.withColor(AppColors.coolGrey),
          ),
        ],
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 46.r,
              color: AppColors.errorColor,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              child: Text(
                'إعادة المحاولة',
                style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
