import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:car_care_plus/app/app_language.dart';
import 'package:car_care_plus/core/constants/app_colors.dart';
import 'package:car_care_plus/core/constants/spacing.dart';
import 'package:car_care_plus/presentation/common/widgets/theme_switcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Car Care Plus'),
            actions: const [ThemeSwitcher(color: Colors.white)],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // بطاقة المساعدة الطارئة
                _EmergencyBanner(onTap: () => context.push('/roadside')),
                const SizedBox(height: Spacing.xl),
                Text(AppStrings.roadAssistance,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: Spacing.sm),
                Text('باقي الخدمات قيد الإنشاء…',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _EmergencyBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(Spacing.radiusXl),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(Spacing.xl),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.error, Color(0xFFB91C1C)],
            ),
            borderRadius: BorderRadius.circular(Spacing.radiusXl),
            boxShadow: [
              BoxShadow(color: AppColors.error.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Spacing.radiusLg),
                ),
                child: const Icon(Icons.emergency_share_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.roadAssistance,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(AppStrings.emergencySubtitle,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
