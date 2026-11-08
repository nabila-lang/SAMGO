import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'change_email_screen.dart';
import 'change_password_screen.dart';
import 'change_phone_screen.dart';
import 'samgo_page.dart';
import 'webcam.dart'; // WebcamPage buatan temanmu (sesuaikan path kalau beda folder)

/// Halaman Informasi Akun.
/// Taruh di: lib/screens/account_info_screen.dart
class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  Uint8List? _fotoProfil; // null = pakai avatar default

  // Data dummy, nanti ganti dengan data user asli dari backend
  final String _nama = 'Andi Pratama';
  final String _email = 'andi@email.com';
  final String _noHp = '0812 3456 7890';

  /// Bottom sheet pilihan: kamera atau galeri
  Future<void> _pilihSumberFoto() async {
    final pilihan = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ubah Foto Profil',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: SamgoColors.darkGreen,
                ),
              ),
              const SizedBox(height: 12),
              _SumberTile(
                icon: Icons.camera_alt,
                title: 'Ambil dari Kamera',
                onTap: () => Navigator.pop(ctx, 'kamera'),
              ),
              _SumberTile(
                icon: Icons.photo_library,
                title: 'Pilih dari Galeri',
                onTap: () => Navigator.pop(ctx, 'galeri'),
              ),
            ],
          ),
        ),
      ),
    );

    if (pilihan == null) return;

    XFile? hasil;
    if (pilihan == 'kamera') {
      hasil = await Navigator.push<XFile>(
        context,
        MaterialPageRoute(builder: (_) => const WebcamPage()),
      );
    } else {
      hasil = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
    }

    if (hasil == null) return;
    final bytes = await hasil.readAsBytes();
    if (!mounted) return;
    setState(() => _fotoProfil = bytes);

    // TODO: upload `hasil` ke backend supaya foto tersimpan permanen
  }

  @override
  Widget build(BuildContext context) {
    return SamgoPage(
      title: 'Informasi Akun',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 16),
            _MenuItem(
              icon: Icons.email,
              title: 'Ubah Email',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangeEmailScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.call,
              title: 'Ubah Nomor HP',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePhoneScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.lock,
              title: 'Ubah Password',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: samgoCardDecoration(radius: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pilihSumberFoto,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: SamgoColors.lightGreen,
                  backgroundImage:
                      _fotoProfil != null ? MemoryImage(_fotoProfil!) : null,
                  child: _fotoProfil == null
                      ? const Icon(Icons.person,
                          size: 52, color: SamgoColors.green)
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: SamgoColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nama,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: SamgoColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: SamgoColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.call,
                        size: 15, color: SamgoColors.textGrey),
                    const SizedBox(width: 6),
                    Text(
                      _noHp,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: SamgoColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SumberTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SumberTile(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: SamgoColors.lightGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: SamgoColors.green),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 15,
          color: SamgoColors.textDark,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 1.5,
        shadowColor: const Color(0x2216834A),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: SamgoColors.green, size: 26),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: SamgoColors.textDark,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: SamgoColors.textDark, size: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
