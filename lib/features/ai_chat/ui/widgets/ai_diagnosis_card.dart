import 'package:car_care_plus/Localization/l10n/app_localization.dart';
import 'package:car_care_plus/core/helper/locale_controller.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/models/ai_diagnosis_model.dart';

/// كرت التشخيص النهائي: الخطورة، الأسباب المحتملة، النصيحة، والخدمة المقترحة.
///
/// ملاحظة: محتوى التشخيص نفسه (الأسباب والنصيحة) يصل من السيرفر بالعربية
/// دائماً مهما كانت لغة الواجهة — المترجم هنا هو إطار الكرت فقط
class AiDiagnosisCard extends StatelessWidget {
  final AiDiagnosis diagnosis;

  /// يظهر زر إضافة الخدمة فقط عند فتح المحادثة من طلب صيانة يملكه المستخدم
  final bool canApplyService;
  final bool isApplying;
  final bool isApplied;
  final ValueChanged<AiRecommendedService>? onApplyService;

  const AiDiagnosisCard({
    super.key,
    required this.diagnosis,
    this.canApplyService = false,
    this.isApplying = false,
    this.isApplied = false,
    this.onApplyService,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final service = diagnosis.recommendedService;

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
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== العنوان ودرجة الخطورة ====================
          Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: AppColors.primaryBlue,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  l10n.aiDiagnosisResult,
                  style: TextStyles.Size15
                      .withWeight(FontWeight.bold)
                      .withColor(AppColors.darkBlueBlack),
                ),
              ),
              _SeverityChip(severity: diagnosis.severity),
            ],
          ),
          SizedBox(height: 14.h),

          // ==================== الأسباب المحتملة (قد تعود فارغة) ====================
          if (diagnosis.possibleCauses.isNotEmpty) ...[
            Text(
              l10n.aiPossibleCauses,
              style: TextStyles.Size10
                  .withWeight(FontWeight.bold)
                  .withColor(AppColors.coolGrey),
            ),
            SizedBox(height: 6.h),
            ...diagnosis.possibleCauses.map(
              (cause) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Container(
                        width: 5.r,
                        height: 5.r,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        cause,
                        style: TextStyles.Size15.withColor(
                          AppColors.darkBlueBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],

          // ==================== النصيحة ====================
          // نص عادي فقط — قد يحتوي أسطراً أو بقايا Markdown ولا يُعرض كـ HTML
          if (diagnosis.advice.trim().isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.lightBlueSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                diagnosis.advice,
                style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
              ),
            ),
            SizedBox(height: 12.h),
          ],

          // ==================== الخدمة المقترحة ====================
          if (service != null)
            _RecommendedServiceTile(
              service: service,
              canApply: canApplyService,
              isApplying: isApplying,
              isApplied: isApplied,
              onApply: onApplyService,
            )
          else
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16.r,
                  color: AppColors.coolGrey,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    l10n.aiNoMatchingService,
                    style: TextStyles.Size10.withColor(AppColors.coolGrey),
                  ),
                ),
              ],
            ),

          // ==================== تنبيه إجابة الذكاء الاصطناعي ====================
          if (diagnosis.isAiGenerated) ...[
            SizedBox(height: 10.h),
            Text(
              l10n.aiGeneratedDisclaimer,
              style: TextStyles.Size10.withColor(AppColors.coolGrey),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== شارة الخطورة ====================

class _SeverityChip extends StatelessWidget {
  final AiSeverity severity;

  const _SeverityChip({required this.severity});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final (color, label) = switch (severity) {
      AiSeverity.low => (AppColors.successColor, l10n.aiSeverityLow),
      AiSeverity.medium => (AppColors.goldAccent, l10n.aiSeverityMedium),
      AiSeverity.high => (AppColors.errorColor, l10n.aiSeverityHigh),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyles.Size10.withWeight(FontWeight.bold).withColor(color),
      ),
    );
  }
}

// ==================== بطاقة الخدمة المقترحة ====================

class _RecommendedServiceTile extends StatelessWidget {
  final AiRecommendedService service;
  final bool canApply;
  final bool isApplying;
  final bool isApplied;
  final ValueChanged<AiRecommendedService>? onApply;

  const _RecommendedServiceTile({
    required this.service,
    required this.canApply,
    required this.isApplying,
    required this.isApplied,
    this.onApply,
  });

  /// العملية إحلالية على السيرفر: تستبدل خدمة الطلب وتعيد ضبط سعره الإجمالي،
  /// فنطلب تأكيداً صريحاً قبل تنفيذها
  Future<void> _confirmAndApply(BuildContext context, String serviceName) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
        title: Text(
          l10n.aiApplyServiceConfirmTitle,
          style: TextStyles.Size18
              .withWeight(FontWeight.bold)
              .withColor(AppColors.darkBlueBlack),
        ),
        content: Text(
          l10n.aiApplyServiceConfirmBody(serviceName),
          style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.cancel,
              style: TextStyles.Size15.withColor(AppColors.coolGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: Text(
              l10n.confirm,
              style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) onApply?.call(service);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = context.watch<LocaleController>().isArabic;
    final serviceName = service.displayName(isArabic: isArabic);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.aiRecommendedService,
            style: TextStyles.Size10
                .withWeight(FontWeight.bold)
                .withColor(AppColors.coolGrey),
          ),
          SizedBox(height: 6.h),
          Text(
            serviceName,
            style: TextStyles.Size15
                .withWeight(FontWeight.bold)
                .withColor(AppColors.darkBlueBlack),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 15.r,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 4.w),
              Text(
                // السعر يصل كنص من السيرفر وقد حُوِّل إلى رقم داخل النموذج
                service.price.toStringAsFixed(2),
                style: TextStyles.Size15
                    .withWeight(FontWeight.bold)
                    .withColor(AppColors.primaryBlue),
              ),
              SizedBox(width: 14.w),
              Icon(Icons.schedule_rounded, size: 15.r, color: AppColors.coolGrey),
              SizedBox(width: 4.w),
              Text(
                l10n.minutesFormat(service.durationMinutes),
                style: TextStyles.Size10.withColor(AppColors.coolGrey),
              ),
            ],
          ),
          if (canApply) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (isApplying || isApplied)
                    ? null
                    : () => _confirmAndApply(context, serviceName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isApplied
                      ? AppColors.successColor
                      : AppColors.primaryBlue,
                  disabledBackgroundColor: isApplied
                      ? AppColors.successColor
                      : AppColors.coolGrey,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: isApplying
                    ? SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.surfaceWhite,
                        ),
                      )
                    : Icon(
                        isApplied
                            ? Icons.check_circle_outline_rounded
                            : Icons.add_circle_outline_rounded,
                        color: AppColors.surfaceWhite,
                        size: 18.r,
                      ),
                label: Text(
                  isApplied
                      ? l10n.aiServiceAddedToOrder
                      : l10n.aiAddServiceToOrder,
                  style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
