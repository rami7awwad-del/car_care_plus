import 'package:flutter/material.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/orders/data/order_model.dart';
import 'package:car_care_plus/features/orders/presentation/widgets/order_card.dart';
import 'package:car_care_plus/features/rating/ui/views/my_ratings_view.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    const orders = OrderModel.sampleOrders;

    return Scaffold(
      backgroundColor: AppColors.lightBlueSurface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientHeader(
            child: Row(
              children: [
                Expanded(
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
                // اختصار إلى قائمة تقييماتي
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyRatingsView()),
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.goldAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'تقييماتي',
                          style: TextStyles.Size15
                              .withColor(AppColors.surfaceWhite)
                              .withWeight(FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => OrderCard(order: orders[index]),
            ),
          ),
        ],
      ),
    );
  }
}
