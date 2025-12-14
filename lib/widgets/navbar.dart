import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import '../models/user_model.dart'; // Import Model User

// Import Halaman Tujuan Navigasi
import '../screens/home_page.dart';
import '../screens/profile_page.dart';
import '../screens/settings/setting_page.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final UserModel user; // <--- LOGIKA BARU: Wajib membawa data user

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.user, // <--- Wajib diisi saat dipanggil
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex)
      return; // Mencegah reload jika menekan tombol yang sama

    // LOGIKA NAVIGASI DINAMIS (Estafet Data User)
    // Kita menggunakan MaterialPageRoute agar bisa melempar object 'user' ke halaman tujuan.

    Widget destination;

    switch (index) {
      case 0:
        destination = HomePage(user: user);
        break;
      case 1:
        // PERINGATAN KRITIS: Pastikan SettingPage sudah dimodifikasi
        // agar menerima parameter 'user', jika tidak ini akan error merah.
        destination = SettingPage(user: user);
        break;
      case 2:
        destination = ProfilePage(user: user);
        break;
      default:
        return;
    }

    // Eksekusi Pindah Halaman
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Variabel warna agar kode lebih rapi
    final primaryColor = AppColors.primaryBlue;
    final accentColor = AppColors.secondaryOrange;

    return Container(
      // DESAIN KHUSUS EDUCACLE:
      // Background Biru dengan garis tebal Orange di bagian atas
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border(top: BorderSide(color: accentColor, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 6,
        ), // Sedikit jarak dari garis orange
        child: BottomNavigationBar(
          backgroundColor: primaryColor,
          selectedItemColor: accentColor, // Ikon aktif berwarna Orange
          unselectedItemColor: Colors.white, // Ikon pasif berwarna Putih
          iconSize: 32, // Ukuran ikon diperbesar sedikit agar mudah ditekan
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,

          // Menyembunyikan Label Teks (Sesuai Desain Minimalis Anda)
          selectedFontSize: 0,
          unselectedFontSize: 0,

          onTap: (index) => _onItemTapped(context, index),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), // Icon Home lebih tebal
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
