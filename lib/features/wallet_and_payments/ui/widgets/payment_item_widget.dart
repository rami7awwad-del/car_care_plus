import 'package:flutter/material.dart';
import 'package:car_care_plus/features/orders/data/booking_model.dart';
import 'package:car_care_plus/features/orders/presentation/widgets/order_card.dart';

class PaymentItemWidget extends StatelessWidget {
  final BookingModel order;

  const PaymentItemWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return OrderCard(order: order);
  }
}