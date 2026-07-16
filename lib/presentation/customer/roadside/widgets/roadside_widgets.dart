import 'package:flutter/material.dart';

import 'package:car_care_plus/app/app_language.dart';
import 'package:car_care_plus/core/constants/app_colors.dart';
import 'package:car_care_plus/core/constants/spacing.dart';
import '../models/roadside_models.dart';

/// عنوان قسم داخل الخطوات.
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md, top: Spacing.sm),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

/// بطاقة اختيار (أيقونة + نص) بحالة محددة/غير محددة — تُستخدم في الشبكات.
class SelectableCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = theme.colorScheme.primary;

    return Material(
      color: selected ? accent.withValues(alpha: 0.10) : theme.cardColor,
      borderRadius: BorderRadius.circular(Spacing.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: Spacing.lg, horizontal: Spacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Spacing.radiusLg),
            border: Border.all(color: selected ? accent : AppColors.border, width: selected ? 2 : 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30, color: selected ? accent : theme.iconTheme.color),
              const SizedBox(height: Spacing.sm),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? accent : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// شريط تقدّم الخطوات في الأعلى.
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const StepProgressIndicator({super.key, required this.currentStep, required this.labels});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Row(
      children: List.generate(labels.length, (i) {
        final bool done = i <= currentStep;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _bar(i > 0 && i <= currentStep ? accent : AppColors.border)),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: done ? accent : AppColors.border,
                    child: i < currentStep
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text('${i + 1}',
                            style: TextStyle(
                                fontSize: 12,
                                color: done ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.bold)),
                  ),
                  Expanded(child: _bar(i < currentStep ? accent : AppColors.border)),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                labels[i],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: done ? accent : theme.hintColor,
                  fontWeight: i == currentStep ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _bar(Color color) => Container(height: 2, color: color);
}

/// خريطة وهمية (Placeholder) — تُستبدل بخريطة حقيقية لاحقاً.
class MockMap extends StatelessWidget {
  final Widget? overlay;
  const MockMap({super.key, this.overlay});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDCE6F5), Color(0xFFB9CBE8)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // شبكة طرق بسيطة
          CustomPaint(size: Size.infinite, painter: _RoadsPainter()),
          const Icon(Icons.location_on, size: 48, color: AppColors.error),
          if (overlay != null) Positioned.fill(child: overlay!),
        ],
      ),
    );
  }
}

class _RoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 6;
    for (double x = 40; x < size.width; x += 90) {
      canvas.drawLine(Offset(x, 0), Offset(x + 30, size.height), paint);
    }
    for (double y = 50; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 20), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// خط زمني لحالة الطلب.
class StatusTimeline extends StatelessWidget {
  final TrackingStatus current;
  const StatusTimeline({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    // نعرض المراحل الرئيسية بدون "searching" (قبل التعيين).
    const stages = [
      TrackingStatus.assigned,
      TrackingStatus.enRoute,
      TrackingStatus.arrived,
      TrackingStatus.inProgress,
      TrackingStatus.completed,
    ];

    return Column(
      children: List.generate(stages.length, (i) {
        final stage = stages[i];
        final bool done = current.index >= stage.index;
        final bool isLast = i == stages.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: done ? accent : AppColors.border,
                    child: Icon(done ? Icons.check : Icons.circle_outlined,
                        size: 14, color: done ? Colors.white : AppColors.textSecondary),
                  ),
                  if (!isLast)
                    Expanded(child: Container(width: 2, color: done ? accent : AppColors.border)),
                ],
              ),
              const SizedBox(width: Spacing.md),
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.lg, top: 2),
                child: Text(
                  stage.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: current == stage ? FontWeight.bold : FontWeight.normal,
                    color: done ? null : theme.hintColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// بطاقة معلومات الفني المعيّن.
class EmployeeCard extends StatelessWidget {
  final RoadsideEmployee employee;
  final VoidCallback onCall;

  const EmployeeCard({super.key, required this.employee, required this.onCall});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            child: Icon(Icons.engineering_rounded, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('${employee.vehicle} • ${employee.plate}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: AppColors.secondary),
                    const SizedBox(width: 2),
                    Text(employee.rating.toString(), style: theme.textTheme.bodySmall),
                    const SizedBox(width: Spacing.sm),
                    Text('•  ${AppStrings.etaMinutes(employee.etaMinutes)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                  ],
                ),
              ],
            ),
          ),
          IconButton.filled(
            onPressed: onCall,
            icon: const Icon(Icons.phone),
            tooltip: AppStrings.callTechnician,
          ),
        ],
      ),
    );
  }
}
