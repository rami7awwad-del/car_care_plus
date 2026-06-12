import 'package:flutter/material.dart';

import 'package:car_care_plus/app/app_language.dart';

// مهم جداً
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
    // التحقق من طول الرمز المدخل
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.invalidOtp)));
      return;
    }

    setState(() => _isLoading = true);

    // محاكاة التحقق من الرمز عبر السيرفر
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.otpVerified)));

    // يمكنك هنا التوجيه إلى الصفحة الرئيسية للتطبيق بعد نجاح التحقق
  }

  void _resendCode() {
    // هنا تضع منطق إعادة إرسال الرمز عبر الـ API
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
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: const Color(0xFF073D9E),
            foregroundColor: Colors.white,
            title: Text(AppStrings.otpVerification, style: const TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // نص إرسال الرمز الذي يستقبل رقم الهاتف ديناميكياً
                  Text(
                    AppStrings.otpSentTo(widget.phone),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280), height: 1.5),
                  ),

                  const SizedBox(height: 40),

                  // حقل إدخال الرمز
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: const TextStyle(
                      letterSpacing: 8,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ), // لتنسيق الأرقام بشكل متباعد ومريح
                    textAlign: TextAlign.center, // توسيط الرمز داخل الحقل
                    decoration: InputDecoration(
                      labelText: AppStrings.otpVerification,
                      counterText: "", // لإخفاء عداد الحروف الافتراضي تحت الحقل لشكل أرتب
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // زر التحقق
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color(0xFF0368E9);
                          }
                          return const Color(0xFF073D9E);
                        }),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      onPressed: _isLoading ? null : _verifyOtp,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              AppStrings.verify,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // زر إعادة إرسال الرمز
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
