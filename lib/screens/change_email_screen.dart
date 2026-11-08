import 'package:flutter/material.dart';

import 'samgo_page.dart';

/// Halaman Ubah Email.
/// Taruh di: lib/screens/change_email_screen.dart
class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailBaru = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _emailBaru.dispose();
    _password.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: kirim _emailBaru.text & _password.text ke backend

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email berhasil diubah')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SamgoPage(
      title: 'Ubah Email',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: samgoCardDecoration(radius: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email saat ini',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: SamgoColors.textGrey),
                ),
                const Text(
                  'andi@email.com', // TODO: ganti dengan email user asli
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: SamgoColors.textDark,
                  ),
                ),
                const SizedBox(height: 20),
                SamgoTextField(
                  label: 'Email Baru',
                  hint: 'Masukkan email baru',
                  icon: Icons.email,
                  controller: _emailBaru,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Email tidak boleh kosong';
                    final valid =
                        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
                    if (!valid) return 'Format email tidak valid';
                    return null;
                  },
                ),
                SamgoTextField(
                  label: 'Password',
                  hint: 'Masukkan password untuk konfirmasi',
                  icon: Icons.lock,
                  controller: _password,
                  isPassword: true,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Password tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 8),
                SamgoButton(text: 'Simpan', onPressed: _simpan),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
