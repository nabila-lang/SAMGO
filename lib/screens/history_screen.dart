import 'package:flutter/material.dart';

import 'detail_screen.dart';

const Color _hijau = Color(0xFF16834A);
const Color _hijauMuda = Color(0xFFDDF3E3);
const Color _teks = Color(0xFF252525);

class _Pengajuan {
  final String nomor;
  final String jenis;
  final String berat;
  final String alamat;
  final String tanggal;
  final String status; // Menunggu | Diproses | Selesai
  final String? catatan;

  const _Pengajuan({
    required this.nomor,
    required this.jenis,
    required this.berat,
    required this.alamat,
    required this.tanggal,
    required this.status,
    this.catatan,
  });
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Data contoh (sesuai storyboard). Ganti dengan data asli saat integrasi.
  static const List<_Pengajuan> _data = [
    _Pengajuan(
      nomor: '#001',
      jenis: 'Plastik',
      berat: '3 kg',
      alamat: 'Jl. Merdeka No. 10',
      tanggal: '5 Nov 2026',
      status: 'Menunggu',
      catatan: 'Plastik sudah dibersihkan',
    ),
    _Pengajuan(
      nomor: '#002',
      jenis: 'Kardus',
      berat: '5 kg',
      alamat: 'Jl. Merdeka No. 10',
      tanggal: '4 Nov 2026',
      status: 'Diproses',
    ),
    _Pengajuan(
      nomor: '#003',
      jenis: 'Kertas',
      berat: '2 kg',
      alamat: 'Jl. Merdeka No. 10',
      tanggal: '2 Nov 2026',
      status: 'Selesai',
    ),
  ];

  IconData _ikon(String jenis) {
    switch (jenis) {
      case 'Kertas':
        return Icons.newspaper;
      case 'Kardus':
        return Icons.inventory_2_outlined;
      case 'Minyak Jelantah':
        return Icons.oil_barrel_outlined;
      default:
        return Icons.recycling;
    }
  }

  Color _warna(String status) {
    switch (status) {
      case 'Diproses':
        return const Color(0xFF1E88E5);
      case 'Selesai':
        return _hijau;
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Color _latar(String status) {
    switch (status) {
      case 'Diproses':
        return const Color(0xFFE3F2FD);
      case 'Selesai':
        return _hijauMuda;
      default:
        return const Color(0xFFFFF1D6);
    }
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
          'Riwayat Penjemputan',
          style: TextStyle(
            color: _teks,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _data.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pengajuan penjemputan.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final p = _data[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(
                        nomor: p.nomor,
                        jenisSampah: p.jenis,
                        estimasiBerat: p.berat,
                        alamat: p.alamat,
                        tanggal: p.tanggal,
                        status: p.status,
                        catatan: p.catatan,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E5E0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _hijauMuda,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_ikon(p.jenis), color: _hijau),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.nomor,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _teks,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${p.jenis} • ${p.berat}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: _teks,
                                ),
                              ),
                              Text(
                                p.tanggal,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _latar(p.status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                p.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _warna(p.status),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
