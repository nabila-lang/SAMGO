import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

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
      // Menetapkan halaman awal saat aplikasi dibuka
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        // Tambahkan rute '/home' di sini nanti jika halaman utama sudah dibuat oleh temanmu
      },
    );
  }
}