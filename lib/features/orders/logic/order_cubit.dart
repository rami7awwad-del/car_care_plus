import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/features/orders/data/booking_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final ApiService _apiService;

  OrderCubit(this._apiService) : super(OrderInitialState());

  Future<void> fetchUserOrders() async {
    emit(OrderLoadingState());
    try {
      final response = await _apiService.get(endpoint: ApiConstants.userBookings);

      if (response.data != null && response.data['data'] != null) {
        final List dynamicList = response.data['data'] is List 
            ? response.data['data'] 
            : [response.data['data']];

        final orders = dynamicList.map((e) => BookingModel.fromJson(e)).toList();
        emit(OrderSuccessState(orders));
      } else {
        emit(OrderSuccessState([]));
      }
    } catch (error) {
      emit(OrderErrorState(error.toString()));
    }
  }
}