import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Menghubungkan ke file buatan Teman 1

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16834A)), // Hijau utama SAMGO
        useMaterial3: true,
      ),
      // Halaman pertama yang dibuka aplikasi sesuai storyboard halaman 1
      home: const SplashScreen(), 
    );
  }
}