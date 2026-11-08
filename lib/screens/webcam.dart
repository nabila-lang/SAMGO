import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Membuka kamera laptop langsung, menampilkan preview,
/// dan mengembalikan XFile saat tombol ambil foto ditekan.
class WebcamPage extends StatefulWidget {
  const WebcamPage({super.key});

  @override
  State<WebcamPage> createState() => _WebcamPageState();
}

class _WebcamPageState extends State<WebcamPage> {
  CameraController? _controller;
  String? _error;
  bool _sedangAmbil = false;

  @override
  void initState() {
    super.initState();
    _siapkanKamera();
  }

  Future<void> _siapkanKamera() async {
    try {
      final daftar = await availableCameras();
      if (daftar.isEmpty) {
        if (mounted) setState(() => _error = 'Kamera tidak ditemukan.');
        return;
      }
      final controller = CameraController(
        daftar.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            'Kamera tidak bisa dibuka. Pastikan izin kamera diizinkan (Allow) di browser.');
      }
    }
  }

  Future<void> _ambilFoto() async {
    final c = _controller;
    if (c == null || _sedangAmbil) return;
    setState(() => _sedangAmbil = true);
    try {
      final XFile foto = await c.takePicture();
      if (!mounted) return;
      Navigator.pop(context, foto);
    } catch (_) {
      if (mounted) setState(() => _sedangAmbil = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Ambil Foto Sampah'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          : _controller == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: Center(child: CameraPreview(_controller!)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: GestureDetector(
                        onTap: _ambilFoto,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.green, width: 5),
                          ),
                          child: _sedangAmbil
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                      strokeWidth: 3),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}