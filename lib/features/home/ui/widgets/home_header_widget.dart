import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_state.dart';
import 'package:car_care_plus/features/notifications/ui/widgets/notification_bell_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_balance_cards.dart';

/// هيدر الصفحة الرئيسية: تحية باسم المستخدم، جرس الإشعارات، ومقبض القائمة
/// الجانبية (الصورة الرمزية) — وبطاقتا الرصيد أسفله في الوضع الطولي.
///
/// الهيدر ثابت خارج منطقة التمرير، لذلك يبقى ارتفاعه محسوباً بدقّة: في الوضع
/// العرضي تنتقل بطاقتا الرصيد إلى المحتوى القابل للتمرير ويبقى الهيدر سطراً
/// واحداً فقط.
class HomeHeaderWidget extends StatelessWidget {
  /// فتح القائمة الجانبية — الصورة الرمزية هي مقبض القائمة
  final VoidCallback? onMenuPressed;

  /// عرض بطاقتي الرصيد داخل الهيدر (الوضع الطولي فقط)
  final bool showBalanceCards;

  const HomeHeaderWidget({
    super.key,
    this.onMenuPressed,
    this.showBalanceCards = true,
  });

  @override
  Widget build(BuildContext context) {
    // أعلى الهيدر داكن، فنطلب أيقونات شريط حالة فاتحة
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: _buildHeader(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // التدرّج يمتد خلف شريط الحالة، بينما يبقى المحتوى داخل المنطقة الآمنة
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            12.h,
            20.w,
            showBalanceCards ? 18.h : 14.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderGreetingRow(onMenuPressed: onMenuPressed),
              if (showBalanceCards) ...[
                SizedBox(height: 16.h),
                const HomeBalanceCards(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderGreetingRow extends StatelessWidget {
  final VoidCallback? onMenuPressed;

  const _HeaderGreetingRow({required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AvatarMenuButton(onPressed: onMenuPressed),
        SizedBox(width: 12.w),
        Expanded(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final user = state is AuthSuccess ? state.user : null;
              final name = user?.name.trim();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'أهلاً بك 👋',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.Size10.withColor(AppColors.cyanAccent),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    (name != null && name.isNotEmpty)
                        ? name
                        : 'اختر خدمة سيارتك',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.Size18
                        .withWeight(FontWeight.bold)
                        .withColor(AppColors.surfaceWhite),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(width: 8.w),
        const NotificationBellButton(),
      ],
    );
  }
}

class _AvatarMenuButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _AvatarMenuButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = state is AuthSuccess ? state.user.name.trim() : '';
        final initial =
            name.isNotEmpty ? name.characters.first.toUpperCase() : null;

        return InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cyanAccent, width: 2),
            ),
            child: CircleAvatar(
              radius: 21.r,
              backgroundColor: AppColors.royalBlue,
              child: initial != null
                  ? Text(
                      initial,
                      style: TextStyles.Size18
                          .withColor(AppColors.surfaceWhite)
                          .withWeight(FontWeight.bold),
                    )
                  : Icon(
                      Icons.person_rounded,
                      color: AppColors.surfaceWhite,
                      size: 22.r,
                    ),
            ),
          ),
        );
      },
    );
  }
}
