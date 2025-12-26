import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/auth/screens/auth_gate.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/onboarding/screens/get_started_screen.dart';
import 'theme/app_theme_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LazaApp());
}

class LazaApp extends StatelessWidget {
  const LazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // ✅ أول شاشة
          // خلي AuthGate هو اللي يقرر: Login ولا Home
          initialRoute: '/auth',

          // ✅ Dark/Light mode
          themeMode: mode,
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF8F7CFF)),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8F7CFF),
              brightness: Brightness.dark,
            ),
          ),

          // ✅ Routes
          routes: {
            '/get-started': (_) => const GetStartedScreen(),
            '/login': (_) => const LoginScreen(),
            '/auth': (_) => const AuthGate(),
          },
        );
      },
    );
  }
}
