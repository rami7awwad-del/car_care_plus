import 'package:car_care_plus/features/auth/presentation/widgets/car_model.dart';
import 'package:flutter/material.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';





class CarCard extends StatelessWidget {
  final CarModel car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.darkCardGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.directions_car_filled_rounded,
                  color: AppColors.cyanAccent,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${car.brand} ${car.model}',
                      style: TextStyles.Size18
                          .withColor(AppColors.surfaceWhite)
                          .withWeight(FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'موديل ${car.year}',
                      style: TextStyles.Size15.withColor(
                        AppColors.surfaceWhite.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _CarInfo(label: 'رقم اللوحة', value: car.plateNumber),
              ),
              Container(
                width: 1,
                height: 34,
                color: AppColors.surfaceWhite.withOpacity(0.15),
              ),
              Expanded(
                child: _CarInfo(label: 'اللون', value: car.colorName),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarInfo extends StatelessWidget {
  final String label;
  final String value;

  const _CarInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyles.Size10.withColor(
            AppColors.surfaceWhite.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyles.Size15
              .withColor(AppColors.surfaceWhite)
              .withWeight(FontWeight.w600),
        ),
      ],
    );
  }
}
