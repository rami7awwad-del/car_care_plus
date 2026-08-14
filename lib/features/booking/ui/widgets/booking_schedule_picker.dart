import 'package:flutter/material.dart';

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
        Text('نوع الحجز', style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('فوري'),
                value: false,
                groupValue: bookingType,
                onChanged: (val) => onTypeChanged(val!),
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('مجدول'),
                value: true,
                groupValue: bookingType,
                onChanged: (val) => onTypeChanged(val!),
              ),
            ),
          ],
        ),
        if (bookingType) // إذا كان مجدولاً يظهر زر اختيار التاريخ والوقت
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                // 1. اختيار التاريخ
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );

                if (date != null && context.mounted) {
                  // 2. اختيار الوقت مباشرة بعد اختيار التاريخ
                  final time = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 10, minute: 0),
                  );

                  if (time != null && context.mounted) {
                    // 3. تجميع التاريخ والوقت
                    final fullDateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );

                    // 4. تنسيق التاريخ بصيغة DD-MM-YYYY HH:mm (أو YYYY-MM-DD HH:mm:ss)
                    final day = fullDateTime.day.toString().padLeft(2, '0');
                    final month = fullDateTime.month.toString().padLeft(2, '0');
                    final year = fullDateTime.year;
                    final hour = fullDateTime.hour.toString().padLeft(2, '0');
                    final minute = fullDateTime.minute.toString().padLeft(2, '0');

                    // الصيغة المطابقة لـ Postman لديك (مثال: 20-10-2026 أو 2026-10-20 10:00:00)
                    final formattedString = "$day-$month-$year $hour:$minute:00";

                    onDateTimeSelected(formattedString);
                  }
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('اختر التاريخ والوقت'),
            ),
          ),
      ],
    );
  }
}