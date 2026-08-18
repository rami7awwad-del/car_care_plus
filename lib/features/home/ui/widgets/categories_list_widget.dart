import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/category_model.dart';

/// شريط التصنيفات الأفقي أعلى قائمة الخدمات.
class CategoriesListWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategorySelected;

  /// يمرّره الأب ليتطابق مع هامش بقية أقسام الصفحة
  final double horizontalPadding;

  const CategoriesListWidget({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.horizontalPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 104.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final category = categories[index];

          return _CategoryChip(
            category: category,
            isSelected: selectedCategoryId == category.id,
            onTap: () => onCategorySelected(category.id),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  IconData _iconFor(String name) {
    if (name.contains('غسيل') || name.toLowerCase().contains('wash')) {
      return Icons.local_car_wash_rounded;
    } else if (name.contains('صيانة') || name.toLowerCase().contains('maint')) {
      return Icons.build_circle_rounded;
    } else if (name.contains('زيت') || name.toLowerCase().contains('oil')) {
      return Icons.oil_barrel_rounded;
    }
    return Icons.miscellaneous_services_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20.r);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 96.w,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.buttonGradient : null,
          color: isSelected ? null : AppColors.surfaceWhite,
          borderRadius: radius,
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.borderGrey,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryBlue.withOpacity(0.3)
                  : AppColors.cardShadowColor,
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.surfaceWhite.withOpacity(0.2)
                    : AppColors.lightBlueSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _iconFor(category.nameAr),
                color: isSelected
                    ? AppColors.surfaceWhite
                    : AppColors.primaryBlue,
                size: 22.r,
              ),
            ),
            SizedBox(height: 6.h),
            Flexible(
              child: Text(
                category.nameAr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyles.Size10
                    .withWeight(isSelected ? FontWeight.bold : FontWeight.w600)
                    .withColor(
                      isSelected
                          ? AppColors.surfaceWhite
                          : AppColors.darkBlueBlack,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
