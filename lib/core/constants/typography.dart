// lib/core/constants/typography.dart

import 'package:flutter/material.dart';

class AppTypography {
  // Headlines
  static const headlineLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2, letterSpacing: -0.5);

  static const headlineMedium = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.3);

  static const headlineSmall = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4);

  // Body
  static const bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, height: 1.5);

  static const bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, height: 1.5);

  static const bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, height: 1.4);

  // Buttons & Labels
  static const buttonLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5);

  static const buttonSmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
}
