import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/orders/presentation/widgets/order_card.dart';
import 'package:car_care_plus/features/orders/logic/order_cubit.dart';
import 'package:car_care_plus/features/orders/logic/order_state.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سجل الطلبات',
          style: TextStyles.Size18
              .withColor(AppColors.darkBlueBlack)
              .withWeight(FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkBlueBlack),
      ),
      backgroundColor: AppColors.lightBlueSurface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سجل الطلبات',
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'جميع طلباتك السابقة والحالية',
                  style: TextStyles.Size15.withColor(
                    AppColors.surfaceWhite.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                if (state is OrderLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is OrderErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            context.read<OrderCubit>().fetchUserOrders();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is OrderSuccessState) {
                  final orders = state.orders;

                  if (orders.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد طلبات حالياً',
                        style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<OrderCubit>().fetchUserOrders();
                    },
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      itemCount: orders.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) => OrderCard(
                        order: orders[index],
                        // الإلغاء أو إنشاء حجز جديد يغيّران السجل، فنعيد جلبه
                        onChanged: () =>
                            context.read<OrderCubit>().fetchUserOrders(),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}