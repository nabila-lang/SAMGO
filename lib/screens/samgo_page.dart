import 'package:flutter/material.dart';

/// Komponen bersama untuk halaman Informasi Akun, Tentang SAMGO,
/// dan halaman ubah email / nomor HP / password.
/// Taruh di: lib/screens/samgo_page.dart

class SamgoColors {
  static const Color green = Color(0xFF16834A);
  static const Color darkGreen = Color(0xFF0B5D2E);
  static const Color lightGreen = Color(0xFFDDF3E3);
  static const Color textDark = Color(0xFF252525);
  static const Color textGrey = Color(0xFF5F6B63);
}

class SamgoAssets {
  // Sesuaikan jika nama/folder aset kalian berbeda.
  static const String background = 'images/bg_daun.png';
  static const String logo = 'images/Logo Samgo.jpg';
  static const String bumi = 'images/Bumi.png';
}

/// Halaman dengan background daun di tepian + header (tombol back & judul).
class SamgoPage extends StatelessWidget {
  final String title;
  final Widget child;

  const SamgoPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              SamgoAssets.background,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1A16834A),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              size: 18, color: SamgoColors.darkGreen),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: SamgoColors.darkGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu putih membulat dengan bayangan halus.
BoxDecoration samgoCardDecoration({double radius = 20}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: const [
      BoxShadow(
        color: Color(0x1416834A),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  );
}

/// Input teks bergaya SAMGO. Kalau [isPassword] true, ada ikon mata.
class SamgoTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const SamgoTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<SamgoTextField> createState() => _SamgoTextFieldState();
}

class _SamgoTextFieldState extends State<SamgoTextField> {
  bool _hidden = true;

  OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SamgoColors.darkGreen,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword && _hidden,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 14, color: SamgoColors.textDark),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 14, color: Colors.grey),
              prefixIcon: Icon(widget.icon, color: SamgoColors.green),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _hidden ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _hidden = !_hidden),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              enabledBorder: _border(const Color(0xFFCFE8D6)),
              focusedBorder: _border(SamgoColors.green, 1.5),
              errorBorder: _border(Colors.redAccent),
              focusedErrorBorder: _border(Colors.redAccent, 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol hijau utama (lebar penuh).
class SamgoButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SamgoButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: SamgoColors.green,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
