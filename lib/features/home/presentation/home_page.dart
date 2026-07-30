import 'package:flutter/material.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/auth/data/user_mock.dart';
import 'package:car_care_plus/features/home/presentation/widgets/service_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = mockCurrentUser;

    return Scaffold(
      backgroundColor: AppColors.lightBlueSurface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientHeader(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.surfaceWhite.withOpacity(0.15),
                  child: Text(
                    user.name.characters.first,
                    style: TextStyles.Size24
                        .withColor(AppColors.surfaceWhite)
                        .withWeight(FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحباً بك 👋',
                        style: TextStyles.Size15.withColor(
                          AppColors.surfaceWhite.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.name,
                        style: TextStyles.Size18
                            .withColor(AppColors.surfaceWhite)
                            .withWeight(FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.surfaceWhite,
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
                    'ماذا تحتاج اليوم؟',
                    style: TextStyles.Size24
                        .withColor(AppColors.darkBlueBlack)
                        .withWeight(FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'اختر الخدمة المناسبة لسيارتك',
                    style: TextStyles.Size15.withColor(AppColors.coolGrey),
                  ),
                  const SizedBox(height: 24),
                  ServiceCard(
                    title: 'مساعدة طارئة',
                    subtitle: 'دعم فوري على الطريق في أي وقت',
                    icon: Icons.warning_amber_rounded,
                    accentColor: AppColors.errorColor,
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ServiceCard(
                    title: 'خدمة غسيل',
                    subtitle: 'اطلب غسيل سيارتك الآن',
                    icon: Icons.local_car_wash_rounded,
                    accentColor: AppColors.primaryBlue,
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ServiceCard(
                    title: 'غسيل مجدول',
                    subtitle: 'حدّد موعداً دورياً لغسيل سيارتك',
                    icon: Icons.event_available_rounded,
                    accentColor: AppColors.cyanAccent,
                    onTap: () {},
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
