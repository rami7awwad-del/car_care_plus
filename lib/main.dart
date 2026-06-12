import 'package:car_care_plus/presentation/customer/auth/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'app/app_strings.dart'; // مهم جداً

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        return MaterialApp(
          title: 'Login UI',
          debugShowCheckedModeBanner: false,

          // 👇 هذا أهم سطر
          locale: locale,

          theme: ThemeData(primarySwatch: Colors.indigo, scaffoldBackgroundColor: const Color(0xFFF5F7FA)),

          home: const WelcomePage(),
        );
      },
    );
  }
}
