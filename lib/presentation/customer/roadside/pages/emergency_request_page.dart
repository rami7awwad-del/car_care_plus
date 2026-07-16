import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:car_care_plus/app/app_language.dart';
import 'package:car_care_plus/core/constants/app_colors.dart';
import 'package:car_care_plus/core/constants/spacing.dart';
import 'package:car_care_plus/presentation/common/widgets/theme_switcher.dart';
import '../cubit/roadside_request_cubit.dart';
import '../models/roadside_models.dart';
import '../widgets/roadside_widgets.dart';

class EmergencyRequestPage extends StatelessWidget {
  const EmergencyRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoadsideRequestCubit(),
      child: const _RequestView(),
    );
  }
}

class _RequestView extends StatelessWidget {
  const _RequestView();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return BlocBuilder<RoadsideRequestCubit, RoadsideRequestState>(
          builder: (context, state) {
            final cubit = context.read<RoadsideRequestCubit>();
            return Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.emergencyRequest),
                actions: const [ThemeSwitcher(color: Colors.white)],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, Spacing.sm),
                    child: StepProgressIndicator(
                      currentStep: state.step,
                      labels: [
                        AppStrings.stepService,
                        AppStrings.stepDetails,
                        AppStrings.stepLocation,
                        AppStrings.stepReview,
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: SingleChildScrollView(
                        key: ValueKey(state.step),
                        padding: const EdgeInsets.all(Spacing.lg),
                        child: _stepContent(context, state, cubit),
                      ),
                    ),
                  ),
                  _bottomBar(context, state, cubit),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _stepContent(BuildContext context, RoadsideRequestState state, RoadsideRequestCubit cubit) {
    switch (state.step) {
      case 0:
        return _ServiceStep(state: state, cubit: cubit);
      case 1:
        return _DetailsStep(state: state, cubit: cubit);
      case 2:
        return _LocationStep(state: state, cubit: cubit);
      default:
        return _ReviewStep(state: state);
    }
  }

  Widget _bottomBar(BuildContext context, RoadsideRequestState state, RoadsideRequestCubit cubit) {
    return SafeArea(
      minimum: const EdgeInsets.all(Spacing.lg),
      child: Row(
        children: [
          if (state.step > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: cubit.previousStep,
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                child: Text(AppStrings.back),
              ),
            ),
          if (state.step > 0) const SizedBox(width: Spacing.md),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                if (!cubit.canAdvance()) {
                  final msg = state.step == 0 ? AppStrings.selectServiceFirst : AppStrings.locationRequired;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  return;
                }
                if (state.isLastStep) {
                  context.push('/roadside/tracking');
                } else {
                  cubit.nextStep();
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              child: Text(state.isLastStep ? AppStrings.requestHelp : AppStrings.next),
            ),
          ),
        ],
      ),
    );
  }
}

// ── الخطوة 1: نوع الخدمة ─────────────────────────────────────────────
class _ServiceStep extends StatelessWidget {
  final RoadsideRequestState state;
  final RoadsideRequestCubit cubit;
  const _ServiceStep({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(AppStrings.stepService),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: Spacing.md,
          crossAxisSpacing: Spacing.md,
          childAspectRatio: 0.95,
          children: ServiceCategory.values
              .map((c) => SelectableCard(
                    icon: c.icon,
                    label: c.label,
                    selected: state.category == c,
                    onTap: () => cubit.selectCategory(c),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ── الخطوة 2: التفاصيل ───────────────────────────────────────────────
class _DetailsStep extends StatelessWidget {
  final RoadsideRequestState state;
  final RoadsideRequestCubit cubit;
  const _DetailsStep({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(AppStrings.severity),
        Row(
          children: Severity.values.map((s) {
            final selected = state.severity == s;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: Spacing.sm),
                child: GestureDetector(
                  onTap: () => cubit.setSeverity(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? s.color.withValues(alpha: 0.15) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Spacing.radiusLg),
                      border: Border.all(color: selected ? s.color : AppColors.border, width: selected ? 2 : 1),
                    ),
                    child: Text(
                      s.label,
                      style: TextStyle(
                        color: selected ? s.color : null,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: Spacing.lg),
        SectionTitle(AppStrings.carType),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: Spacing.md,
          crossAxisSpacing: Spacing.md,
          childAspectRatio: 0.95,
          children: CarType.values
              .map((t) => SelectableCard(
                    icon: t.icon,
                    label: t.label,
                    selected: state.carType == t,
                    onTap: () => cubit.setCarType(t),
                  ))
              .toList(),
        ),
        const SizedBox(height: Spacing.lg),
        SectionTitle(AppStrings.problemDescription),
        TextField(
          maxLines: 3,
          onChanged: cubit.setDescription,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.notes_rounded)),
        ),
      ],
    );
  }
}

// ── الخطوة 3: الموقع والصورة ─────────────────────────────────────────
class _LocationStep extends StatelessWidget {
  final RoadsideRequestState state;
  final RoadsideRequestCubit cubit;
  const _LocationStep({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(AppStrings.stepLocation),
        ClipRRect(
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
          child: SizedBox(
            height: 180,
            child: MockMap(
              overlay: state.locationSet
                  ? null
                  : Container(
                      color: Colors.black.withValues(alpha: 0.05),
                      alignment: Alignment.center,
                      child: Text(AppStrings.locateMe,
                          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary)),
                    ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        if (state.locationSet)
          Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF22C55E)),
              const SizedBox(width: Spacing.sm),
              Text(AppStrings.locationDetected, style: theme.textTheme.bodyMedium),
            ],
          )
        else
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: cubit.setLocation,
              icon: const Icon(Icons.my_location),
              label: Text(AppStrings.locateMe),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ),
        const SizedBox(height: Spacing.lg),
        SectionTitle(AppStrings.addPhoto),
        GestureDetector(
          onTap: cubit.togglePhoto,
          child: Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(Spacing.radiusLg),
              border: Border.all(
                color: state.hasPhoto ? theme.colorScheme.primary : AppColors.border,
                width: state.hasPhoto ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(state.hasPhoto ? Icons.check_circle : Icons.add_a_photo_outlined,
                    color: state.hasPhoto ? theme.colorScheme.primary : theme.hintColor, size: 30),
                const SizedBox(height: Spacing.sm),
                Text(AppStrings.photoHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── الخطوة 4: المراجعة والسعر ────────────────────────────────────────
class _ReviewStep extends StatelessWidget {
  final RoadsideRequestState state;
  const _ReviewStep({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = state.category;

    Widget row(String label, String value, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
              Text(value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                      fontSize: bold ? 18 : 14)),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(AppStrings.requestSummary),
        Container(
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(Spacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              if (c != null) row(AppStrings.stepService, c.label),
              row(AppStrings.severity, state.severity.label),
              row(AppStrings.carType, state.carType.label),
              row(AppStrings.stepLocation, state.locationSet ? AppStrings.locationDetected : '—'),
              const Divider(height: Spacing.xl),
              if (c != null) row(AppStrings.basePrice, '${c.basePrice.toStringAsFixed(0)} ${AppStrings.currency}'),
              row('${AppStrings.total} (${AppStrings.estimatedPrice})',
                  '${state.totalPrice.toStringAsFixed(0)} ${AppStrings.currency}',
                  bold: true),
            ],
          ),
        ),
      ],
    );
  }
}
