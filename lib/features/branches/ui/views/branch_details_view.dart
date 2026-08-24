import 'package:car_care_plus/core/helper/launcher_helper.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/branch_model.dart';

/// تفاصيل الفرع.
///
/// لا نستدعي `GET /branches/{id}` هنا: ردّ التفاصيل مطابق تماماً لصف القائمة،
/// فنعرض الكائن الذي وصلنا به من القائمة مباشرة.
class BranchDetailsView extends StatelessWidget {
  final BranchModel branch;
  final double? distanceKm;

  const BranchDetailsView({
    super.key,
    required this.branch,
    this.distanceKm,
  });

  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? AppColors.errorColor
              : AppColors.successColor,
        ),
      );
  }

  void _copy(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    _showMessage(context, 'تم نسخ $label');
  }

  Future<void> _call(BuildContext context) async {
    final launched = await LauncherHelper.callPhone(branch.phone);
    if (!context.mounted || launched) return;
    // إن تعذّر فتح تطبيق الاتصال ننسخ الرقم بدل ترك الإجراء يفشل بصمت
    _copy(context, branch.phone, 'الرقم');
  }

  Future<void> _openMap(BuildContext context) async {
    final launched = await LauncherHelper.openMap(
      latitude: branch.latitude!,
      longitude: branch.longitude!,
      label: branch.displayName,
    );
    if (!context.mounted || launched) return;
    _showMessage(context, 'تعذر فتح تطبيق الخرائط', isError: true);
  }

  @override
  Widget build(BuildContext context) {
    final hours = branch.formattedWorkingHours;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientHeader(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.surfaceWhite,
                        size: 22.r,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'تفاصيل الفرع',
                        style: TextStyles.Size18
                            .withColor(AppColors.surfaceWhite)
                            .withWeight(FontWeight.bold),
                      ),
                    ),
                    if (distanceKm != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '${distanceKm!.toStringAsFixed(1)} كم',
                          style: TextStyles.Size10
                              .withColor(AppColors.surfaceWhite)
                              .withWeight(FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 14.h),
                Text(
                  branch.displayName,
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  branch.city,
                  style: TextStyles.Size15.withColor(
                    AppColors.surfaceWhite.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkBlueBlack.withOpacity(0.04),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: Icons.location_on_outlined,
                        label: 'العنوان',
                        value: branch.address,
                        onTap: () =>
                            _copy(context, branch.address, 'العنوان'),
                      ),
                      if (branch.phone.trim().isNotEmpty)
                        _DetailRow(
                          icon: Icons.phone_rounded,
                          label: 'رقم الهاتف',
                          value: branch.phone,
                          trailingIcon: Icons.call_rounded,
                          onTap: () => _call(context),
                        ),
                      _DetailRow(
                        icon: Icons.access_time_rounded,
                        label: 'أوقات العمل',
                        // is_24h هو الإشارة الموثوقة الوحيدة، وأي شكل غير
                        // معروف لـ working_hours لا يُعرض بدل عرض قيمة خاطئة
                        value: branch.is24h
                            ? 'مفتوح 24 ساعة'
                            : (hours ?? 'غير محددة'),
                      ),
                      if (branch.hasCoordinates)
                        _DetailRow(
                          icon: Icons.map_outlined,
                          label: 'الموقع على الخريطة',
                          value:
                              '${branch.latitude!.toStringAsFixed(5)}, ${branch.longitude!.toStringAsFixed(5)}',
                          trailingIcon: Icons.open_in_new_rounded,
                          onTap: () => _openMap(context),
                          isLast: true,
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // إجراءات سريعة: الاتصال بالفرع وفتحه في الخرائط
                Row(
                  children: [
                    if (branch.phone.trim().isNotEmpty)
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.call_rounded,
                          label: 'اتصل بالفرع',
                          color: AppColors.successColor,
                          onTap: () => _call(context),
                        ),
                      ),
                    if (branch.phone.trim().isNotEmpty &&
                        branch.hasCoordinates)
                      SizedBox(width: 12.w),
                    if (branch.hasCoordinates)
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.directions_rounded,
                          label: 'الاتجاهات',
                          color: AppColors.primaryBlue,
                          onTap: () => _openMap(context),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 16.h),
                // الفرع بلا إحداثيات لا يمكن اختياره تلقائياً كأقرب فرع
                if (!branch.hasCoordinates)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGoldSurface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.goldAccent.withOpacity(0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16.r,
                          color: AppColors.goldAccent,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'لا تتوفر إحداثيات لهذا الفرع، لذلك لا يظهر في الترتيب حسب الأقرب',
                            style: TextStyles.Size10
                                .withColor(AppColors.darkBlueBlack)
                                .withHeight(1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18.r, color: AppColors.surfaceWhite),
        label: Text(
          label,
          style: TextStyles.Size15
              .withColor(AppColors.surfaceWhite)
              .withWeight(FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final IconData? trailingIcon;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailingIcon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h, top: 2.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.lightBlueSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 18.r, color: AppColors.primaryBlue),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyles.Size10.withColor(AppColors.coolGrey),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    value,
                    style: TextStyles.Size15
                        .withColor(AppColors.darkBlueBlack)
                        .withWeight(FontWeight.w600)
                        .withHeight(1.5),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                trailingIcon ?? Icons.copy_rounded,
                size: 16.r,
                color: AppColors.primaryBlue,
              ),
          ],
        ),
      ),
    );
  }
}
