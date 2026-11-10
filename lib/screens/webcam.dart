
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class WebcamPage extends StatefulWidget {
  const WebcamPage({super.key});

  @override
  State<WebcamPage> createState() => _WebcamPageState();
}

class _WebcamPageState extends State<WebcamPage> {
  CameraController? _controller;

  List<CameraDescription> _daftarKamera = [];

  String? _error;

  int _indeksKamera = 0;

  bool _sedangAmbil = false;
  bool _sedangGanti = false;

  @override
  void initState() {
    super.initState();
    _siapkanKamera();
  }

  // ==========================================
  // MENYIAPKAN KAMERA
  // ==========================================

  Future<void> _siapkanKamera() async {
    try {
      _daftarKamera = await availableCameras();

      if (_daftarKamera.isEmpty) {
        if (mounted) {
          setState(() {
            _error = 'Kamera tidak ditemukan.';
          });
        }
        return;
      }

      // Memilih kamera depan sebagai kamera awal.
      final indeksDepan = _daftarKamera.indexWhere(
        (kamera) =>
            kamera.lensDirection == CameraLensDirection.front,
      );

      _indeksKamera = indeksDepan >= 0 ? indeksDepan : 0;

      await _aktifkanKamera(_indeksKamera);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal menyiapkan kamera: $e';
        });
      }
    }
  }

  // ==========================================
  // MENGAKTIFKAN KAMERA
  // ==========================================

  Future<void> _aktifkanKamera(int indeks) async {
    CameraController? controllerBaru;

    try {
      // Menutup kamera yang sedang digunakan.
      final controllerLama = _controller;
      _controller = null;

      if (mounted) {
        setState(() {});
      }

      await controllerLama?.dispose();

      // Membuat controller kamera baru.
      controllerBaru = CameraController(
        _daftarKamera[indeks],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controllerBaru.initialize();

      if (!mounted) {
        await controllerBaru.dispose();
        return;
      }

      setState(() {
        _controller = controllerBaru;
        _indeksKamera = indeks;
        _error = null;
      });

      debugPrint(
        'Kamera aktif: ${_daftarKamera[indeks].name}',
      );
      debugPrint(
        'Arah kamera: ${_daftarKamera[indeks].lensDirection}',
      );
      debugPrint(
        'Orientasi sensor: '
        '${_daftarKamera[indeks].sensorOrientation}',
      );
    } catch (e) {
      await controllerBaru?.dispose();

      if (mounted) {
        setState(() {
          _error = 'Kamera tidak bisa dibuka: $e';
        });
      }
    }
  }

  // ==========================================
  // MENGGANTI KAMERA DEPAN / BELAKANG
  // ==========================================

  Future<void> _gantiKamera() async {
    if (_daftarKamera.length < 2 ||
        _sedangAmbil ||
        _sedangGanti) {
      return;
    }

    setState(() {
      _sedangGanti = true;
    });

    final indeksBaru =
        (_indeksKamera + 1) % _daftarKamera.length;

    await _aktifkanKamera(indeksBaru);

    if (mounted) {
      setState(() {
        _sedangGanti = false;
      });
    }
  }

  // ==========================================
  // MENGAMBIL FOTO
  // ==========================================

  Future<void> _ambilFoto() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        _sedangAmbil ||
        _sedangGanti) {
      return;
    }

    setState(() {
      _sedangAmbil = true;
    });

    try {
      final XFile foto = await controller.takePicture();

      if (!mounted) return;

      // Mengembalikan hasil foto ke halaman sebelumnya.
      Navigator.pop(context, foto);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal mengambil foto: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _sedangAmbil = false;
        });
      }
    }
  }

  // ==========================================
  // MENUTUP KAMERA
  // ==========================================

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ==========================================
  // TAMPILAN HALAMAN KAMERA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final kameraSiap =
        _controller != null &&
        _controller!.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text('Ambil Foto Sampah'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            )

          : !kameraSiap
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )

              : Column(
                  children: [
                    // AREA PREVIEW KAMERA
                    Expanded(
                      child: Center(
                        child: CameraPreview(_controller!),
                      ),
                    ),

                    // AREA TOMBOL KAMERA
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          // Ruang kosong sebelah kiri.
                          const SizedBox(width: 48),

                          // TOMBOL MEMOTRET
                          GestureDetector(
                            onTap: _ambilFoto,
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF16834A),
                                  width: 5,
                                ),
                              ),
                              child: _sedangAmbil
                                  ? const Padding(
                                      padding: EdgeInsets.all(20),
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : null,
                            ),
                          ),

                          // TOMBOL GANTI KAMERA
                          IconButton(
                            onPressed:
                                _daftarKamera.length > 1 &&
                                        !_sedangAmbil &&
                                        !_sedangGanti
                                    ? _gantiKamera
                                    : null,
                            icon: const Icon(
                              Icons.cameraswitch,
                              size: 34,
                              color: Colors.white,
                            ),
                            tooltip: 'Ganti kamera',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
