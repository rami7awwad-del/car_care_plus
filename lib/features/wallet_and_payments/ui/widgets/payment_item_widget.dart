import 'package:car_care_plus/core/routing/app_routes.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/models/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';

class PaymentItemWidget extends StatelessWidget {
  final PaymentItemModel payment;
  final VoidCallback? onTap;

  const PaymentItemWidget({
    super.key,
    required this.payment,
    this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
      case 'success':
        return AppColors.successColor;
      case 'pending':
        return AppColors.warningColor;
      default:
        return AppColors.errorColor;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
      case 'success':
        return 'مكتملة';
      case 'pending':
        return 'قيد الانتظار';
      default:
        return 'ملغاة';
    }
  }

  // 👈 دالة لاستخراج أول 5 أرقام/حروف من رقم العملية
  String _getShortPaymentNumber(String paymentNumber) {
    if (paymentNumber.isEmpty) return '#00000';
    return paymentNumber.length >= 5
        ? paymentNumber.substring(0, 5).toUpperCase()
        : paymentNumber.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(payment.status);

    return InkWell(
      onTap: onTap ??
          () {
            Navigator.pushNamed(
              context,
              Routes.paymentDetails,
              arguments: payment.id,
            );
          },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
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
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                color: statusColor,
                size: 24.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👈 عرض أول 5 أرقام فقط هنا
                  Text(
                    'عملية #${_getShortPaymentNumber(payment.paymentNumber)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.Size15
                        .withColor(AppColors.darkBlueBlack)
                        .withWeight(FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        payment.method.toUpperCase(),
                        style: TextStyles.Size10.withColor(AppColors.coolGrey),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          _getStatusText(payment.status),
                          style: TextStyles.Size10
                              .withColor(statusColor)
                              .withWeight(FontWeight.w600),
                        ),
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
                  '${payment.amount} ر.س',
                  style: TextStyles.Size15
                      .withColor(AppColors.darkBlueBlack)
                      .withWeight(FontWeight.bold),
                ),
                if (payment.pointsUsed > 0) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'خصم ${payment.pointsUsed} نقطة',
                    style: TextStyles.Size10.withColor(AppColors.royalBlue),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}