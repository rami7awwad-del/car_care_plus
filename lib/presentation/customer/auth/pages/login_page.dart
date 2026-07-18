import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:car_care_plus/data/models/auth/user_model.dart';
import 'package:car_care_plus/app/app_language.dart';
import 'package:car_care_plus/presentation/common/widgets/theme_switcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // دالة بسيطة للتحقق من أن الحقول ليست فارغة
  String? _required(String? value) => (value == null || value.trim().isEmpty) ? AppStrings.allFieldsRequired : null;

  void _login() async {
    // 1. التحقق من صحة حقول الـ Form (الإيميل/الهاتف وكلمة المرور)
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // 2. رابط الـ API الخاص بالـ Login بناءً على الـ IP الخاص بك
    final url = Uri.parse('http://192.168.42.9:8000/api/auth/login');

    try {
      // 3. إرسال طلب الـ POST مع الإيميل والباسورد
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'email': _loginController.text.trim(), // 👈 تم استخدام _loginController هنا لإزالة الخطأ الأحمر
          'password': _passwordController.text,
        }),
      );

      // 4. تحليل الاستجابة القادمة
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 1) {
        // النجاح: تحويل البيانات القادمة إلى كائن مستخدم
        UserModel user = UserModel.fromJson(responseData['data']);

        // 💡 هنا نقوم بحفظ الـ user.token في الـ Secure Storage لاستخدامه لاحقاً

        if (!mounted) return;
        setState(() => _isLoading = false);

        // عرض رسالة النجاح من السيرفر: "Logged in successfully"
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(responseData['message'] ?? 'تم تسجيل الدخول بنجاح')));

        // 5. الانتقال إلى الصفحة الرئيسية للمشروع (Home)
        context.go('/home');
      } else {
        // الفشل: (خطأ في كلمة المرور أو الحساب غير موجود)
        if (!mounted) return;
        setState(() => _isLoading = false);

        String errorMessage = responseData['message'] ?? 'فشل تسجيل الدخول، تحقق من البيانات';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      // التعامل مع أخطاء الشبكة أو السيرفر مطفأ
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل الاتصال بالسيرفر: $e')));
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder لتحديث النصوص فوراً عند تغيير اللغة.
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.login),
            actions: const [ThemeSwitcher(color: Colors.white)],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, // 👈 إحاطة العناصر بـ Form وتمرير الـ key ليعمل الـ validation
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // 👈 تم تحويله إلى TextFormField ليدعم الـ validator
                    TextFormField(
                      controller: _loginController,
                      validator: _required,
                      decoration: InputDecoration(
                        labelText: AppStrings.emailOrPhone,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 👈 تم تحويله إلى TextFormField ليدعم الـ validator
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
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(onPressed: () {}, child: Text(AppStrings.forgotPassword)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              )
                            : Text(AppStrings.login),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(onPressed: () => context.push('/register'), child: Text(AppStrings.noAccount)),
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
