import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/points/logic/points_cubit.dart';
import 'package:car_care_plus/features/points/logic/points_state.dart';
import 'package:car_care_plus/features/wallet_and_payments/logic/wallet_payment_cubit.dart';
import 'package:car_care_plus/features/wallet_and_payments/logic/wallet_payment_state.dart';
import 'package:car_care_plus/features/wallet_and_payments/ui/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// بطاقتا الرصيد أعلى الصفحة الرئيسية: رصيد المحفظة ونقاط المكافآت.
///
/// تُعرضان داخل الهيدر المتدرّج في الوضع الطولي، وفي أول المحتوى القابل للتمرير
/// في الوضع العرضي حتى لا يبتلع الهيدر نصف الشاشة.
class HomeBalanceCards extends StatelessWidget {
  /// `true` عندما تُرسم البطاقات فوق خلفية الهيدر المتدرّجة
  final bool onGradient;

  const HomeBalanceCards({super.key, this.onGradient = true});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _WalletBalanceCard(onGradient: onGradient)),
          SizedBox(width: 12.w),
          Expanded(child: _PointsBalanceCard(onGradient: onGradient)),
        ],
      ),
    );
  }
}

class _WalletBalanceCard extends StatelessWidget {
  final bool onGradient;

  const _WalletBalanceCard({required this.onGradient});

  /// الرصيد يصل نصاً من الباك اند ("12.50")، ونعرضه برقمين عشريين دائماً
  String _formatBalance(String raw) {
    final value = double.tryParse(raw.trim());
    if (value == null) return raw;
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletPaymentCubit, WalletPaymentState>(
      builder: (context, state) {
        String? value;
        bool isLoading = false;

        if (state is WalletPaymentLoadingState) {
          isLoading = true;
        } else if (state is WalletPaymentSuccessState) {
          value = _formatBalance(state.wallet.balance);
        }

        return _BalanceCard(
          onGradient: onGradient,
          icon: Icons.account_balance_wallet_rounded,
          accent: AppColors.primaryBlue,
          label: 'رصيد المحفظة',
          value: value,
          unit: 'د.أ',
          isLoading: isLoading,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WalletScreen()),
          ),
        );
      },
    );
  }
}

class _PointsBalanceCard extends StatelessWidget {
  final bool onGradient;

  const _PointsBalanceCard({required this.onGradient});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointsCubit, PointsState>(
      builder: (context, state) {
        String? value;
        bool isLoading = false;

        if (state is PointsLoadingState || state is PointsInitialState) {
          isLoading = true;
        } else if (state is PointsSuccessState) {
          value = '${state.pointsData.balance ?? 0}';
        }

        return _BalanceCard(
          onGradient: onGradient,
          icon: Icons.stars_rounded,
          accent: AppColors.goldAccent,
          label: 'نقاط المكافآت',
          value: value,
          unit: 'نقطة',
          isLoading: isLoading,
        );
      },
    );
  }
}

/// الشكل المشترك لبطاقتي الرصيد — بطاقة بيضاء بأيقونة ملوّنة ورقم بارز.
class _BalanceCard extends StatelessWidget {
  final bool onGradient;
  final IconData icon;
  final Color accent;
  final String label;

  /// `null` تعني تعذّر الجلب، فنعرض شرطة بدل رقم مضلّل
  final String? value;
  final String unit;
  final bool isLoading;
  final VoidCallback? onTap;

  const _BalanceCard({
    required this.onGradient,
    required this.icon,
    required this.accent,
    required this.label,
    required this.value,
    required this.unit,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18.r);

    return Material(
      color: AppColors.surfaceWhite,
      borderRadius: radius,
      elevation: onGradient ? 0 : 1,
      shadowColor: AppColors.darkBlueBlack.withOpacity(0.15),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: onGradient
                  ? Colors.transparent
                  : AppColors.borderGrey.withOpacity(0.8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(icon, color: accent, size: 18.r),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.Size10
                          .withColor(AppColors.coolGrey)
                          .withWeight(FontWeight.w600),
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 18.r,
                      color: AppColors.coolGrey,
                    ),
                ],
              ),
              SizedBox(height: 10.h),
              // FittedBox يمنع خروج الأرقام الكبيرة عن حدود البطاقة الضيّقة
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: _valueRow(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _valueRow() {
    if (isLoading) {
      return SizedBox(
        height: 24.h,
        width: 24.h,
        child: CircularProgressIndicator(strokeWidth: 2.2, color: accent),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value ?? '—',
          style: TextStyles.Size24
              .withWeight(FontWeight.bold)
              .withColor(AppColors.darkBlueBlack),
        ),
        SizedBox(width: 4.w),
        Text(
          unit,
          style: TextStyles.Size10
              .withWeight(FontWeight.w600)
              .withColor(AppColors.coolGrey),
        ),
      ],
    );
  }
}
