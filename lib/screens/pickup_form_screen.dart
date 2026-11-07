import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color _hijau = Color(0xFF16834A);
const Color _abuMuda = Color(0xFFF3F5F3);
const Color _teks = Color(0xFF252525);

class PickupFormScreen extends StatefulWidget {
  const PickupFormScreen({super.key});

  @override
  State<PickupFormScreen> createState() => _PickupFormScreenState();
}

class _PickupFormScreenState extends State<PickupFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _beratController = TextEditingController();
  final _alamatController = TextEditingController();
  final _catatanController = TextEditingController();
  final _picker = ImagePicker();

  final List<String> _jenisSampah = [
    'Plastik',
    'Kertas',
    'Kardus',
    'Minyak Jelantah',
  ];
  String _jenisTerpilih = 'Plastik';
  Uint8List? _fotoBytes;
  String? _namaFoto;

  @override
  void dispose() {
    _beratController.dispose();
    _alamatController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _snack(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<void> _ambilFoto(ImageSource sumber) async {
    try {
      final hasil = await _picker.pickImage(source: sumber, imageQuality: 70);
      if (hasil == null) return;
      final bytes = await hasil.readAsBytes();
      setState(() {
        _fotoBytes = bytes;
        _namaFoto = hasil.name;
      });
    } catch (e) {
      _snack('Gagal mengambil foto: $e');
    }
  }

  void _pilihSumberFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: _hijau),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _ambilFoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: _hijau),
              title: const Text('Galeri / File'),
              onTap: () {
                Navigator.pop(context);
                _ambilFoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _kirimRequest() {
    if (!_formKey.currentState!.validate()) return;

    // TODO (integrasi): simpan data ke backend/database di sini.
    // jenis: _jenisTerpilih | berat: _beratController.text
    // alamat: _alamatController.text | catatan: _catatanController.text
    // foto: _fotoBytes

    Navigator.pushReplacementNamed(context, '/confirmation');
  }

  InputDecoration _dekorasi({String? hint, Widget? prefix}) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixIcon: prefix,
      filled: true,
      fillColor: _abuMuda,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: border(const Color(0xFFE0E5E0)),
      focusedBorder: border(_hijau, 1.5),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red, 1.5),
    );
  }

  Widget _label(String teks) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(
      teks,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: _teks,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    const gayaIsi = TextStyle(fontSize: 14, color: _teks);
    final adaFoto = _fotoBytes != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _teks, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Form Penjemputan',
          style: TextStyle(
            color: _teks,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Jenis Sampah'),
                DropdownButtonFormField<String>(
                  value: _jenisTerpilih,
                  style: gayaIsi,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  decoration: _dekorasi(
                    prefix: const Icon(Icons.recycling, color: _hijau),
                  ),
                  items: _jenisSampah
                      .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                      .toList(),
                  onChanged: (v) => setState(() => _jenisTerpilih = v!),
                ),

                _label('Estimasi Berat (kg)'),
                TextFormField(
                  controller: _beratController,
                  style: gayaIsi,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _dekorasi(hint: 'Contoh: 3'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Berat wajib diisi';
                    }
                    final angka = double.tryParse(v.replaceAll(',', '.'));
                    if (angka == null || angka <= 0) {
                      return 'Masukkan berat yang valid';
                    }
                    return null;
                  },
                ),

                _label('Alamat Penjemputan'),
                TextFormField(
                  controller: _alamatController,
                  style: gayaIsi,
                  decoration: _dekorasi(
                    hint: 'Masukkan alamat penjemputan',
                    prefix: const Icon(Icons.location_on, color: _hijau),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Alamat wajib diisi'
                      : null,
                ),

                _label('Catatan (Opsional)'),
                TextFormField(
                  controller: _catatanController,
                  style: gayaIsi,
                  maxLines: 2,
                  decoration: _dekorasi(
                    hint: 'Contoh: Plastik sudah dibersihkan',
                  ),
                ),

                _label('Foto Sampah (Opsional)'),
                InkWell(
                  onTap: _pilihSumberFoto,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _abuMuda,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E5E0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              adaFoto ? Icons.check_circle : Icons.photo_camera,
                              color: adaFoto ? _hijau : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                adaFoto
                                    ? _namaFoto ?? 'Foto dipilih'
                                    : 'Tambah Foto',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: adaFoto ? _hijau : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (adaFoto) ...[
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _fotoBytes!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (adaFoto)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setState(() {
                        _fotoBytes = null;
                        _namaFoto = null;
                      }),
                      child: const Text(
                        'Hapus foto',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _kirimRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hijau,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kirim Request',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
