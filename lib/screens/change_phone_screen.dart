import 'package:flutter/material.dart';

import 'samgo_page.dart';

/// Halaman Ubah Nomor HP.
/// Taruh di: lib/screens/change_phone_screen.dart
class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noBaru = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _noBaru.dispose();
    _password.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: kirim _noBaru.text & _password.text ke backend

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nomor HP berhasil diubah')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SamgoPage(
      title: 'Ubah Nomor HP',
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
                  'Nomor HP saat ini',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: SamgoColors.textGrey),
                ),
                const Text(
                  '0812 3456 7890', // TODO: ganti dengan nomor user asli
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: SamgoColors.textDark,
                  ),
                ),
                const SizedBox(height: 20),
                SamgoTextField(
                  label: 'Nomor HP Baru',
                  hint: 'Contoh: 081234567890',
                  icon: Icons.call,
                  controller: _noBaru,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Nomor HP tidak boleh kosong';
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Hanya boleh angka';
                    }
                    if (value.length < 10 || value.length > 14) {
                      return 'Nomor HP harus 10–14 digit';
                    }
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
