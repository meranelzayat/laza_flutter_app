import 'package:flutter/material.dart';
import '../../features/auth/screens/auth_gate.dart';
import '../../features/auth/screens/signUp_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/products/screens/products_screen.dart';

class AppRoutes {
  static const root = '/';
  static const signup = '/signup';
  static const forgot = '/forgot';
  static const profile = '/profile';
  static const home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        root: (_) => const AuthGate(),
        signup: (_) => const SignupScreen(),
        forgot: (_) => const ForgotPasswordScreen(),
        profile: (_) => const ProfileScreen(),
        home: (_) => const ProductsScreen(),
      };
}
