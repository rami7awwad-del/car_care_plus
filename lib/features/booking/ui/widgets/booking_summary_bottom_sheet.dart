import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/booking_quote_response_model.dart';
import '../../logic/booking_cubit.dart';
import '../../logic/booking_state.dart';


class BookingSummaryBottomSheet extends StatelessWidget {
  final QuoteData quoteData;

  const BookingSummaryBottomSheet({super.key, required this.quoteData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingConfirmErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.errorColor),
            );
          } else if (state is BookingConfirmSuccessState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تأكيد الحجز بنجاح!'),
                backgroundColor: AppColors.successColor,
              ),
            );
          }
        },
        builder: (context, state) {
          final isConfirming = state is BookingConfirmLoadingState;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderGrey,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'ملخص التكلفة',
                style: TextStyles.Size24.withWeight(FontWeight.bold).withColor(AppColors.darkBlueBlack),
              ),
              Divider(height: 24.h, color: AppColors.borderGrey),

              if (quoteData.invoice != null && quoteData.invoice!.isNotEmpty)
                ...quoteData.invoice!.first.priceItems?.map(
                      (item) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.label,
                              style: TextStyles.Size15.withColor(AppColors.coolGrey),
                            ),
                            Text(
                              '${item.amount} SAR',
                              style: TextStyles.Size15.withWeight(FontWeight.w600).withColor(AppColors.darkBlueBlack),
                            ),
                          ],
                        ),
                      ),
                    ) ??
                    [],

              Divider(height: 28.h, color: AppColors.borderGrey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المجموع الإجمالي',
                    style: TextStyles.Size18.withWeight(FontWeight.bold).withColor(AppColors.darkBlueBlack),
                  ),
                  Text(
                    '${quoteData.totalPrice} SAR',
                    style: TextStyles.Size24.withWeight(FontWeight.bold).withColor(AppColors.successColor),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              Container(
                width: double.infinity,
                height: 54.h,
                decoration: BoxDecoration(
                  color: AppColors.successColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.successColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: isConfirming
                      ? null
                      : () => context.read<BookingCubit>().emitConfirmBooking(quoteData.quoteToken),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  ),
                  child: isConfirming
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          'تأكيد الحجز النهائي',
                          style: TextStyles.Size18.withWeight(FontWeight.bold).withColor(Colors.white),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}