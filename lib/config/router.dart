import 'package:go_router/go_router.dart';

import '../presentation/customer/auth/pages/splash_page.dart';
import '../presentation/customer/auth/pages/welcome_page.dart';
import '../presentation/customer/auth/pages/login_page.dart';
import '../presentation/customer/auth/pages/register_page.dart';
import '../presentation/customer/auth/pages/otp_verification_page.dart';
import '../presentation/customer/home/home_page.dart';
import '../presentation/customer/roadside/pages/emergency_request_page.dart';
import '../presentation/customer/roadside/pages/emergency_tracking_page.dart';

/// مسارات التطبيق (go_router). الشاشة الأولى هي شاشة البداية (Splash).
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(
        path: '/otp',
        builder: (context, state) => OtpVerificationPage(phone: state.extra as String? ?? ''),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(path: '/roadside', builder: (context, state) => const EmergencyRequestPage()),
      GoRoute(path: '/roadside/tracking', builder: (context, state) => const EmergencyTrackingPage()),
    ],
  );
}
