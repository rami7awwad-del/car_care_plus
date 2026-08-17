import 'package:flutter/material.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import '../../data/models/rating_model.dart';
import 'star_rating_bar.dart';

class RatingCard extends StatelessWidget {
  final RatingModel rating;

  const RatingCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'طلب #${rating.orderId}',
                style: TextStyles.Size15
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.bold),
              ),
              const Spacer(),
              StarRatingBar(value: rating.serviceRating, size: 20),
            ],
          ),
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              rating.comment!,
              style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              if (rating.employeeRating != null)
                _MiniStat(label: 'الموظف', value: rating.employeeRating!),
              if (rating.workshopRating != null) ...[
                const SizedBox(width: 12),
                _MiniStat(label: 'الورشة', value: rating.workshopRating!),
              ],
              const Spacer(),
              Text(
                _dateOnly(rating.createdAt),
                style: TextStyles.Size10.withColor(AppColors.coolGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _dateOnly(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    return iso.split('T').first;
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final int value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.lightGoldSurface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.goldAccent, size: 14),
          const SizedBox(width: 4),
          Text(
            '$label $value',
            style: TextStyles.Size10
                .withColor(AppColors.darkBlueBlack)
                .withWeight(FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
