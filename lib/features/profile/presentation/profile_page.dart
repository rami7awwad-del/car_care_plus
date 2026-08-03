import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/core/network/auth_session.dart';
import 'package:car_care_plus/core/network/dio_factory.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/auth/data/user_mock.dart';
import 'package:car_care_plus/features/cars/data/car_model.dart';
import 'package:car_care_plus/features/cars/data/cars_remote_data_source.dart';
import 'package:car_care_plus/features/cars/data/cars_repository_impl.dart';
import 'package:car_care_plus/features/cars/presentation/car_details_page.dart';
import 'package:car_care_plus/features/cars/presentation/cubit/cars_cubit.dart';
import 'package:car_care_plus/features/cars/presentation/cubit/cars_state.dart';
import 'package:car_care_plus/features/cars/presentation/widgets/car_list_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarsCubit(
        carsRepository: CarsRepositoryImpl(
          remoteDataSource: CarsRemoteDataSourceImpl(dio: createDio()),
        ),
      )..getMyCars(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  Future<void> _confirmDelete(BuildContext context, Car car) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'حذف السيارة',
          style: TextStyles.Size18
              .withColor(AppColors.darkBlueBlack)
              .withWeight(FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من حذف ${car.model ?? 'هذه السيارة'}؟',
          style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'إلغاء',
              style: TextStyles.Size15.withColor(AppColors.coolGrey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'حذف',
              style: TextStyles.Size15
                  .withColor(AppColors.errorColor)
                  .withWeight(FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final error = await context.read<CarsCubit>().deleteCar(car.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'تم حذف السيارة بنجاح'),
        backgroundColor:
            error == null ? AppColors.primaryBlue : AppColors.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = AuthSession.instance;
    final name = session.name ?? mockCurrentUser.name;
    final email = session.email ?? mockCurrentUser.email;
    final phone = session.phone ?? mockCurrentUser.phone;

    return Scaffold(
      backgroundColor: AppColors.lightBlueSurface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientHeader(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.surfaceWhite.withOpacity(0.15),
                  child: Text(
                    name.isNotEmpty ? name.characters.first : '؟',
                    style: TextStyles.Size32
                        .withColor(AppColors.surfaceWhite)
                        .withWeight(FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  name,
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyles.Size15.withColor(
                    AppColors.surfaceWhite.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات الحساب',
                    style: TextStyles.Size18
                        .withColor(AppColors.darkBlueBlack)
                        .withWeight(FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  _InfoTile(
                    icon: Icons.phone_android_rounded,
                    label: 'رقم الهاتف',
                    value: phone,
                  ),
                  const SizedBox(height: 12),
                  _InfoTile(
                    icon: Icons.email_outlined,
                    label: 'البريد الإلكتروني',
                    value: email,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Text(
                        'سياراتي',
                        style: TextStyles.Size18
                            .withColor(AppColors.darkBlueBlack)
                            .withWeight(FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () =>
                            context.read<CarsCubit>().getMyCars(),
                        icon: const Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: AppColors.primaryBlue,
                        ),
                        label: Text(
                          'تحديث',
                          style: TextStyles.Size15
                              .withColor(AppColors.primaryBlue)
                              .withWeight(FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CarsCubit, CarsState>(
                    builder: (context, state) {
                      if (state is CarsLoading) {
                        return const _CarsLoading();
                      } else if (state is CarsError) {
                        return _CarsError(
                          message: state.message,
                          onRetry: () =>
                              context.read<CarsCubit>().getMyCars(),
                        );
                      } else if (state is CarsLoaded) {
                        if (state.cars.isEmpty) return const _CarsEmpty();
                        return Column(
                          children: [
                            for (final car in state.cars) ...[
                              CarListCard(
                                car: car,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CarDetailsPage(car: car),
                                  ),
                                ),
                                onDelete: () => _confirmDelete(context, car),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarsLoading extends StatelessWidget {
  const _CarsLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _CarsEmpty extends StatelessWidget {
  const _CarsEmpty();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 48,
            color: AppColors.coolGrey.withOpacity(0.6),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد سيارات مضافة',
            style: TextStyles.Size15.withColor(AppColors.coolGrey),
          ),
        ],
      ),
    );
  }
}

class _CarsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CarsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 40,
            color: AppColors.errorColor,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'إعادة المحاولة',
              style: TextStyles.Size15
                  .withColor(AppColors.primaryBlue)
                  .withWeight(FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.lightBlueSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 24),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyles.Size10.withColor(AppColors.coolGrey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyles.Size15
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
