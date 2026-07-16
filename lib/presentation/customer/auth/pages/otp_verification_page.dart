import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:car_care_plus/app/app_language.dart';
import 'package:car_care_plus/core/constants/app_colors.dart';
import 'package:car_care_plus/core/constants/spacing.dart';
import 'package:car_care_plus/presentation/common/widgets/theme_switcher.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phone;

  const OtpVerificationPage({super.key, required this.phone});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.invalidOtp)));
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // محاكاة التحقق من الرمز
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.otpVerified)));
    context.go('/home');
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.otpSentTo(widget.phone))));
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        final theme = Theme.of(context);

        final defaultPinTheme = PinTheme(
          width: 52,
          height: 56,
          textStyle: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(Spacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.otpVerification),
            actions: const [ThemeSwitcher(color: Colors.white)],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.otpSentTo(widget.phone),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  Directionality(
                    // أرقام الـ OTP دائماً من اليسار لليمين
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: _otpController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onCompleted: (_) => _verifyOtp(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                          : Text(AppStrings.verify),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _isLoading ? null : _resendCode,
                    child: Text(AppStrings.resendCode, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
