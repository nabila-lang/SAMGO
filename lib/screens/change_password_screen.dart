import 'package:flutter/material.dart';

import 'samgo_page.dart';

/// Halaman Ubah Password.
/// Taruh di: lib/screens/change_password_screen.dart
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lama = TextEditingController();
  final _baru = TextEditingController();
  final _konfirmasi = TextEditingController();

  @override
  void dispose() {
    _lama.dispose();
    _baru.dispose();
    _konfirmasi.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: kirim _lama.text & _baru.text ke backend

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password berhasil diubah')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SamgoPage(
      title: 'Ubah Password',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: samgoCardDecoration(radius: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SamgoTextField(
                  label: 'Password Lama',
                  hint: 'Masukkan password lama',
                  icon: Icons.lock_outline,
                  controller: _lama,
                  isPassword: true,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Password lama tidak boleh kosong'
                      : null,
                ),
                SamgoTextField(
                  label: 'Password Baru',
                  hint: 'Minimal 8 karakter',
                  icon: Icons.lock,
                  controller: _baru,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password baru tidak boleh kosong';
                    }
                    if (v.length < 8) return 'Minimal 8 karakter';
                    if (v == _lama.text) {
                      return 'Password baru harus berbeda dari yang lama';
                    }
                    return null;
                  },
                ),
                SamgoTextField(
                  label: 'Konfirmasi Password Baru',
                  hint: 'Ulangi password baru',
                  icon: Icons.lock,
                  controller: _konfirmasi,
                  isPassword: true,
                  validator: (v) =>
                      v != _baru.text ? 'Konfirmasi password tidak sama' : null,
                ),
                const SizedBox(height: 8),
                SamgoButton(text: 'Simpan Password', onPressed: _simpan),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
