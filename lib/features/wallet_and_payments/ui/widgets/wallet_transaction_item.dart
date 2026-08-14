import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import '../../data/models/wallet_transaction_model.dart';

class WalletTransactionItemWidget extends StatelessWidget {
  final WalletTransactionItemModel transaction;

  const WalletTransactionItemWidget({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد هل المعاملة إيداع أم خصم
    final isCredit = transaction.type.toLowerCase() == 'credit';
    final iconColor = isCredit ? AppColors.successColor : AppColors.errorColor;
    final iconData = isCredit
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    return Container(
      padding: EdgeInsets.all(16.r),
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
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 22.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ??
                      (isCredit ? 'شحن رصيد' : 'خصم من الرصيد'),
                  style: TextStyles.Size15
                      .withColor(AppColors.darkBlueBlack)
                      .withWeight(FontWeight.bold),
                ),
                if (transaction.createdAt != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    transaction.createdAt!,
                    style: TextStyles.Size10.withColor(AppColors.coolGrey),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${isCredit ? "+" : "-"}${transaction.amount} ر.س',
            style: TextStyles.Size15
                .withColor(iconColor)
                .withWeight(FontWeight.bold),
          ),
        ],
      ),
    );
  }
}