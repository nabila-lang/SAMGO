import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import 'map_picker_screen.dart';
import 'webcam.dart';

class PickupFormScreen extends StatefulWidget {
  const PickupFormScreen({super.key});

  @override
  State<PickupFormScreen> createState() => _PickupFormScreenState();
}

class _PickupFormScreenState extends State<PickupFormScreen> {
  String selectedJenisSampah = 'Plastik';

  final List<String> jenisSampahList = [
    'Plastik',
    'Kertas',
    'Kardus',
    'Minyak Jelantah',
  ];

  // ---- Alamat + Peta ----
  static const LatLng _pusatPontianak = LatLng(-0.0263, 109.3425);
  final TextEditingController _alamatController = TextEditingController();
  Timer? _debounce;
  LatLng? _lokasi;
  String? _namaLokasi;
  bool _mencari = false;

  // ---- Foto ----
  String? _namaFileTerpilih;
  String? _sumberFoto;
  Uint8List? _fotoBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _debounce?.cancel();
    _alamatController.dispose();
    super.dispose();
  }

  void _snack(String pesan) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  // ================= ALAMAT & PETA =================
  void _onAlamatChanged(String _) {
    setState(() {}); // supaya peta muncul begitu ada teks
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 900), () {
      if (_alamatController.text.trim().length >= 4) {
        _cariAlamat(tampilPesan: false);
      }
    });
  }

  Future<void> _cariAlamat({bool tampilPesan = true}) async {
    var q = _alamatController.text.trim();
    if (q.isEmpty) return;
    if (!q.toLowerCase().contains('pontianak')) q = '$q, Pontianak';

    setState(() => _mencari = true);
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': q,
        'format': 'jsonv2',
        'limit': '1',
        'countrycodes': 'id',
      });
      // Browser melarang header User-Agent, jadi hanya dikirim di HP/desktop
      final res = await http.get(
        uri,
        headers: kIsWeb ? null : {'User-Agent': 'uts_samgo (tugas kuliah)'},
      );

      if (res.statusCode != 200) {
        if (tampilPesan) {
          _snack('Server peta menolak permintaan (kode ${res.statusCode}).');
        }
        return;
      }

      final List data = jsonDecode(res.body) as List;
      if (data.isEmpty) {
        if (tampilPesan) {
          _snack('Alamat tidak ditemukan. Pilih titik manual lewat peta.');
        }
        return;
      }

      final lat = double.parse(data[0]['lat'] as String);
      final lon = double.parse(data[0]['lon'] as String);
      setState(() {
        _lokasi = LatLng(lat, lon);
        _namaLokasi = data[0]['display_name'] as String?;
      });
    } catch (e) {
      debugPrint('Cari alamat gagal: $e');
      if (tampilPesan) _snack('Gagal mencari alamat: $e');
    } finally {
      if (mounted) setState(() => _mencari = false);
    }
  }

  Future<void> _bukaPeta() async {
    final hasil = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MapPickerScreen(initialPoint: _lokasi ?? _pusatPontianak),
      ),
    );
    if (hasil != null) {
      setState(() {
        _lokasi = hasil;
        _namaLokasi = 'Titik dipilih di peta';
      });
    }
  }

  Widget _buildPeta() {
    final titik = _lokasi ?? _pusatPontianak;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        InkWell(
          onTap: _bukaPeta,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 160,
              child: Stack(
                children: [
                  // Peta mini hanya sebagai gambar (tidak bisa digeser)
                  IgnorePointer(
                    child: FlutterMap(
                      key: ValueKey(titik),
                      options: MapOptions(initialCenter: titik, initialZoom: 16),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.uts_samgo',
                        ),
                        if (_lokasi != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _lokasi!,
                                width: 44,
                                height: 44,
                                alignment: Alignment.topCenter,
                                child: const Icon(Icons.location_pin,
                                    color: Colors.red, size: 44),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16834A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Tekan untuk pilih titik',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _lokasi == null
              ? 'Tekan peta untuk memilih titik penjemputan'
              : '${_namaLokasi ?? ''}\n'
                  'Lat ${_lokasi!.latitude.toStringAsFixed(6)}, '
                  'Lng ${_lokasi!.longitude.toStringAsFixed(6)}',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  // ================= FOTO (WEBCAM & FILE EXPLORER) =================
  Future<void> _ambilFotoWebcam() async {
    final foto = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WebcamPage()),
    );
    if (foto != null) {
      final bytes = await foto.readAsBytes();
      setState(() {
        _namaFileTerpilih = foto.name;
        _fotoBytes = bytes;
        _sumberFoto = 'Kamera Web';
      });
      _snack('Foto berhasil diambil dari webcam!');
    }
  }

  Future<void> _pilihDariGaleri() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _namaFileTerpilih = image.name;
          _fotoBytes = bytes;
          _sumberFoto = 'File Explorer';
        });
        _snack('Foto berhasil dipilih dari File Explorer!');
      }
    } catch (e) {
      _snack('Gagal memilih foto: $e');
    }
  }

  void _pilihSumberFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Sumber Foto Sampah',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF252525),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF16834A)),
              title: const Text('Ambil dari Webcam'),
              onTap: () {
                Navigator.pop(context);
                _ambilFotoWebcam();
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open, color: Color(0xFF16834A)),
              title: const Text('Pilih dari File Explorer (Galeri)'),
              onTap: () {
                Navigator.pop(context);
                _pilihDariGaleri();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAMPILAN UI =================
  InputDecoration _dekorasi(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF3F5F3),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF16834A), width: 1.5),
      ),
    );
  }

  Widget _label(String teks) => Text(
        teks,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF252525)),
      );

  @override
  Widget build(BuildContext context) {
    final bool adaFoto = _namaFileTerpilih != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color(0xFF252525), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Form Penjemputan',
          style: TextStyle(
            color: Color(0xFF252525),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _label('Jenis Sampah'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedJenisSampah,
                  items: jenisSampahList
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                const Icon(Icons.recycling,
                                    color: Color(0xFF16834A), size: 20),
                                const SizedBox(width: 12),
                                Text(category,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF252525))),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedJenisSampah = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _label('Estimasi Berat (kg)'),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: _dekorasi('Contoh: 3'),
            ),
            const SizedBox(height: 16),
            _label('Alamat Penjemputan'),
            const SizedBox(height: 8),
            TextField(
              controller: _alamatController,
              textInputAction: TextInputAction.search,
              onChanged: _onAlamatChanged,
              onSubmitted: (_) => _cariAlamat(),
              decoration: _dekorasi('Ketik alamat, mis. Jl. Merdeka').copyWith(
                prefixIcon: const Icon(Icons.location_on_outlined,
                    color: Color(0xFF16834A)),
                suffixIcon: _mencari
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.search,
                            color: Color(0xFF16834A)),
                        onPressed: _cariAlamat,
                      ),
              ),
            ),
            // Peta muncul begitu alamat mulai diketik
            if (_alamatController.text.trim().isNotEmpty) _buildPeta(),
            const SizedBox(height: 16),
            _label('Catatan (Opsional)'),
            const SizedBox(height: 8),
            TextField(decoration: _dekorasi('Tambahkan catatan...')),
            const SizedBox(height: 16),
            _label('Foto Sampah (Opsional)'),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pilihSumberFoto,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, width: 1.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          adaFoto
                              ? Icons.check_circle
                              : Icons.camera_alt_outlined,
                          color:
                              adaFoto ? const Color(0xFF16834A) : Colors.grey,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            adaFoto
                                ? '$_namaFileTerpilih ($_sumberFoto)'
                                : 'Ambil Foto via Webcam / File Explorer',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: adaFoto
                                  ? const Color(0xFF16834A)
                                  : Colors.grey,
                              fontWeight:
                                  adaFoto ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_fotoBytes != null) ...[
                      const SizedBox(height: 12),
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
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16834A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/confirmation');
              },
              child: const Text(
                'Kirim Request',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}