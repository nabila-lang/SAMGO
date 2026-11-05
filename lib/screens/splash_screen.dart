import 'package:flutter/material.dart';
import 'login_screen.dart'; // Nanti diarahkan ke halaman login

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulasi jeda waktu 3 detik sebelum otomatis pindah ke Halaman Login
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Ikon Lingkungan SAMGO
            const Icon(
              Icons.eco,
              size: 80,
              color: Color(0xFF16834A), // Hijau utama SAMGO
            ),
            const SizedBox(height: 16),
            const Text(
              'SAMGO',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16834A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sampah dikelola, lingkungan terjaga.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
