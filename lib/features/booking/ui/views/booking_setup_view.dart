import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/booking_quote_request_body.dart';
import '../../logic/booking_cubit.dart';
import '../../logic/booking_state.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import '../widgets/booking_schedule_picker.dart';
import '../widgets/booking_summary_bottom_sheet.dart';
import '../widgets/location_picker_widget.dart';
import '../widgets/payment_method_selector.dart';

class BookingSetupView extends StatefulWidget {
  final int serviceId;
  final List<int> carIds;
  final List<int>? subServiceIds;
  final List<Map<String, dynamic>>? materials;

  const BookingSetupView({
    super.key,
    required this.serviceId,
    required this.carIds,
    this.subServiceIds,
    this.materials,
  });

  @override
  State<BookingSetupView> createState() => _BookingSetupViewState();
}

class _BookingSetupViewState extends State<BookingSetupView> {
  bool _bookingType = false;
  String? _scheduledAt;
  String _paymentMethod = 'cash';
  final TextEditingController _notesController = TextEditingController();

  double _lat = 24.7136;
  double _lng = 46.6753;
  String? _locationAddress;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _getQuote() {
    if (_bookingType && _scheduledAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى تحديد تاريخ ووقت الحجز المجدول أولاً',
            style: TextStyles.Size15.withColor(Colors.white),
          ),
          backgroundColor: AppColors.warningColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      return;
    }

    final requestBody = BookingQuoteRequestBody(
      carIds: widget.carIds,
      serviceId: widget.serviceId,
      bookingType: _bookingType,
      paymentMethod: _paymentMethod,
      scheduledAt: _bookingType ? _scheduledAt : null,
      locationLat: _lat,
      locationLng: _lng,
      locationAddress: _locationAddress,
      isVip: 1,
      subServiceIds: widget.subServiceIds,
      materials: widget.materials,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      branchId: 1,
    );

    context.read<BookingCubit>().emitBookingQuote(requestBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(
          'تفاصيل الحجز',
          style: TextStyles.Size18.withWeight(FontWeight.bold).withColor(AppColors.darkBlueBlack),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkBlueBlack),
      ),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingQuoteErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: TextStyles.Size15.withColor(Colors.white)),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is BookingQuoteSuccessState) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => BlocProvider.value(
                value: context.read<BookingCubit>(),
                child: BookingSummaryBottomSheet(
                  quoteData: state.quoteResponse.data!,
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. نوع الحجز والتوقيت
              BookingSchedulePicker(
                bookingType: _bookingType,
                onTypeChanged: (isScheduled) {
                  setState(() {
                    _bookingType = isScheduled;
                    if (!_bookingType) _scheduledAt = null;
                  });
                },
                onDateTimeSelected: (dateTime) => setState(() => _scheduledAt = dateTime),
              ),
              SizedBox(height: 20.h),

              // 2. تحديد الموقع الجغرافي
              LocationPickerWidget(
                initialLat: _lat,
                initialLng: _lng,
                onLocationChanged: (lat, lng, address) {
                  setState(() {
                    _lat = lat;
                    _lng = lng;
                    _locationAddress = address;
                  });
                },
              ),
              SizedBox(height: 20.h),

              // 3. اختيار طريقة الدفع
              PaymentMethodSelector(
                selectedMethod: _paymentMethod,
                onMethodChanged: (method) => setState(() => _paymentMethod = method),
              ),
              SizedBox(height: 20.h),

              // 4. ملاحظات إضافية
              Text(
                'ملاحظات إضافية',
                style: TextStyles.Size18.withWeight(FontWeight.bold).withColor(AppColors.darkBlueBlack),
              ),
              SizedBox(height: 10.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadowColor,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _notesController,
                  maxLines: 3,
                  style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
                  decoration: InputDecoration(
                    hintText: 'اكتب أي تفاصيل أخرى ترغب في إبلاغ الورشة بها...',
                    hintStyle: TextStyles.Size15.withColor(AppColors.coolGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: AppColors.borderGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: AppColors.borderGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.all(16.r),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // 5. زر حساب التكلفة
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  final isLoading = state is BookingQuoteLoadingState;
                  return Container(
                    width: double.infinity,
                    height: 54.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _getQuote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'حساب التكلفة وعرض المجموع',
                              style: TextStyles.Size18.withWeight(FontWeight.bold).withColor(Colors.white),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}