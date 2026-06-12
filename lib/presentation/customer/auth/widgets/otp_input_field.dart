import 'package:flutter/material.dart';

class OtpInputField extends StatelessWidget {
  const OtpInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(decoration: InputDecoration(labelText: 'OTP'));
  }
}
