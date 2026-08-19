import 'package:car_care_plus/Localization/l10n/app_localization.dart';
import 'package:car_care_plus/core/helper/locale_controller.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// بطاقة الترحيب التي تفتح بها المحادثة قبل أن يصف المستخدم مشكلته
class AiChatWelcomeCard extends StatelessWidget {
  const AiChatWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(16.r),
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
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  gradient: AppColors.cyanGlowGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 20.r,
                  color: AppColors.surfaceWhite,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  l10n.aiChatGreetingTitle,
                  style: TextStyles.Size15
                      .withWeight(FontWeight.bold)
                      .withColor(AppColors.darkBlueBlack),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            l10n.aiChatGreetingBody,
            style: TextStyles.Size15.withColor(AppColors.coolGrey),
          ),

          // المحتوى القادم من السيرفر عربي دائماً مهما كانت لغة الواجهة، فننبّه
          // المستخدم الإنجليزي بدل أن يفاجأ بأسئلة بالعربية
          if (!context.watch<LocaleController>().isArabic) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.lightGoldSurface,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16.r,
                    color: AppColors.goldAccent,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      l10n.aiArabicContentNote,
                      style: TextStyles.Size10.withColor(
                        AppColors.darkBlueBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
