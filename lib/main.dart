import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart'; 
import 'firebase_options.dart';
import 'constants/colors.dart'; 
import 'package:google_fonts/google_fonts.dart';

// Halaman Awal
import 'screens/login_page.dart';
// Note: NotificationPage sudah dihapus dari import

void main() async {
  // 1. Kunci Pengaman: Pastikan engine Flutter siap sebelum panggil Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Mengunci orientasi layar ke Potrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCycle',
      debugShowCheckedModeBanner: false,
      
      // KONFIGURASI TEMA (Global Design System)
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryBlue,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          secondary: AppColors.secondaryOrange, 
          surface: Colors.white, 
        ),

        // Font Style Global (Poppins)
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            color: AppColors.secondaryOrange,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      // PINTU MASUK UTAMA
      home: const LoginPage(),

      // Callback jika navigasi nyasar (Optional Error Handling)
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan!')),
          ),
        );
      },
    );
  }
}