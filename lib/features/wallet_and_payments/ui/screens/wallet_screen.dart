import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/repos/wallet_payment_repo.dart';
import 'package:car_care_plus/features/wallet_and_payments/logic/wallet_payment_cubit.dart';
import 'package:car_care_plus/features/wallet_and_payments/logic/wallet_payment_state.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/payment_item_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletPaymentCubit(
        WalletPaymentRepo(context.read<ApiService>()),
      )..fetchWalletAndPaymentData(),
      child: const _WalletScreenBody(),
    );
  }
}

class _WalletScreenBody extends StatelessWidget {
  const _WalletScreenBody();

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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: AppColors.errorColor, size: 48.r),
                  SizedBox(height: 12.h),
                  Text(
                    state.message,
                    style: TextStyles.Size15.withColor(AppColors.errorColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context
                        .read<WalletPaymentCubit>()
                        .fetchWalletAndPaymentData(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is WalletPaymentSuccessState) {
            return RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<WalletPaymentCubit>()
                    .fetchWalletAndPaymentData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // كارت الرصيد الرئيسي
                    WalletBalanceCard(
                      balance: state.wallet.balance,
                      onChargePressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ميزة شحن الرصيد ستكون متاحة قريباً!'),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24.h),

                    // عنوان المدفوعات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'سجل المدفوعات',
                          style: TextStyles.Size18
                              .withColor(AppColors.darkBlueBlack)
                              .withWeight(FontWeight.bold),
                        ),
                        Text(
                          '${state.payments.length} عمليات',
                          style: TextStyles.Size10
                              .withColor(AppColors.coolGrey),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // قائمة المدفوعات
                    if (state.payments.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(32.r),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.payment_outlined,
                                color: AppColors.coolGrey, size: 40.r),
                            SizedBox(height: 8.h),
                            Text(
                              'لا توجد عمليات دفع سابقة',
                              style: TextStyles.Size15
                                  .withColor(AppColors.coolGrey),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.payments.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final payment = state.payments[index];
                          return PaymentItemWidget(payment: payment);
                        },
                      ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}