import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/booking_cubit.dart';
import '../../logic/booking_state.dart';
import '../../data/models/booking_quote_request_body.dart';
import '../widgets/booking_schedule_picker.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/booking_summary_bottom_sheet.dart';

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
  // إحداثيات افتراضية (يمكن استبدالها بـ Geolocation)
  final double _lat = 24.7136;
  final double _lng = 46.6753;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _getQuote() {

    if (_bookingType && _scheduledAt == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('يرجى تحديد تاريخ الحجز أولاً'),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }
  
    final requestBody = BookingQuoteRequestBody(
  carIds: widget.carIds,
  serviceId: widget.serviceId,
  bookingType: _bookingType,
  paymentMethod: _paymentMethod,
  // ⚠️ نمرر التاريخ فقط إذا كان الحجز مجدولاً
  scheduledAt: _bookingType ? _scheduledAt : null, 
  locationLat: _lat,
  locationLng: _lng,
  isVip: 1,
  subServiceIds: widget.subServiceIds,
  materials: widget.materials,
  notes: _notesController.text.isNotEmpty ? _notesController.text : null,
  branchId: 1, // 👈 استخدام branchId بدلاً من workshopId
);

    context.read<BookingCubit>().emitBookingQuote(requestBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحجز'), centerTitle: true),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingQuoteErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is BookingQuoteSuccessState) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. نوع الحجز والتوقيت
              // 1. نوع الحجز والتوقيت
              BookingSchedulePicker(
                bookingType:
                    _bookingType, // متغير من نوع bool (false للفوري، true للمجدول)
                onTypeChanged: (isScheduled) {
                  setState(() {
                    _bookingType = isScheduled;
                    if (!_bookingType) {
                       _scheduledAt = null; // 👈 إعادتها لـ null عند اختيار الفوري
      }
                  });
                },
                onDateTimeSelected: (dateTime) =>
                    setState(() => _scheduledAt = dateTime),
              ),
              const SizedBox(height: 20),

              // 2. اختيار طريقة الدفع
              PaymentMethodSelector(
                selectedMethod: _paymentMethod,
                onMethodChanged: (method) =>
                    setState(() => _paymentMethod = method),
              ),
              const SizedBox(height: 20),

              // 3. ملاحظات إضافية
              Text(
                'ملاحظات إضافية',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'اكتب أي تفاصيل أخرى ترغب في إبلاغ الورشة بها...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // 4. زر حساب التكلفة
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  final isLoading = state is BookingQuoteLoadingState;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _getQuote,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'حساب التكلفة وعرض المجموع',
                            style: TextStyle(fontSize: 16),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
