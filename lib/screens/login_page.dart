import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'home_page.dart'; // Pastikan import ini ada

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State Variables
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Instance Service
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final identifier = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    String? errorMessage;
    if (identifier.isEmpty && password.isEmpty) {
      errorMessage = 'NIM/NIP dan password tidak boleh kosong';
    } else if (identifier.isEmpty) {
      errorMessage = 'NIM/NIP tidak boleh kosong';
    } else if (password.isEmpty) {
      errorMessage = 'Password tidak boleh kosong';
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.dangerRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // LOGIKA SUFFIX DOMAIN OTOMATIS
      // Normalisasi ke huruf kecil untuk menghindari masalah case-sensitivity
      final String lower = identifier.toLowerCase();
      String emailToSend;
      if (identifier.contains('@')) {
        emailToSend = lower;
      } else {
        emailToSend = '${lower}@unja.ac.id';
      }

      // Panggil Service Firebase
      UserModel? user = await _authService.signIn(emailToSend, password);

      if (!mounted) return;

      if (user != null) {
        // Navigasi membawa data user
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lupa Password?"),
        content: const Text(
          "Silakan hubungi Staf Administrasi di Tata Usaha untuk melakukan reset password secara manual.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hitung 40% tinggi layar
    final double headerHeight = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      backgroundColor: Colors.white, // Area bawah gambar tetap putih bersih
      body: Stack(
        children: [
          // ==============================
          // LAPISAN 1: HEADER GAMBAR (TOP 40%)
          // ==============================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight, // Batasi tinggi hanya 40%
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fst.png'), // Gambar FST
                  fit:
                      BoxFit.cover, // Memenuhi area, boleh terpotong horizontal
                  alignment: Alignment.topCenter, // Fokus tengah atas
                ),
              ),
              // Overlay gradien agar teks putih di atasnya lebih terbaca
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7), // Atas agak gelap
                      Colors.black.withOpacity(
                        0.0,
                      ), // Bawah transparan (menyatu ke putih)
                    ],
                    stops: const [0.0, 0.8],
                  ),
                ),
              ),
            ),
          ),

          // ==============================
          // LAPISAN 2: KONTEN FORM (SCROLLABLE)
          // ==============================
          // Gunakan SafeArea hanya untuk bagian atas agar tidak tertutup notch
          SafeArea(
            bottom: false,
            child: Center(
              child: SingleChildScrollView(
                // Beri padding atas ekstra agar konten mulai agak turun dari status bar
                padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo placeholder
                    const SizedBox(height: 80),

                    // Welcome text (TEKS PUTIH KARENA DI ATAS GAMBAR)
                    const Text(
                      'Selamat Datang!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:FontWeight.bold,
                        color: AppColors
                            .secondaryOrange, // Kontras dengan background FST
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black45,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Silahkan login untuk melanjutkan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.white30,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    // Jarak ini mendorong form input ke bawah, melewati batas gambar
                    const SizedBox(height: 24),

                    // =============================================
                    // AREA INPUT (Mulai masuk ke area background putih)
                    // =============================================

                    // Card pembungkus agar form terlihat 'mengambang' di perbatasan
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Username/NIP Input
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'NIM / NIP',
                              hintText: 'NIM / NIP',
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: AppColors.primaryBlue,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryBlue,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password Input
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: AppColors.primaryBlue,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primaryBlue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryBlue,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login Button with Loading State
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 5,
                                shadowColor: AppColors.primaryBlue.withOpacity(
                                  0.4,
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 40),

                    // Copyright text
                    const Center(
                      child: Text(
                        'Copyright EduCycle @2025',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ), // Extra padding bawah untuk scroll
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
