import 'dart:typed_data';

import 'package:flutter/material.dart';

const Color _hijau = Color(0xFF16834A);
const Color _hijauMuda = Color(0xFFDDF3E3);
const Color _teks = Color(0xFF252525);
const Color _teksSamar = Color(0xB3252525);

class DetailScreen extends StatelessWidget {
  final String nomor;
  final String jenisSampah;
  final String estimasiBerat;
  final String alamat;
  final String tanggal;
  final String status; // 'Menunggu' | 'Diproses' | 'Selesai'
  final String? catatan;
  final Uint8List? fotoBytes; // foto dari form (opsional)

  /// Semua parameter punya nilai default (data contoh dari storyboard),
  /// jadi halaman ini bisa dibuka tanpa data: DetailScreen()
  const DetailScreen({
    super.key,
    this.nomor = '#001',
    this.jenisSampah = 'Plastik',
    this.estimasiBerat = '3 kg',
    this.alamat = 'Jl. Merdeka No. 10',
    this.tanggal = '5 Nov 2026',
    this.status = 'Menunggu',
    this.catatan = 'Plastik sudah dibersihkan',
    this.fotoBytes,
  });

  Color get _warnaStatus {
    switch (status) {
      case 'Diproses':
        return const Color(0xFF1E88E5);
      case 'Selesai':
        return _hijau;
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Color get _latarStatus {
    switch (status) {
      case 'Diproses':
        return const Color(0xFFE3F2FD);
      case 'Selesai':
        return _hijauMuda;
      default:
        return const Color(0xFFFFF1D6);
    }
  }

  Widget _baris(IconData ikon, String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: _hijau, size: 20),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: _teksSamar),
            ),
          ),
          Expanded(
            child: Text(
              ': $nilai',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _teks,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Detail Penjemputan',
          style: TextStyle(
            color: _teks,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto sampah
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  height: 170,
                  child: fotoBytes != null
                      ? Image.memory(fotoBytes!, fit: BoxFit.cover)
                      : Container(
                          color: _hijauMuda,
                          child: const Icon(
                            Icons.recycling,
                            size: 64,
                            color: _hijau,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Nomor + status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nomor,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _teks,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _latarStatus,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _warnaStatus,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Informasi pengajuan
              _baris(Icons.recycling, 'Jenis Sampah', jenisSampah),
              _baris(Icons.scale, 'Estimasi Berat', estimasiBerat),
              _baris(Icons.location_on, 'Alamat', alamat),
              _baris(Icons.calendar_today, 'Tanggal', tanggal),
              const SizedBox(height: 12),

              // Catatan
              if (catatan != null && catatan!.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Catatan:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _teks,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        catatan!,
                        style: const TextStyle(fontSize: 12, color: _teks),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Tombol kembali
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _hijau,
                    side: const BorderSide(color: _hijau, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
