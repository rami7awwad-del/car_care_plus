import 'package:go_router/go_router.dart';

import '../presentation/customer/auth/pages/login_page.dart';
import '../presentation/customer/auth/pages/register_page.dart';
import '../presentation/customer/auth/pages/welcome_page.dart';
import '../presentation/customer/home/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
  );
}
