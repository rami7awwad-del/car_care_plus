import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/repos/wallet_payment_repo.dart';
import 'package:car_care_plus/features/wallet_and_payments/logic/wallet_payment_cubit.dart';
import 'package:car_care_plus/features/wallet_and_payments/logic/wallet_payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_transaction_item.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WalletPaymentCubit(WalletPaymentRepo(context.read<ApiService>()))
            ..fetchWalletAndPaymentData(),
      child: const _WalletScreenBody(),
    );
  }
}

class _WalletScreenBody extends StatefulWidget {
  const _WalletScreenBody();

  @override
  State<_WalletScreenBody> createState() => _WalletScreenBodyState();
}

class _WalletScreenBodyState extends State<_WalletScreenBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240.h) {
      context.read<WalletPaymentCubit>().loadMoreTransactions();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueSurface,
      appBar: AppBar(
        title: Text(
          'المحفظة والمدفوعات',
          style: TextStyles.Size18
              .withColor(AppColors.darkBlueBlack)
              .withWeight(FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkBlueBlack),
      ),
      body: BlocBuilder<WalletPaymentCubit, WalletPaymentState>(
        builder: (context, state) {
          if (state is WalletPaymentLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          if (state is WalletPaymentErrorState) {
            return _ErrorRetry(
              message: state.message,
              onRetry: () => context
                  .read<WalletPaymentCubit>()
                  .fetchWalletAndPaymentData(),
            );
          }

          if (state is WalletPaymentSuccessState) {
            return RefreshIndicator(
              color: AppColors.primaryBlue,
              onRefresh: () async {
                await context
                    .read<WalletPaymentCubit>()
                    .fetchWalletAndPaymentData();
              },
              child: _buildContent(context, state),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WalletPaymentSuccessState state) {
    final transactions = state.transactions;

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WalletBalanceCard(
                  balance: state.wallet.balance,
                  onChargePressed: () {
                    // لا توجد نقطة نهاية لشحن المحفظة ذاتياً في الباك اند
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'شحن الرصيد يتم عبر الدعم حالياً، ويصلك الرصيد فور إضافته',
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سجل الحركات',
                      style: TextStyles.Size18
                          .withColor(AppColors.darkBlueBlack)
                          .withWeight(FontWeight.bold),
                    ),
                    if (state.pagination != null)
                      Text(
                        '${state.pagination!.total} حركة',
                        style: TextStyles.Size10.withColor(AppColors.coolGrey),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'المدفوعات وعمليات إضافة الرصيد',
                  style: TextStyles.Size10.withColor(AppColors.coolGrey),
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),

        if (transactions.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const _EmptyTransactions(),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
            sliver: SliverList.separated(
              itemCount: transactions.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                if (index >= transactions.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  );
                }
                return WalletTransactionItemWidget(
                  transaction: transactions[index],
                );
              },
            ),
          ),
      ],
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

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
          Container(
            width: 72.w,
            height: 72.h,
            decoration: const BoxDecoration(
              color: AppColors.lightBlueSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.swap_vert_rounded,
              size: 34.r,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'لا توجد حركات بعد',
            style: TextStyles.Size15
                .withColor(AppColors.darkBlueBlack)
                .withWeight(FontWeight.bold),
          ),
          SizedBox(height: 6.h),
          Text(
            'ستظهر هنا مدفوعات حجوزاتك وأي رصيد يُضاف إلى محفظتك',
            textAlign: TextAlign.center,
            style: TextStyles.Size10
                .withColor(AppColors.coolGrey)
                .withHeight(1.6),
          ),
        ],
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

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
              Icons.error_outline,
              color: AppColors.errorColor,
              size: 48.r,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: TextStyles.Size15.withColor(AppColors.errorColor),
              textAlign: TextAlign.center,
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
