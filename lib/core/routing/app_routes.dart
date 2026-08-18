import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/features/auth/presentation/forgotPasswordPage.dart';
import 'package:car_care_plus/features/auth/presentation/login_page.dart';
import 'package:car_care_plus/features/auth/presentation/pending_approval_page.dart';
import 'package:car_care_plus/features/auth/presentation/register_page.dart';
import 'package:car_care_plus/features/auth/presentation/resetPasswordPage.dart';
import 'package:car_care_plus/features/auth/presentation/welcome_page.dart';
import 'package:car_care_plus/features/cars/data/models/car_model.dart';
import 'package:car_care_plus/features/cars/ui/views/edit_car_page.dart';
import 'package:car_care_plus/features/main_layout/company_main_layout.dart'; // 👈 استيراد واجهة الشركات الجديدة
import 'package:car_care_plus/features/branches/ui/views/branches_view.dart';
import 'package:car_care_plus/features/main_layout/main_layout.dart';
import 'package:car_care_plus/features/notifications/ui/views/notifications_view.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/repos/wallet_payment_repo.dart';
import 'package:car_care_plus/features/wallet_and_payments/ui/screens/payment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';
  static const String welcome = '/welcome';
  static const String mainLayout = '/main';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String editCar = '/editCar';
  static const String paymentDetails = '/paymentDetails';
  static const String pendingApproval = '/pendingApproval';
  static const String companyMainLayout = '/companyMainLayout'; // 👈 مسار واجهة الشركات
  static const String notifications = '/notifications'; // 👈 مسار شاشة الإشعارات
  static const String branches = '/branches'; // 👈 مسار شاشة الفروع
}

class AppRouter {
  final Function(Locale)? onLanguageChanged;

  AppRouter({this.onLanguageChanged});

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case Routes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());

      case Routes.mainLayout:
        return MaterialPageRoute(builder: (_) => const MainLayout());

      // 🆕 مسار واجهة التنقل الخاصة بالشركات
      case Routes.companyMainLayout:
        return MaterialPageRoute(builder: (_) => const CompanyMainLayout());

      // 🆕 مسار طلب الـ OTP
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

      // 🆕 مسار تعيين كلمة المرور
      case Routes.resetPassword:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ResetPasswordPage(email: email),
        );

      // 🆕 مسار تعديل السيارة
      case Routes.editCar:
        final car = settings.arguments as CarModel;
        return MaterialPageRoute(
          builder: (_) => EditCarPage(car: car),
        );

      // 🆕 مسار تفاصيل الدفع
      // case Routes.paymentDetails:
      //   final paymentId = settings.arguments as int;
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       final apiService = context.read<ApiService>();
      //       return PaymentDetailsScreen(
      //         paymentId: paymentId,
      //         repo: WalletPaymentRepo(apiService),
      //       );
      //     },
      //   );

      // 🆕 مسار شاشة الفروع
      case Routes.branches:
        return MaterialPageRoute(builder: (_) => const BranchesView());

      // 🆕 مسار شاشة الإشعارات
      // NotificationsCubit مُوفَّر فوق الـ MaterialApp لذا الشاشة تصل إليه مباشرة
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsView(),
        );

      // 🆕 مسار شاشة انتظار موافقة الشركة
      case Routes.pendingApproval:
        return MaterialPageRoute(
          builder: (_) => const PendingApprovalPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('لا يوجد مسار معرف لـ ${settings.name}')),
          ),
        );
    }
  }
}