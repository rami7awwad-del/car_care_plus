import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/ai_chat_message.dart';

/// فقاعة رسالة نصية واحدة داخل المحادثة
class AiMessageBubble extends StatelessWidget {
  final AiChatMessage message;

  const AiMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == AiMessageSender.user;

    return Align(
      alignment: isUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.78.sw),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryBlue : AppColors.surfaceWhite,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(16.r),
            topEnd: Radius.circular(16.r),
            bottomStart: Radius.circular(isUser ? 16.r : 4.r),
            bottomEnd: Radius.circular(isUser ? 4.r : 16.r),
          ),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadowColor, blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyles.Size15.withColor(
            isUser ? AppColors.surfaceWhite : AppColors.darkBlueBlack,
          ),
        ),
      ),
    );
  }
}

/// مؤشّر "يكتب الآن" — نداء التشخيص الأخير قد يستغرق حتى دقيقة، لذا نُبقي
/// مؤشراً متحركاً مع نص واضح بدل دوّارة تبدو معلّقة
class AiTypingIndicator extends StatelessWidget {
  final String label;

  const AiTypingIndicator({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadowColor, blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16.r,
              height: 16.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              label,
              style: TextStyles.Size10.withColor(AppColors.coolGrey),
            ),
          ],
        ),
      ),
    );
  }
}
