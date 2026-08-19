import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// intl يصدّر TextDirection خاصاً به فنخفيه لصالح نوع Flutter
import 'package:intl/intl.dart' hide TextDirection;

import '../../data/models/notification_model.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = _NotificationVisuals.of(notification.type);
    final isUnread = !notification.isRead;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          decoration: BoxDecoration(
            color: isUnread ? AppColors.surfaceWhite : AppColors.bgLight,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isUnread
                  ? style.color.withOpacity(0.25)
                  : AppColors.borderGrey,
            ),
            boxShadow: isUnread
                ? [
                    BoxShadow(
                      color: AppColors.darkBlueBlack.withOpacity(0.05),
                      blurRadius: 14.r,
                      offset: Offset(0, 5.h),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة ملوّنة حسب نوع الإشعار
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: style.color.withOpacity(isUnread ? 0.14 : 0.08),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    style.icon,
                    color: isUnread ? style.color : style.color.withOpacity(0.55),
                    size: 22.r,
                  ),
                ),
                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _AdaptiveText(
                              notification.title,
                              style: TextStyles.Size15
                                  .withColor(AppColors.darkBlueBlack)
                                  .withWeight(
                                    isUnread ? FontWeight.bold : FontWeight.w600,
                                  ),
                              maxLines: 2,
                            ),
                          ),
                          // نقطة تدل على أن الإشعار غير مقروء
                          if (isUnread) ...[
                            SizedBox(width: 8.w),
                            Container(
                              margin: EdgeInsets.only(top: 6.h),
                              width: 8.r,
                              height: 8.r,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 6.h),
                      _AdaptiveText(
                        notification.body,
                        style: TextStyles.Size10
                            .withColor(AppColors.coolGrey)
                            .withHeight(1.6),
                        maxLines: 3,
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13.r,
                            color: AppColors.coolGrey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            formatNotificationTime(notification.createdAt),
                            style: TextStyles.Size10.withColor(AppColors.coolGrey),
                          ),
                          const Spacer(),
                          if (notification.hasReference)
                            Row(
                              children: [
                                Text(
                                  'عرض التفاصيل',
                                  style: TextStyles.Size10
                                      .withColor(AppColors.primaryBlue)
                                      .withWeight(FontWeight.bold),
                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 11.r,
                                  color: AppColors.primaryBlue,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// اللون والأيقونة المرتبطان بكل نوع إشعار
class _NotificationVisuals {
  final Color color;
  final IconData icon;

  const _NotificationVisuals(this.color, this.icon);

  factory _NotificationVisuals.of(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return const _NotificationVisuals(
          AppColors.successColor,
          Icons.check_circle_rounded,
        );
      case NotificationType.warning:
        return const _NotificationVisuals(
          AppColors.goldAccent,
          Icons.warning_amber_rounded,
        );
      case NotificationType.error:
        return const _NotificationVisuals(
          AppColors.errorColor,
          Icons.error_rounded,
        );
      case NotificationType.info:
        return const _NotificationVisuals(
          AppColors.primaryBlue,
          Icons.notifications_rounded,
        );
    }
  }
}

/// نص يضبط اتجاهه حسب محتواه — عناوين الإشعارات مجمّدة على لغة إنشائها
/// فقد يصل نص إنجليزي داخل واجهة عربية أو العكس
class _AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLines;

  const _AdaptiveText(this.text, {required this.style, required this.maxLines});

  static final RegExp _arabic = RegExp('[؀-ۿݐ-ݿ]');

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      textDirection: _arabic.hasMatch(text)
          ? TextDirection.rtl
          : TextDirection.ltr,
    );
  }
}

/// وقت نسبي بالعربية، ويعود للتاريخ الكامل بعد أسبوع
String formatNotificationTime(DateTime? date) {
  if (date == null) return '';

  final difference = DateTime.now().difference(date);

  if (difference.isNegative || difference.inMinutes < 1) return 'الآن';
  if (difference.inMinutes < 60) {
    return 'منذ ${_arabicCount(difference.inMinutes, 'دقيقة', 'دقيقتين', 'دقائق')}';
  }
  if (difference.inHours < 24) {
    return 'منذ ${_arabicCount(difference.inHours, 'ساعة', 'ساعتين', 'ساعات')}';
  }
  if (difference.inDays < 7) {
    return 'منذ ${_arabicCount(difference.inDays, 'يوم', 'يومين', 'أيام')}';
  }
  // بدون تمرير locale لتفادي الحاجة إلى initializeDateFormatting وللإبقاء
  // على الأرقام اللاتينية كبقية التطبيق
  return DateFormat('yyyy/MM/dd').format(date);
}

/// صياغة العدد بالعربية: مفرد، مثنى، جمع قلة (3-10)، ثم تمييز مفرد
String _arabicCount(int count, String singular, String dual, String plural) {
  if (count == 1) return singular;
  if (count == 2) return dual;
  if (count <= 10) return '$count $plural';
  return '$count $singular';
}
