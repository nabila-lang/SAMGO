import 'package:flutter/material.dart';

import 'samgo_page.dart';

/// Halaman Tentang SAMGO.
/// Taruh di: lib/screens/about_samgo_screen.dart
class AboutSamgoScreen extends StatelessWidget {
  const AboutSamgoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SamgoPage(
      title: 'Tentang SAMGO',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            // Logo SAMGO (gambar asli dari folder images)
            Image.asset(
              SamgoAssets.logo,
              height: 90,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Text(
                'SAMGO',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: SamgoColors.darkGreen,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sampah dikelola, lingkungan terjaga.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: SamgoColors.darkGreen,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'SAMGO adalah aplikasi layanan penjemputan sampah daur ulang berbasis kepedulian sosial, yang bertujuan untuk menjaga kebersihan lingkungan dan mendukung gaya hidup berkelanjutan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                height: 1.5,
                color: SamgoColors.textDark,
              ),
            ),
            const SizedBox(height: 20),
            _buildBanner(),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fitur Utama',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: SamgoColors.darkGreen,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  child: _FeatureItem(
                      icon: Icons.recycling, label: 'Jemput\nSampah'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _FeatureItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Pantau\nStatus'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _FeatureItem(
                      icon: Icons.eco, label: 'Dukung\nLingkungan'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _FeatureItem(
                      icon: Icons.favorite, label: 'Peduli\nBersama'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: SamgoColors.lightGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Versi 1.0.0',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: SamgoColors.darkGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SamgoColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Gambar bumi asli dari folder images
          Image.asset(
            SamgoAssets.bumi,
            width: 90,
            height: 90,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.public, size: 80, color: SamgoColors.green),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bersama SAMGO',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SamgoColors.darkGreen,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'kita wujudkan lingkungan yang lebih baik!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: SamgoColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: samgoCardDecoration(radius: 16),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: SamgoColors.lightGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: SamgoColors.green, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              height: 1.2,
              color: SamgoColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
