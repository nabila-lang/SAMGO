import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  static const Color _green = Color(0xFF16834A);
  static const Color _dark = Color(0xFF252525);

  // Serpihan confetti kecil
  Widget _confetti(Color color, double angle,
      {double? left, double? right, double? top, double? bottom, double w = 14}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: w,
          height: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _dark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Ilustrasi di dasar layar, melebar penuh
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: screenHeight * 0.38, // atur tinggi ilustrasi di sini
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'images/Splashscreen.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                // Pudar ke putih di bagian atas gambar
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 90,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Color(0x00FFFFFF)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Konten utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.14),

                  // Ikon centang + confetti
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            color: _green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 50),
                        ),
                        _confetti(const Color(0xFFF28C28), -0.6, left: 8, top: 36),
                        _confetti(const Color(0xFFF2C94C), 0.8, left: 30, top: 10, w: 9),
                        _confetti(const Color(0xFFB5546B), -0.9, right: 26, top: 8, w: 10),
                        _confetti(const Color(0xFF6FBF4A), -0.5, right: 2, top: 44),
                        _confetti(const Color(0xFFF28C28), 0.7, right: 10, bottom: 30),
                        _confetti(const Color(0xFF6FBF4A), 0.6, left: 2, bottom: 40),
                        _confetti(const Color(0xFFF2C94C), -0.3, left: 36, bottom: 10, w: 9),
                        _confetti(const Color(0xFF3BA7A0), 0.9, right: 44, bottom: 6, w: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Permintaan Berhasil!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Permintaan penjemputan sampah\nberhasil dikirim.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, '/history');
                      },
                      child: const Text(
                        'Lihat Riwayat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}