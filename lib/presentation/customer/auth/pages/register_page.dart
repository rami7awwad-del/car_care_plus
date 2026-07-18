import 'package:car_care_plus/data/models/auth/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:car_care_plus/app/app_language.dart';
import 'package:car_care_plus/presentation/common/widgets/theme_switcher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String? _required(String? value) => (value == null || value.trim().isEmpty) ? AppStrings.allFieldsRequired : null;

  void _register() async {
    // 1. التحقق من صحة المدخلات في الواجهة
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // 2. تحديد رابط الـ API (استبدل 10.0.2.2 بـ IP جهازك إذا كنت تستخدم هاتفاً حقيقياً)
    final url = Uri.parse('http://192.168.42.9:8000/api/auth/register/customer'); //  تأكد من وجود api واحدة فقط

    try {
      // 3. إرسال طلب الـ POST مع البيانات المطلوبة
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController.text, // التسمية الافتراضية في لارافل
        }),
      );

      // 4. تحليل الاستجابة القادمة من السيرفر
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['status'] == 1) {
        // النجاح: تحويل البيانات إلى Model
        UserModel user = UserModel.fromJson(responseData['data']);

        // 💡 هنا يمكنك حفظ الـ user.token في الـ Secure Storage لاحقاً لحماية الطلبات القادمة

        if (!mounted) return;
        setState(() => _isLoading = false);

        // عرض رسالة النجاح القادمة من السيرفر مباشرة
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(responseData['message'] ?? AppStrings.registerSuccess)));

        // الانتقال لصفحة الـ OTP وتمرير الرقم
        context.push('/otp', extra: _phoneController.text.trim());
      } else {
        // الفشل: السيرفر أرجع خطأ (مثل الإيميل مستخدم سابقاً)
        if (!mounted) return;
        setState(() => _isLoading = false);

        String errorMessage = responseData['message'] ?? 'حدث خطأ ما، يرجى المحاولة لاحقاً';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      // التعامل مع أخطاء الشبكة (مثلاً السيرفر مطفأ أو الـ IP غير صحيح)
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل الاتصال بالسيرفر: $e')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.createAccount),
            actions: const [ThemeSwitcher(color: Colors.white)],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      validator: _required,
                      decoration: InputDecoration(
                        labelText: AppStrings.fullName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _required,
                      decoration: InputDecoration(
                        labelText: AppStrings.email,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: _required,
                      decoration: InputDecoration(
                        labelText: AppStrings.phone,
                        prefixIcon: const Icon(Icons.phone_android_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: _required,
                      decoration: InputDecoration(
                        labelText: AppStrings.password,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return AppStrings.allFieldsRequired;
                        if (value != _passwordController.text) return AppStrings.passwordsNotMatch;
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: AppStrings.confirmPassword,
                        prefixIcon: const Icon(Icons.lock_clock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              )
                            : Text(AppStrings.createAccount),
                      ),
                    ),
                    const SizedBox(height: 20),
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
