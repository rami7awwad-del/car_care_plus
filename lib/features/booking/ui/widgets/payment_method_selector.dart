import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;
  final int pointsBalance;
  final bool hasActivePackage;
  final String? activePackageName;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
    this.pointsBalance = 0,
    this.hasActivePackage = false,
    this.activePackageName,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> methods = [
      {'id': 'cash', 'title': 'نقداً', 'subtitle': null, 'icon': Icons.payments_outlined, 'isSoon': false},
      {'id': 'wallet', 'title': 'المحفظة', 'subtitle': null, 'icon': Icons.account_balance_wallet_outlined, 'isSoon': false},
      {'id': 'point', 'title': 'النقاط', 'subtitle': '$pointsBalance نقطة', 'icon': Icons.stars_rounded, 'isSoon': false},
      if (hasActivePackage)
        {
          'id': 'package',
          'title': 'الباقة',
          'subtitle': activePackageName ?? 'مفعلة',
          'icon': Icons.card_membership_rounded,
          'isSoon': false,
        },
      {
        'id': 'electronic_card',
        'title': 'بطاقة إلكترونية',
        'subtitle': 'الدفع المباشر',
        'icon': Icons.credit_card_rounded,
        'isSoon': true, // 👈 شارة قريباً
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طريقة الدفع',
          style: TextStyles.Size18.withWeight(FontWeight.bold).withColor(AppColors.darkBlueBlack),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.1,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
          ),
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final method = methods[index];
            final isSelected = selectedMethod == method['id'];
            final bool isSoon = method['isSoon'] ?? false;

            return GestureDetector(
              onTap: () {
                if (isSoon) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'دفع البطاقة الإلكترونية سيكون متاحاً قريباً في التحديث القادم!',
                        style: TextStyles.Size15.withColor(Colors.white),
                      ),
                      backgroundColor: AppColors.primaryBlue,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  onMethodChanged(method['id']);
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryBlue : AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryBlue : AppColors.borderGrey,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadowColor,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          method['icon'],
                          color: isSoon
                              ? AppColors.coolGrey.withOpacity(0.6)
                              : (isSelected ? Colors.white : AppColors.coolGrey),
                          size: 24.r,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method['title'],
                                style: TextStyles.Size15.withWeight(FontWeight.bold).withColor(
                                  isSoon
                                      ? AppColors.coolGrey
                                      : (isSelected ? Colors.white : AppColors.darkBlueBlack),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (method['subtitle'] != null) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  method['subtitle'],
                                  style: TextStyles.Size10.withColor(
                                    isSelected ? Colors.white70 : AppColors.coolGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSoon)
                    Positioned(
                      top: -6.h,
                      left: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'قريباً',
                          style: TextStyles.Size10.withWeight(FontWeight.bold).withColor(Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}