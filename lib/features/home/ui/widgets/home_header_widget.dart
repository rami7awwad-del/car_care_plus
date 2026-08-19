import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/notifications/ui/widgets/notification_bell_button.dart';
import 'package:car_care_plus/features/ai_chat/ui/widgets/ai_chat_launcher_button.dart';

class HomeHeaderWidget extends StatelessWidget {
  /// فتح القائمة الجانبية
  final VoidCallback? onMenuPressed;

  const HomeHeaderWidget({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================== شريط الترحيب وأزرار التحكم ====================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أهلاً بك 👋',
                          style: TextStyles.Size15.withColor(AppColors.cyanAccent),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'اختر خدمة سيارتك',
                          style: TextStyles.Size24
                              .withWeight(FontWeight.bold)
                              .withColor(AppColors.surfaceWhite),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // جرس الإشعارات
                      const NotificationBellButton(),
                      SizedBox(width: 10.w),
                      // زر فتح القائمة الجانبية (Drawer Button)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onMenuPressed,
                          borderRadius: BorderRadius.circular(14.r),
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWhite.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: AppColors.surfaceWhite.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.menu_rounded,
                              color: AppColors.surfaceWhite,
                              size: 24.r,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // ==================== كرت العرض الترويجي المزود بالصورة الدائرية ====================
              const _AnimatedPromoCard(
                // 💡 استبدل هذا المسار بمسار صورة اللوجو / البانر الموجودة في مجلد assets لديك
                imagePath: 'assets/images/promo_logo.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// كرت العروض مع فقاعات متدرجة وصورة دائرية بدلاً من الأيقونة
class _AnimatedPromoCard extends StatelessWidget {
  final String imagePath;

  const _AnimatedPromoCard({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.cyanGlowGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // ---------- الفقاعات المتدرجة الموزعة داخل الكارت ----------
            Positioned(
              top: -20.h,
              right: -20.w,
              child: _buildBubble(
                size: 90.r,
                colors: [
                  AppColors.surfaceWhite.withOpacity(0.35),
                  AppColors.primaryBlue.withOpacity(0.0),
                ],
              ),
            ),
            Positioned(
              bottom: -30.h,
              left: 40.w,
              child: _buildBubble(
                size: 110.r,
                colors: [
                  AppColors.primaryBlue.withOpacity(0.3),
                  AppColors.surfaceWhite.withOpacity(0.0),
                ],
              ),
            ),
            Positioned(
              top: 10.h,
              left: -15.w,
              child: _buildBubble(
                size: 50.r,
                colors: [
                  AppColors.surfaceWhite.withOpacity(0.25),
                  AppColors.cyanAccent.withOpacity(0.0),
                ],
              ),
            ),

            // ---------- المحتوى الرئيسي للكارد ----------
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkBlueBlack.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'خصم خاص 20%',
                            style: TextStyles.Size10
                                .withWeight(FontWeight.bold)
                                .withColor(AppColors.errorColor),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'عناية كاملة بسيارتك',
                          style: TextStyles.Size18
                              .withWeight(FontWeight.bold)
                              .withColor(AppColors.darkBlueBlack),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'احجز باقة الغسيل والتلميع الشامل الآن',
                          style: TextStyles.Size10.withColor(
                            AppColors.darkBlueBlack.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(width: 5.w),

                  // ==================== أيقونة محادثة المساعد الذكي ====================
                  const AiChatLauncherButton(),

                  SizedBox(width: 10.w),

                  // ==================== الصورة الدائرية المحسنة توهجياً ====================
                  Container(
                    width: 68.r,
                    height: 68.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // إطار وشفافية توهجية لتندمج الصورة مع ألوان البانر
                      border: Border.all(
                        color: AppColors.surfaceWhite.withOpacity(0.6),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkBlueBlack.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/logo3.png",
                        fit: BoxFit.cover,
                        // في حال حدث خطأ أثناء تحميل الصورة يظهر بديل أنيق
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.darkBlueBlack.withOpacity(0.1),
                            child: Icon(
                              Icons.verified_outlined,
                              color: AppColors.darkBlueBlack,
                              size: 32.r,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ودجت مساعدة لرسم فقاعة متدرجة بالألوان
  Widget _buildBubble({required double size, required List<Color> colors}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: colors,
          stops: const [0.3, 1.0],
        ),
      ),
    );
  }
}