import 'package:educycle/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import '../../widgets/navbar.dart';
import '../../models/user_model.dart'; // 1. Import Model

// Import Halaman Sub-Menu (Pastikan file ini ada)
import 'language_page.dart';
import 'laporan_masalah_page.dart';
import 'faq_page.dart';
import '../login_page.dart'; // Untuk Logout
import '../../services/auth_service.dart'; // Untuk Logout

class SettingPage extends StatelessWidget {
  final UserModel user; // 2. Siapkan variabel penampung

  const SettingPage({
    super.key,
    required this.user, // 3. Wajibkan saat dipanggil
  });

  // Fungsi Logout
  void _handleLogout(BuildContext context) async {
    await AuthService().signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading:
            false, // Hilangkan tombol back karena ada Navbar
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Section Akun
          ListTile(
            // leading: const Icon(Icons.person, color: AppColors.primaryBlue),
            leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          backgroundImage: (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                              ? NetworkImage(user.photoUrl!)
                              : null,
                        ),
            title: const Text('Akun Saya'),
            subtitle: Text(user.fullName), // Tampilkan nama user
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: user),
                ),
              );
            },
          ),
          const Divider(),

          // Menu Bahasa
          ListTile(
            leading: const Icon(Icons.language, color: Colors.orange),
            title: const Text('Bahasa'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LanguagePage()),
              );
            },
          ),

          // Menu FAQ
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.green),
            title: const Text('FAQ'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FAQPage()),
              );
            },
          ),

          // Menu Lapor Masalah
          ListTile(
            leading: const Icon(
              Icons.report_problem_outlined,
              color: Colors.red,
            ),
            title: const Text('Laporkan Masalah'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LaporanMasalahPage()),
              );
            },
          ),

          const Divider(),

          // Tombol Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),

      // 4. Pasang Navbar dengan data user
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 1, // Index 1 = Settings
        user: user, // Oper data user agar navigasi tidak putus
      ),
    );
  }
}
