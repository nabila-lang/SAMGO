import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Berpindah otomatis ke halaman Login setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // Menerapkan standar font Poppins
        scaffoldBackgroundColor: const Color(0xFFFFFFFF), // Putih (Latar utama)
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Stack(
          children: [
            // 1. KONTEN TENGAH (Logo & Slogan sesuai standar ukuran & warna)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo SAMGO
                  Image.asset(
                    'images/Logo Samgo.jpg',
                    width: 165,
                    height: 165,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  
                  // Nama Aplikasi (Judul halaman 22 px, tebal, hijau utama #16834A)
                  const Text(
                    'SAMGO',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 89, 87),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Slogan (Isi teks 14 px, warna teks utama #252525)
                  const Text(
                    'Sampah dikelola, lingkungan terjaga.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ),

            // 2. GAMBAR ILUSTRASI DI BAWAH (Pemandangan lembut tanpa menutupi teks)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 200,
                child: Image.asset(
                  'images/Splashscreen.jpg',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}