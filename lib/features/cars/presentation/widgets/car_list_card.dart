import 'package:flutter/material.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/cars/data/car_model.dart';

// بطاقة سيارة داخل قائمة سياراتي
class CarListCard extends StatelessWidget {
  final Car car;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CarListCard({
    super.key,
    required this.car,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: Row(
          children: [
            _CarThumb(imageUrl: car.imageUrl),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.model ?? 'سيارة',
                    style: TextStyles.Size18
                        .withColor(AppColors.darkBlueBlack)
                        .withWeight(FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    car.plateNumber ?? '—',
                    style: TextStyles.Size15.withColor(AppColors.coolGrey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (car.year != null) _Chip(text: '${car.year}'),
                      if (car.fuelType != null) ...[
                        const SizedBox(width: 6),
                        _Chip(text: car.fuelType!.labelAr),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.errorColor,
                ),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}

class _CarThumb extends StatelessWidget {
  final String? imageUrl;

  const _CarThumb({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 64,
        height: 64,
        color: AppColors.lightBlueSurface,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const _CarThumbFallback(),
              )
            : const _CarThumbFallback(),
      ),
    );
  }
}

class _CarThumbFallback extends StatelessWidget {
  const _CarThumbFallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.directions_car_filled_rounded,
        color: AppColors.primaryBlue,
        size: 30,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightBlueSurface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyles.Size10
            .withColor(AppColors.primaryBlue)
            .withWeight(FontWeight.w600),
      ),
    );
  }
}
