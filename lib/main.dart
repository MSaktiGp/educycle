import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart'; // Untuk mengatur warna status bar HP
import 'firebase_options.dart';
import 'constants/colors.dart'; // Import file warna Anda
import 'package:google_fonts/google_fonts.dart';
// import 'screens/database_seeder.dart';

// Halaman Awal
import 'screens/login_page.dart';
import 'screens/notification_page.dart';
import 'models/user_model.dart';

// Catatan Kritis:
// Jangan import home_page.dart atau profile_page.dart di sini
// karena kita tidak akan mendaftarkannya di static routes.

void main() async {
  // 1. Kunci Pengaman: Pastikan engine Flutter siap sebelum panggil Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Opsional: Mengunci orientasi layar ke Potrait (biar desain tidak hancur saat HP dimiringkan)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 4. Opsional: Mengubah warna Status Bar HP agar menyatu dengan desain Biru
  // SystemChrome.setSystemUIOverlayStyle(const SystemUIOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarIconBrightness: Brightness.light, // Ikon sinyal/baterai jadi putih
  // ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCycle',
      debugShowCheckedModeBanner:
          false, // Menghilangkan pita "DEBUG" di pojok kanan
      // KONFIGURASI TEMA (Global Design System)
      // Ini akan otomatis mewarnai AppBar dan Tombol di seluruh aplikasi
      theme: ThemeData(
        useMaterial3: true,

        // Warna Utama (Biru)
        primaryColor: AppColors.primaryBlue,

        // Skema Warna Material 3 (Dominan Biru, Aksen Orange)
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          secondary: AppColors
              .secondaryOrange, // Tombol aksi/floating button akan orange
          surface: Colors
              .white, // Warna dasar halaman (pengganti scaffoldBackgroundColor manual)
        ),

        // Default Style untuk AppBar dan font Poppins secara global
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white, // Warna teks judul & ikon back
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            color: AppColors.secondaryOrange,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        // Default Style untuk ElevatedButton (Tombol Login, dll)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ), // Radius standar aplikasi
            ),
          ),
        ),

        // Font Family (Jika nanti ada font khusus, pasang di sini)
        // fontFamily: 'Poppins',
      ),

      // PINTU MASUK UTAMA
      // Kita langsung arahkan ke Login Page.
      // Nanti Login Page yang bertugas mengantar user ke Home.
      home: const LoginPage(),

      // Dynamic route handler - needed to pass user data to some pages like /notification
      onGenerateRoute: (settings) {
        if (settings.name == '/notification') {
          final args = settings.arguments;
          UserModel? userArg;
          if (args is UserModel) userArg = args;
          return MaterialPageRoute(
            builder: (context) => NotificationPage(user: userArg),
            settings: settings,
          );
        }
        return null; // fallback to routes map or onUnknownRoute
      },

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
