import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
 

  // حجم 1: كبير جداً (Display) - 32px
  static TextStyle Size32 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  // حجم 2: كبير (Heading) - 28px
  static TextStyle Size28 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  // حجم 3: متوسط (Body) - 24px
  static TextStyle Size24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // حجم 4: صغير (Caption) - 18px
  static TextStyle Size18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // حجم 5: صغير جداً (Small) - 15px
  static TextStyle Size15 = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // ==================== ستايلات خاصة (للنصوص الصغيرة جداً) ====================

  // حجم 6: 10px
  static TextStyle Size10 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
}

// ==================== Extension لتسهيل التخصيص ====================

extension TextStyleHelper on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size.sp);
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);
  TextStyle withLetterSpacing(double spacing) => copyWith(letterSpacing: spacing);
  TextStyle withHeight(double height) => copyWith(height: height);
  TextStyle withDecoration(TextDecoration decoration) => copyWith(decoration: decoration);
  TextStyle withBackground(Color color) => copyWith(backgroundColor: color);
  TextStyle withShadows(List<Shadow> shadows) => copyWith(shadows: shadows);
}
