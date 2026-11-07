import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pickup_form_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/history_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const SAMGOApp());
}

class SAMGOApp extends StatelessWidget {
  const SAMGOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAMGO',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/pickup': (context) => const PickupFormScreen(),
        '/confirmation': (context) => const ConfirmationScreen(),
        '/history': (context) => const HistoryScreen(),
        '/detail': (context) => const DetailScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
