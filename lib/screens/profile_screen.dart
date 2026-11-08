import 'package:flutter/material.dart';
import 'account_info_screen.dart';
import 'about_samgo_screen.dart';

const Color _hijau = Color(0xFF16834A);
const Color _hijauMuda = Color(0xFFDDF3E3);
const Color _abuMuda = Color(0xFFF3F5F3);
const Color _teks = Color(0xFF252525);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Data contoh (sesuai storyboard). Ganti dengan data akun asli saat integrasi.
  static const String _nama = 'Andi Pratama';
  static const String _email = 'andi@email.com';

  void _tampilInfo(BuildContext context, String judul, String isi) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          judul,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(isi, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: _hijau)),
          ),
        ],
      ),
    );
  }

  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Keluar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Yakin ingin keluar dari aplikasi?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _menu(IconData ikon, String teks, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(ikon, color: _hijau),
      title: Text(teks, style: const TextStyle(fontSize: 14, color: _teks)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: _teks,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Foto profil
            const CircleAvatar(
              radius: 48,
              backgroundColor: _hijauMuda,
              child: Icon(Icons.person, size: 56, color: _hijau),
            ),
            const SizedBox(height: 12),
            const Text(
              _nama,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _teks,
              ),
            ),
            const Text(
              _email,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

// Menu
Container(
  decoration: BoxDecoration(
    color: _abuMuda,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    children: [
      // 1. Ubah menu Informasi Akun agar pindah ke halaman baru
      _menu(
        Icons.person_outline,
        'Informasi Akun',
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountInfoScreen(),
            ),
          );
        },
      ),
      const Divider(height: 1, indent: 16, endIndent: 16),
      
      // 2. Ubah menu Tentang SAMGO agar pindah ke halaman baru
      _menu(
        Icons.info_outline,
        'Tentang SAMGO',
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AboutSamgoScreen(),
            ),
          );
        },
      ),
    ],
  ),
),
            // Logout
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => _konfirmasiLogout(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: _hijau,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/history');
          }
        },
      ),
    );
  }
}
