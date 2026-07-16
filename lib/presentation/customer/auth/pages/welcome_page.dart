import 'package:car_care_plus/app/app_language.dart';
import 'package:car_care_plus/presentation/common/widgets/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        final theme = Theme.of(context);

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // صف علوي: اختيار اللغة + تبديل الثيم
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.dividerColor),
                            borderRadius: BorderRadius.circular(12),
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
                                if (value != null) appLocale.value = value;
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        const ThemeSwitcher(),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Image.asset(
                      'assets/images/logo4.png',
                      fit: BoxFit.contain,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, size: 100, color: Colors.grey);
                      },
                    ),
                    const SizedBox(height: 50),
                    Text(
                      AppStrings.welcome,
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.welcomeDescription,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor, height: 1.5),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () => context.push('/login'),
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
