import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart'; 

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background abu-abu muda, sesuai skema Home/Profile
      backgroundColor: Colors.grey.shade100,
      
      // 1. App Bar
      appBar: AppBar(
        // Tombol kembali (Back Button)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, 
          color: Color(0xFFF59E0B),
          size: 28
          ),
          onPressed: () => Navigator.pop(context),
        ),
        
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: AppColors.secondaryOrange, // Teks judul oranye
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      // 2. Body: Daftar Notifikasi
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian HARI INI ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Hari Ini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
            
            // Notifikasi 1: Peminjaman Telah Disetujui (Warna Biru Tua)
            _buildNotificationCard(
              title: 'Peminjaman Telah Disetujui',
              subtitle: 'Silahkan ambil kunci sesuai dengan waktu peminjaman.',
              isImportant: true,
              isRedDot: true,
            ),

            // Notifikasi 2: Pengingat Pengembalian (Warna Biru Tua)
            _buildNotificationCard(
              title: 'Pengingat Pengembalian',
              subtitle: 'Proyektor 01-FSTB\nWaktu peminjaman Anda telah habis. Segera kembalikan barang yang sedang dipinjam.',
              isImportant: true,
              isRedDot: true,
            ),
            
            // Notifikasi 3: Peminjaman Selesai (Warna Abu-abu Terang)
            _buildNotificationCard(
              title: 'Peminjaman Selesai',
              subtitle: 'Proyektor 02-FSTB\nPeminjaman telah selesai. Cek selengkapnya di sini.',
              isImportant: false,
            ),

            // Notifikasi 4: Peminjaman Selesai (Warna Abu-abu Terang)
            _buildNotificationCard(
              title: 'Peminjaman Selesai',
              subtitle: 'Terminal Listrik 01-FSTB\nPeminjaman telah selesai. Cek selengkapnya di sini.',
              isImportant: false,
            ),
            
            const Divider(height: 1), // Garis pemisah visual

            // --- Bagian KEMARIN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Kemarin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),

            // Notifikasi 5: Pembaharuan Sistem (Warna Abu-abu Terang)
            _buildNotificationCard(
              title: 'Pembaharuan Sistem Versi 1.0.1',
              subtitle: 'Cek selengkapnya di sini.',
              isImportant: false,
            ),
            
            // Notifikasi 6: Peminjaman Selesai (Warna Abu-abu Terang)
            _buildNotificationCard(
              title: 'Peminjaman Selesai',
              subtitle: 'Kabel HDMI 02-FSTB\nPeminjaman telah selesai. Cek selengkapnya di sini.',
              isImportant: false,
            ),
          ],
        ),
      ),
      
      // 3. Bottom Navigation Bar (Bottom Bar)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          border: Border(
            top: BorderSide(
              color: AppColors.secondaryOrange,
              width: 3,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.primaryBlue,
          selectedItemColor: AppColors.secondaryOrange, 
          unselectedItemColor: Colors.white,
          iconSize: 35,
          // Karena ini halaman notifikasi, tidak ada item yang aktif di Bottom Bar
          currentIndex: 0, 
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (index) {
            // Logika navigasi BottomBar (asumsi rute sudah didefinisikan)
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/settings');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Kartu Notifikasi
  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required bool isImportant,
    bool isRedDot = false,
  }) {
    final cardColor = isImportant ? AppColors.primaryBlue : AppColors.backgroundLightBlue;
    final titleColor = isImportant ? Colors.white : AppColors.textDark;
    final subtitleColor = isImportant ? Colors.white70 : AppColors.textGray;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
      child: Card(
        color: cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: () {
            // Aksi saat notifikasi diklik (misalnya, navigasi ke detail)
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isRedDot)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0, top: 4.0),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}