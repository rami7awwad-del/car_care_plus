import 'package:car_care_plus/Localization/l10n/app_localization.dart';
import 'package:car_care_plus/core/helper/locale_controller.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// مبدّل اللغة بين العربية والإنجليزية.
///
/// مفتاح مقسوم إلى نصفين مع مؤشّر متحرّك ينزلق تحت اللغة الفعّالة. اسم كل لغة
/// مكتوب بحروفها هي، فيبقى مفهوماً أياً كانت اللغة المعروضة حالياً
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<LocaleController>();
    final isArabic = controller.isArabic;

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== العنوان ====================
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  gradient: AppColors.cyanGlowGradient,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.translate_rounded,
                  size: 18.r,
                  color: AppColors.surfaceWhite,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                l10n.language,
                style: TextStyles.Size15
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // ==================== المفتاح المنزلق ====================
          Container(
            height: 44.h,
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Stack(
              children: [
                // المؤشّر المتحرّك — AlignmentDirectional يجعله يتبع اتجاه
                // الواجهة تلقائياً، فيقف دائماً تحت الخيار الصحيح في RTL و LTR
                AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  alignment: isArabic
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.centerEnd,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(11.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    _LanguageOption(
                      label: l10n.languageArabic,
                      isSelected: isArabic,
                      onTap: () => controller.setLocale(LocaleController.arabic),
                    ),
                    _LanguageOption(
                      label: l10n.languageEnglish,
                      isSelected: !isArabic,
                      onTap: () =>
                          controller.setLocale(LocaleController.english),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyles.Size15
                .withColor(
                  isSelected ? AppColors.surfaceWhite : AppColors.coolGrey,
                )
                .withWeight(isSelected ? FontWeight.bold : FontWeight.w500),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
