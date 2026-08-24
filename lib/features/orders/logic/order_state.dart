 // أو order_model.dart بحسب اسم الموديل لديك

import 'package:car_care_plus/features/orders/data/booking_model.dart';

abstract class OrderState {}

class OrderInitialState extends OrderState {}

class OrderLoadingState extends OrderState {}

class OrderSuccessState extends OrderState {
  final List<BookingModel> orders;
  OrderSuccessState(this.orders);
}

class OrderErrorState extends OrderState {
  final String message;
  OrderErrorState(this.message);
}