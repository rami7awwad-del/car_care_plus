import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:car_care_plus/app/app_language.dart';
import 'package:car_care_plus/core/constants/app_colors.dart';
import 'package:car_care_plus/core/constants/spacing.dart';
import 'package:car_care_plus/presentation/common/widgets/theme_switcher.dart';
import '../cubit/roadside_tracking_cubit.dart';
import '../models/roadside_models.dart';
import '../widgets/roadside_widgets.dart';

class EmergencyTrackingPage extends StatelessWidget {
  const EmergencyTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoadsideTrackingCubit()..start(),
      child: const _TrackingView(),
    );
  }
}

class _TrackingView extends StatelessWidget {
  const _TrackingView();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return BlocBuilder<RoadsideTrackingCubit, RoadsideTrackingState>(
          builder: (context, state) {
            final theme = Theme.of(context);
            return Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.trackingTitle),
                actions: const [ThemeSwitcher(color: Colors.white)],
              ),
              body: Column(
                children: [
                  // الخريطة (Placeholder)
                  Expanded(
                    flex: 4,
                    child: MockMap(
                      overlay: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.all(Spacing.md),
                          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(Spacing.radiusRound),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!state.isCompleted && !state.cancelled)
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              else
                                Icon(state.cancelled ? Icons.cancel : Icons.check_circle,
                                    size: 16, color: state.cancelled ? AppColors.error : const Color(0xFF22C55E)),
                              const SizedBox(width: Spacing.sm),
                              Flexible(
                                child: Text(
                                  state.cancelled ? AppStrings.requestCancelled : state.status.label,
                                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // اللوحة السفلية
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(Spacing.lg),
                      child: _panel(context, state),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _panel(BuildContext context, RoadsideTrackingState state) {
    final theme = Theme.of(context);
    final cubit = context.read<RoadsideTrackingCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.employee != null) ...[
          EmployeeCard(
            employee: state.employee!,
            onCall: () => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(AppStrings.callTechnician))),
          ),
          const SizedBox(height: Spacing.lg),
        ],
        SectionTitle(AppStrings.trackingTitle),
        StatusTimeline(current: state.status),
        const SizedBox(height: Spacing.sm),
        if (state.canCancel) ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                cubit.cancel();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(AppStrings.requestCancelled)));
              },
              icon: const Icon(Icons.close, color: AppColors.error),
              label: Text(AppStrings.cancelRequest, style: const TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Spacing.sm),
            child: Text(AppStrings.cancelWindowHint,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ),
        ],
        if (state.isCompleted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.star_rounded),
              label: Text(AppStrings.rateService),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            ),
          ),
      ],
    );
  }
}
