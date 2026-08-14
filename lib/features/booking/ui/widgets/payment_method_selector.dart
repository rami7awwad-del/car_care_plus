import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> methods = [
      {'id': 'cash', 'title': 'نقداً', 'icon': Icons.payments_outlined},
      {'id': 'card', 'title': 'بطاقة إلكترونية', 'icon': Icons.credit_card_rounded},
      {'id': 'wallet', 'title': 'المحفظة', 'icon': Icons.account_balance_wallet_outlined},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طريقة الدفع',
          style: TextStyles.Size18.withWeight(FontWeight.bold).withColor(AppColors.darkBlueBlack),
        ),
        SizedBox(height: 12.h),
        Row(
          children: methods.map((method) {
            final isSelected = selectedMethod == method['id'];
            return Expanded(
              child: GestureDetector(
                onTap: () => onMethodChanged(method['id']),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
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
                  child: Column(
                    children: [
                      Icon(
                        method['icon'],
                        color: isSelected ? Colors.white : AppColors.coolGrey,
                        size: 24.r,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        method['title'],
                        style: TextStyles.Size10.withWeight(FontWeight.bold).withColor(
                          isSelected ? Colors.white : AppColors.darkBlueBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}