import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// أيقونة الدردشة التي تفتح شاشة المساعد الذكي — مصمّمة لتوضع فوق البطاقات
/// الملوّنة، لذلك خلفيتها بيضاء وأيقونتها بلون الهوية
class AiChatLauncherButton extends StatelessWidget {
  /// يُمرَّر عند فتح المحادثة من طلب صيانة قائم
  final int? orderId;

  const AiChatLauncherButton({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceWhite,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: AppColors.darkBlueBlack.withOpacity(0.25),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.aiChat,
          arguments: orderId,
        ),
        customBorder: const CircleBorder(),
        child: Container(
          width: 54.r,
          height: 54.r,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.successColor,
                size: 24.r,
              ),
              SizedBox(height: 1.h),
              Text(
                'AI',
                style: TextStyles.Size10
                    .withSize(9)
                    .withWeight(FontWeight.bold)
                    .withColor(AppColors.successColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
