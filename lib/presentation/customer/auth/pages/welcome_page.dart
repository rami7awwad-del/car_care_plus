import 'package:car_care_plus/app/app_language.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        final bool isArabic = locale.languageCode == 'ar';

        // تخلصنا من Directionality لأن MaterialApp في الـ main يقوم بالدور بناءً على الـ locale
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // اختيار اللغة
                    Align(
                      alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Locale>(
                            value: locale,
                            icon: const Icon(Icons.language),
                            items: const [
                              DropdownMenuItem(value: Locale('ar'), child: Text('العربية 🇸🇦')),
                              DropdownMenuItem(value: Locale('en'), child: Text('English 🇺🇸')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                appLocale.value = value;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    Image.asset(
                      'assets/images/logo4.png',
                      fit: BoxFit.contain,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, size: 100, color: Colors.grey); // حماية في حال عدم وجود الصورة
                      },
                    ),
                    const SizedBox(height: 50),
                    // العنوان
                    Text(
                      AppStrings.welcome,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                    ),
                    const SizedBox(height: 16),
                    // الوصف
                    Text(
                      AppStrings.welcomeDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280), height: 1.5),
                    ),
                    const SizedBox(height: 40),
                    // زر البدء
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF073D9E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          AppStrings.getStarted,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
