import 'package:flutter/material.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/auth/data/user_mock.dart';
import 'package:car_care_plus/features/profile/data/car_model.dart';
import 'package:car_care_plus/features/profile/presentation/widgets/car_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = mockCurrentUser;

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
                    user.name.characters.first,
                    style: TextStyles.Size32
                        .withColor(AppColors.surfaceWhite)
                        .withWeight(FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user.name,
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
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
                    value: user.phone,
                  ),
                  const SizedBox(height: 12),
                  _InfoTile(
                    icon: Icons.email_outlined,
                    label: 'البريد الإلكتروني',
                    value: user.email,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'سيارتي',
                    style: TextStyles.Size18
                        .withColor(AppColors.darkBlueBlack)
                        .withWeight(FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  const CarCard(car: CarModel.myCar),
                ],
              ),
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
