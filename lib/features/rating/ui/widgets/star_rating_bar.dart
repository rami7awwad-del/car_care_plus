import 'package:flutter/material.dart';
import 'package:car_care_plus/core/resources/app_color.dart';

// شريط نجوم — تفاعلي عند تمرير onChanged، وإلا للعرض فقط
class StarRatingBar extends StatelessWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final double size;

  const StarRatingBar({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 34,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final filled = starValue <= value;
        return GestureDetector(
          onTap: onChanged == null ? null : () => onChanged!(starValue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: filled ? AppColors.goldAccent : AppColors.coolGrey,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}
