// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:car_care_plus/core/resources/app_color.dart';
// import 'package:car_care_plus/core/resources/text_style.dart';
// import '../../data/repos/wallet_payment_repo.dart';
// import '../../logic/wallet_payment_cubit.dart';
// import '../../logic/wallet_payment_state.dart';

// class PaymentDetailsScreen extends StatelessWidget {
//   final int paymentId;
//   final WalletPaymentRepo repo;
  
//   const PaymentDetailsScreen({
//     super.key,
//     required this.paymentId,
//     required this.repo,
//   });

//   // دالة لجلب أول 5 أرقام أو حروف من رقم العملية
//   String _getShortCode(String paymentNumber) {
//     if (paymentNumber.isEmpty) return '#00000';
//     return paymentNumber.length >= 5
//         ? '#${paymentNumber.substring(0, 5).toUpperCase()}'
//         : '#${paymentNumber.toUpperCase()}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => WalletPaymentCubit(repo)..fetchPaymentDetail(paymentId),
//       child: Scaffold(
//         backgroundColor: AppColors.lightBlueSurface,
//         appBar: AppBar(
//           title: Text(
//             'تفاصيل الدفع',
//             style: TextStyles.Size18
//                 .withColor(AppColors.darkBlueBlack)
//                 .withWeight(FontWeight.bold),
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           iconTheme: const IconThemeData(color: AppColors.darkBlueBlack),
//         ),
//         body: BlocBuilder<WalletPaymentCubit, WalletPaymentState>(
//           builder: (context, state) {
//             if (state is PaymentDetailLoadingState) {
//               return const Center(
//                 child: CircularProgressIndicator(color: AppColors.primaryBlue),
//               );
//             }

//             if (state is WalletPaymentErrorState) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.error_outline,
//                       color: AppColors.errorColor, 
//                       size: 48.r,
//                     ),
//                     SizedBox(height: 12.h),
//                     Text(
//                       state.message,
//                       style: TextStyles.Size15.withColor(AppColors.errorColor),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             if (state is PaymentDetailSuccessState) {
//               final payment = state.paymentDetail;
//               final isPending = payment.status.toLowerCase() == 'pending';

//               return SingleChildScrollView(
//                 padding: EdgeInsets.all(20.r),
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(24.r),
//                   decoration: BoxDecoration(
//                     color: AppColors.surfaceWhite,
//                     borderRadius: BorderRadius.circular(24.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.darkBlueBlack.withOpacity(0.06),
//                         blurRadius: 18.r,
//                         offset: Offset(0, 6.h),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       // أيقونة حالة الدفع متغيرة حسب الحالة
//                       Container(
//                         width: 64.w,
//                         height: 64.h,
//                         decoration: BoxDecoration(
//                           color: (isPending ? AppColors.warningColor : AppColors.successColor)
//                               .withOpacity(0.12),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           isPending ? Icons.hourglass_top_rounded : Icons.check_circle_rounded,
//                           color: isPending ? AppColors.warningColor : AppColors.successColor,
//                           size: 36.r,
//                         ),
//                       ),
//                       SizedBox(height: 16.h),
//                       Text(
//                         'إيصال عملية دفع',
//                         style: TextStyles.Size15.withColor(AppColors.coolGrey),
//                       ),
//                       SizedBox(height: 6.h),
//                       Text(
//                         '${payment.amount} ر.س',
//                         style: TextStyles.Size32
//                             .withColor(AppColors.darkBlueBlack)
//                             .withWeight(FontWeight.bold),
//                       ),
//                       SizedBox(height: 24.h),
//                       const Divider(),
//                       SizedBox(height: 16.h),

//                       // 👈 استبدال حقل التاريخ برمز العملية المكون من أول 5 أرقام
//                       _DetailRow(
//                         label: 'رمز العملية',
//                         value: _getShortCode(payment.paymentNumber),
//                       ),
//                       SizedBox(height: 14.h),
//                       _DetailRow(
//                         label: 'وسيلة الدفع',
//                         value: payment.method.toUpperCase(),
//                       ),
//                       SizedBox(height: 14.h),
//                       _DetailRow(
//                         label: 'نوع العملية',
//                         value: payment.type,
//                       ),
//                       SizedBox(height: 14.h),
//                       _DetailRow(
//                         label: 'حالة الدفع',
//                         value: isPending ? 'قيد الانتظار' : 'مكتملة',
//                         valueColor: isPending ? AppColors.warningColor : AppColors.successColor,
//                       ),
//                       if (payment.pointsUsed > 0) ...[
//                         SizedBox(height: 14.h),
//                         _DetailRow(
//                           label: 'النقاط المستفاد منها',
//                           value: '${payment.pointsUsed} نقطة',
//                           valueColor: AppColors.royalBlue,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }

// class _DetailRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color? valueColor;

//   const _DetailRow({
//     required this.label,
//     required this.value,
//     this.valueColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyles.Size15.withColor(AppColors.coolGrey),
//         ),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: Text(
//             value,
//             textAlign: TextAlign.end,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyles.Size15
//                 .withColor(valueColor ?? AppColors.darkBlueBlack)
//                 .withWeight(FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }