import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/routing/app_routes.dart';
import '../../data/models/payment_model.dart';

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
      case 'completed':
      case 'success':
      case 'paid':
        return const Color(0xFFE8F5E9); // خلفية خضراء فاتحة
      case 'pending':
        return const Color(0xFFFFF8E1); // خلفية صفراء فاتحة
      default:
        return const Color(0xFFFFEBEE); // خلفية حمراء فاتحة
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
      case 'paid':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFFFB300);
      default:
        return const Color(0xFFE53935);
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
      case 'paid':
        return 'مكتمل';
      case 'pending':
        return 'قيد التنفيذ';
      default:
        return 'ملغي';
    }
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'تاريخ غير محدد';
    try {
      final dateTime = DateTime.parse(rawDate);
      final formattedDate = DateFormat('d MMMM yyyy', 'ar').format(dateTime);
      final formattedTime = DateFormat('h:mm', 'ar').format(dateTime);
      final period = dateTime.hour >= 12 ? 'م' : 'ص';
      return '$formattedDate - $formattedTime $period';
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderStatus = payment.order?.status ?? payment.status;
    final displayDate = payment.order?.scheduledAt ?? payment.order?.createdAt;
    final orderId = payment.orderId ?? payment.order?.id ?? payment.id;

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
              color: AppColors.darkBlueBlack.withOpacity(0.03),
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Column(
          children: [
            // الجزء العلوي: الحالة، العنوان والأيقونة، رقم الطلب
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. شارة الحالة
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(orderStatus),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _getStatusText(orderStatus),
                    style: TextStyles.Size10.copyWith(
                      color: _getStatusTextColor(orderStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                // 2. عنوان الخدمة ورقم الطلب
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      payment.type == 'order' ? 'خدمة طلب صيانة' : 'عملية دفع',
                      style: TextStyles.Size15.withColor(AppColors.darkBlueBlack)
                          .withWeight(FontWeight.bold),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '#$orderId',
                      style: TextStyles.Size10.withColor(AppColors.coolGrey),
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
                // 3. أيقونة الخدمة
                Container(
                  width: 42.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueSurface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.directions_car_rounded,
                    color: AppColors.primaryBlue,
                    size: 22.r,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            const Divider(height: 1, thickness: 0.5),
            SizedBox(height: 12.h),

            // الجزء السفلي: السعر على اليسار، والتاريخ والأيقونة على اليمين
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // السعر والعملة
                Text(
                  '${payment.amount} ر.س',
                  style: TextStyles.Size18.withColor(AppColors.primaryBlue)
                      .withWeight(FontWeight.bold),
                ),
                // التاريخ والوقت
                Row(
                  children: [
                    Text(
                      _formatDate(displayDate),
                      style: TextStyles.Size10.withColor(AppColors.coolGrey),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14.r,
                      color: AppColors.coolGrey,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}