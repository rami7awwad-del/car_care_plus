import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/booking_quote_response_model.dart';
import '../../logic/booking_cubit.dart';
import '../../logic/booking_state.dart';

class BookingSummaryBottomSheet extends StatelessWidget {
  final QuoteData quoteData;

  const BookingSummaryBottomSheet({super.key, required this.quoteData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingConfirmErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is BookingConfirmSuccessState) {
            Navigator.pop(context); // إغلاق الـ BottomSheet
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تأكيد الحجز بنجاح!'), backgroundColor: Colors.green),
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
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              Text('ملخص التكلفة', style: Theme.of(context).textTheme.titleLarge),
              const Divider(height: 25),

              if (quoteData.invoice != null && quoteData.invoice!.isNotEmpty)
                ...quoteData.invoice!.first.priceItems?.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.label),
                            Text('${item.amount} SAR'),
                          ],
                        ),
                      ),
                    ) ??
                    [],

              const Divider(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('المجموع الإجمالي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('${quoteData.totalPrice} SAR',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                ],
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: isConfirming
                    ? null
                    : () => context.read<BookingCubit>().emitConfirmBooking(quoteData.quoteToken),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: isConfirming
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('تأكيد الحجز النهائي', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }
}