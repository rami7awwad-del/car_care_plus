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

  String _money(double value) => '${value.toStringAsFixed(2)} ل.س';

  @override
  Widget build(BuildContext context) {
    final invoices = quoteData.invoice;
    final isMultiCar = invoices.length > 1;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      padding: EdgeInsets.fromLTRB(24.r, 12.r, 24.r, 24.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingConfirmErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          } else if (state is BookingConfirmSuccessState) {
            Navigator.pop(context); // إغلاق الملخّص
            Navigator.pop(context); // العودة من شاشة الحجز
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
              SizedBox(height: 18.h),
              Text(
                'ملخص التكلفة',
                style: TextStyles.Size24
                    .withWeight(FontWeight.bold)
                    .withColor(AppColors.darkBlueBlack),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  if (quoteData.carCount != null)
                    _MetaChip(
                      icon: Icons.directions_car_rounded,
                      label: '${quoteData.carCount} مركبة',
                    ),
                  if (quoteData.distanceKm != null)
                    _MetaChip(
                      icon: Icons.route_rounded,
                      label: '${quoteData.distanceKm!.toStringAsFixed(1)} كم',
                    ),
                ],
              ),
              Divider(height: 24.h, color: AppColors.borderGrey),

              // فاتورة لكل سيارة
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < invoices.length; i++) ...[
                        _InvoiceCard(
                          item: invoices[i],
                          title: isMultiCar ? 'السيارة ${i + 1}' : null,
                          money: _money,
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ],
                  ),
                ),
              ),

              Divider(height: 20.h, color: AppColors.borderGrey),
              _TotalRow(
                label: 'المجموع الإجمالي',
                value: _money(quoteData.totalPrice),
                highlight: true,
              ),
              if (quoteData.cashDueTotal != null) ...[
                SizedBox(height: 8.h),
                _TotalRow(
                  label: 'المتبقّي نقداً بعد الباقة',
                  value: _money(quoteData.cashDueTotal!),
                ),
              ],
              if (quoteData.expiresAt != null) ...[
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 14.r, color: AppColors.coolGrey),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'هذا العرض صالح لمدة قصيرة، يرجى التأكيد الآن',
                        style: TextStyles.Size10.withColor(AppColors.coolGrey),
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 20.h),

              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: isConfirming
                      ? null
                      : () => context
                          .read<BookingCubit>()
                          .emitConfirmBooking(quoteData.quoteToken),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: isConfirming
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'تأكيد الحجز النهائي',
                          style: TextStyles.Size18
                              .withWeight(FontWeight.bold)
                              .withColor(Colors.white),
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

class _InvoiceCard extends StatelessWidget {
  final InvoiceItem item;
  final String? title;
  final String Function(double) money;

  const _InvoiceCard({required this.item, required this.title, required this.money});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyles.Size15
                  .withWeight(FontWeight.bold)
                  .withColor(AppColors.primaryBlue),
            ),
            SizedBox(height: 10.h),
          ],
          if (item.priceItems.isNotEmpty)
            ...item.priceItems.map(
              (p) => Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p.label,
                      style: TextStyles.Size15.withColor(AppColors.coolGrey),
                    ),
                    Text(
                      money(p.amount),
                      style: TextStyles.Size15
                          .withWeight(FontWeight.w600)
                          .withColor(AppColors.darkBlueBlack),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            _MiniRow(label: 'الخدمة', value: money(item.servicePrice)),
            if (item.subServicePrice > 0)
              _MiniRow(label: 'إضافات', value: money(item.subServicePrice)),
            if (item.materialsPrice > 0)
              _MiniRow(label: 'مواد', value: money(item.materialsPrice)),
          ],
          Divider(height: 16.h, color: AppColors.borderGrey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإجمالي',
                style: TextStyles.Size15
                    .withWeight(FontWeight.bold)
                    .withColor(AppColors.darkBlueBlack),
              ),
              Text(
                money(item.totalPrice),
                style: TextStyles.Size15
                    .withWeight(FontWeight.bold)
                    .withColor(AppColors.primaryBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniRow extends StatelessWidget {
  final String label;
  final String value;

  const _MiniRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.Size15.withColor(AppColors.coolGrey)),
          Text(
            value,
            style: TextStyles.Size15
                .withWeight(FontWeight.w600)
                .withColor(AppColors.darkBlueBlack),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _TotalRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.Size18
              .withWeight(FontWeight.bold)
              .withColor(AppColors.darkBlueBlack),
        ),
        Text(
          value,
          style: (highlight ? TextStyles.Size24 : TextStyles.Size18)
              .withWeight(FontWeight.bold)
              .withColor(highlight ? AppColors.successColor : AppColors.darkBlueBlack),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.lightBlueSurface,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.r, color: AppColors.primaryBlue),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyles.Size10
                .withWeight(FontWeight.bold)
                .withColor(AppColors.primaryBlue),
          ),
        ],
      ),
    );
  }
}
