import 'package:car_care_plus/core/helper/responsive.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/points/logic/points_cubit.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/repos/wallet_payment_repo.dart';
import 'package:car_care_plus/features/wallet_and_payments/logic/wallet_payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/repos/home_repo.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import '../widgets/categories_list_widget.dart';
import '../widgets/home_balance_cards.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_promo_banner.dart';
import '../widgets/services_list_widget.dart';

/// الصفحة الرئيسية.
///
/// البنية: هيدر ثابت خارج منطقة التمرير + محتوى قابل للتمرير. الهيدر خارج
/// الـ CustomScrollView عمداً — الاعتماد السابق على `SliverAppBar` بارتفاع
/// ثابت (280.h) كان يبتلع الشاشة كاملة في الوضع العرضي.
class HomeView extends StatelessWidget {
  /// يُمرَّر من التخطيط الرئيسي لفتح القائمة الجانبية من الصورة الرمزية
  final VoidCallback? onMenuPressed;

  const HomeView({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(HomeRepo(ApiService()))..getHomeData(),
        ),
        BlocProvider(
          create: (context) => WalletPaymentCubit(
            WalletPaymentRepo(context.read<ApiService>()),
          )..fetchWalletBalanceOnly(),
        ),
      ],
      child: _HomeViewBody(onMenuPressed: onMenuPressed),
    );
  }
}

class _HomeViewBody extends StatefulWidget {
  final VoidCallback? onMenuPressed;

  const _HomeViewBody({required this.onMenuPressed});

  @override
  State<_HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<_HomeViewBody> {
  @override
  void initState() {
    super.initState();
    // رصيد النقاط يعيش في Cubit عام مشترك مع صفحة الحساب، فنطلب تحديثه هنا
    // بدل إنشاء نسخة ثانية منه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<PointsCubit>().fetchUserPoints();
    });
  }

  /// السحب للتحديث يعيد تحميل الأقسام والخدمات والرصيد والنقاط معاً
  Future<void> _refreshAll() async {
    await Future.wait([
      context.read<HomeCubit>().getHomeData(),
      context.read<WalletPaymentCubit>().fetchWalletBalanceOnly(),
      context.read<PointsCubit>().fetchUserPoints(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // في الوضع العرضي الارتفاع شحيح، فتنتقل بطاقتا الرصيد من الهيدر الثابت
    // إلى أول المحتوى القابل للتمرير
    final showCardsInHeader = context.isPortrait;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Column(
        children: [
          HomeHeaderWidget(
            onMenuPressed: widget.onMenuPressed,
            showBalanceCards: showCardsInHeader,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshAll,
              color: AppColors.primaryBlue,
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoadingState || state is HomeInitialState) {
                    return const _CenteredFiller(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlue,
                      ),
                    );
                  }

                  if (state is HomeErrorState) {
                    return _HomeErrorView(
                      message: state.message,
                      onRetry: () => context.read<HomeCubit>().getHomeData(),
                    );
                  }

                  return _HomeContent(
                    showBalanceCards: !showCardsInHeader,
                    isReloadingServices: state is ServicesLoadingState,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  /// تُعرض بطاقتا الرصيد هنا عندما لا يحملهما الهيدر (الوضع العرضي)
  final bool showBalanceCards;
  final bool isReloadingServices;

  const _HomeContent({
    required this.showBalanceCards,
    required this.isReloadingServices,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final gutter = context.contentGutter;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: ResponsiveContentBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBalanceCards) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(gutter, 14.h, gutter, 0),
                    child: const HomeBalanceCards(onGradient: false),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.fromLTRB(gutter, 16.h, gutter, 0),
                  child: const HomePromoBanner(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(gutter, 22.h, gutter, 0),
                  child: _SectionHeader(
                    title: 'الأقسام الرئيسية',
                    actionLabel:
                        cubit.selectedCategoryId != null ? 'عرض الكل' : null,
                    onAction: () => cubit.filterByCategory(null),
                  ),
                ),
                SizedBox(height: 12.h),
                CategoriesListWidget(
                  categories: cubit.categories,
                  selectedCategoryId: cubit.selectedCategoryId,
                  onCategorySelected: cubit.filterByCategory,
                  horizontalPadding: gutter,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(gutter, 20.h, gutter, 0),
                  child: const _SectionHeader(title: 'الخدمات المتاحة'),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 24.h),
          sliver: SliverToBoxAdapter(
            child: ResponsiveContentBox(
              child: isReloadingServices
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    )
                  : ServicesListWidget(services: cubit.services),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.Size18
                .withWeight(FontWeight.bold)
                .withColor(AppColors.darkBlueBlack),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Text(
                actionLabel!,
                style: TextStyles.Size10
                    .withColor(AppColors.primaryBlue)
                    .withWeight(FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}

/// يملأ ارتفاع منطقة التمرير حتى يبقى السحب للتحديث فعّالاً في حالات
/// التحميل والخطأ أيضاً
class _CenteredFiller extends StatelessWidget {
  final Widget child;

  const _CenteredFiller({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HomeErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return _CenteredFiller(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.errorColor,
              size: 46.r,
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
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
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
