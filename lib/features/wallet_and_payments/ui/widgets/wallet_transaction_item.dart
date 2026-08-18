import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/wallet_transaction_model.dart';

class WalletTransactionItemWidget extends StatelessWidget {
  final WalletTransactionItemModel transaction;

  const WalletTransactionItemWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // الاتجاه يأتي من type لا من إشارة المبلغ — المبلغ دائماً موجب
    final isCredit = transaction.isCredit;
    final accentColor = isCredit
        ? AppColors.successColor
        : AppColors.errorColor;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.04),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              _iconFor(transaction),
              color: accentColor,
              size: 21.r,
            ),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyles.Size15
                      .withColor(AppColors.darkBlueBlack)
                      .withWeight(FontWeight.bold),
                ),
                if (transaction.note != null &&
                    transaction.note!.trim().isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    transaction.note!.trim(),
                    style: TextStyles.Size10
                        .withColor(AppColors.coolGrey)
                        .withHeight(1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12.r,
                      color: AppColors.coolGrey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _formatDate(transaction.createdAt),
                      style: TextStyles.Size10.withColor(AppColors.coolGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}${_money(transaction.amount)}',
                style: TextStyles.Size15
                    .withColor(accentColor)
                    .withWeight(FontWeight.bold),
              ),
              // الرصيد بعد الحركة يعطي سجلاً قابلاً للمراجعة دون إعادة حساب
              if (transaction.balanceAfter != null) ...[
                SizedBox(height: 4.h),
                Text(
                  'الرصيد ${_money(transaction.balanceAfter!)}',
                  style: TextStyles.Size10.withColor(AppColors.coolGrey),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconFor(WalletTransactionItemModel transaction) {
    switch (transaction.reason) {
      case WalletTransactionReasons.refund:
        return Icons.undo_rounded;
      case WalletTransactionReasons.adjustment:
        return Icons.support_agent_rounded;
      case WalletTransactionReasons.topup:
        return Icons.add_card_rounded;
      case WalletTransactionReasons.orderPayment:
        return transaction.isPackagePurchase
            ? Icons.card_giftcard_rounded
            : Icons.receipt_long_rounded;
      default:
        return transaction.isCredit
            ? Icons.arrow_downward_rounded
            : Icons.arrow_upward_rounded;
    }
  }

  /// العملة غير موجودة في الاستجابة، نعرضها من إعدادات التطبيق كبقية الشاشات
  String _money(double value) => '${value.toStringAsFixed(0)} ل.س';

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year}/${two(date.month)}/${two(date.day)} - '
        '${two(date.hour)}:${two(date.minute)}';
  }
}
