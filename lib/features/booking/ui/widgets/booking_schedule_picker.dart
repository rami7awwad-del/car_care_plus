import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';

class BookingSchedulePicker extends StatelessWidget {
  final bool bookingType;
  final ValueChanged<bool> onTypeChanged;
  final ValueChanged<String> onDateTimeSelected;

  const BookingSchedulePicker({
    super.key,
    required this.bookingType,
    required this.onTypeChanged,
    required this.onDateTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الحجز',
          style: TextStyles.Size18.withWeight(FontWeight.bold).withColor(AppColors.darkBlueBlack),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                title: 'حجز فوري',
                subtitle: 'خدمة مباشرة',
                icon: Icons.bolt_rounded,
                isSelected: !bookingType,
                onTap: () => onTypeChanged(false),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTypeCard(
                title: 'حجز مجدول',
                subtitle: 'تحديد موعد',
                icon: Icons.calendar_today_rounded,
                isSelected: bookingType,
                onTap: () => onTypeChanged(true),
              ),
            ),
          ],
        ),
        if (bookingType) ...[
          SizedBox(height: 14.h),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );

              if (date != null && context.mounted) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 10, minute: 0),
                );

                if (time != null && context.mounted) {
                  final fullDateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );

                  final day = fullDateTime.day.toString().padLeft(2, '0');
                  final month = fullDateTime.month.toString().padLeft(2, '0');
                  final year = fullDateTime.year;
                  final hour = fullDateTime.hour.toString().padLeft(2, '0');
                  final minute = fullDateTime.minute.toString().padLeft(2, '0');

                  final formattedString = "$day-$month-$year $hour:$minute:00";
                  onDateTimeSelected(formattedString);
                }
              }
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.lightBlueSurface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_calendar_rounded, color: AppColors.primaryBlue, size: 22.r),
                  SizedBox(width: 8.w),
                  Text(
                    'اختر التاريخ والوقت المفضل',
                    style: TextStyles.Size15.withWeight(FontWeight.w600).withColor(AppColors.primaryBlue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceWhite : AppColors.bgLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderGrey,
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBlue : AppColors.borderGrey.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? Colors.white : AppColors.coolGrey, size: 20.r),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.Size15.withWeight(FontWeight.bold).withColor(
                      isSelected ? AppColors.darkBlueBlack : AppColors.coolGrey,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyles.Size10.withColor(AppColors.coolGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}