import 'package:educycle/constants/colors.dart';
import 'package:flutter/material.dart';

// Pastikan file ini ada di folder widgets
import '../widgets/profile_info_row.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Digunakan untuk penyesuaian tata letak
    final size = MediaQuery.of(context).size;

    // --- Data Mockup Sesuai Gambar ---
    const String userName = 'Adit Mahardika';
    const String nim = 'F1E123018';
    const String programStudi = 'Sistem Informasi';
    const String status = 'Mahasiswa';
    const String noHp = '082345678910';
    // Ganti dengan path aset gambar Anda
    const String avatarAsset = 'assets/images/MyFoto.jpg'; 

    return Scaffold(
      backgroundColor: Colors.white,
      
      // 1. App Bar (Bagian Biru di atas)
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.1), // Tinggi AppBar yang lebih besar
        child: AppBar(
          automaticallyImplyLeading: false, // Menghilangkan tombol back default
          backgroundColor: AppColors.primaryBlue,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Kembali
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: Color(0xFFF59E0B), size: 28),
                ),
                
                // Judul "Profile"
                const Text(
                  'Profile',
                  style: TextStyle(
                    color:Color(0xFFF59E0B),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                
                // Tombol Notifikasi
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/notifications'),
                  child: const Icon(Icons.notifications_none, color: Color(0xFFF59E0B), size: 28),
                ),
              ],
            ),
          ),
        ),
      ),

      // 2. Body Halaman
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Area Profil (Avatar dan Nama)
            Container(
              width: size.width,
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              color: Colors.white, 
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                    // Mencoba memuat gambar dari aset
                    backgroundImage: const AssetImage(avatarAsset), 
                    // Fallback jika gambar aset tidak ditemukan
                    child: const Icon( 
                      Icons.person,
                      size: 60,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Nama Pengguna
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            // Card Informasi Detail
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderGray, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    // Baris Data 1: NIM
                    ProfileInfoRow(label: 'NIM', value: nim),
                    // Baris Data 2: Program Studi
                    ProfileInfoRow(label: 'Program Studi', value: programStudi),
                    // Baris Data 3: Status
                    ProfileInfoRow(label: 'Status', value: status),
                    // Baris Data 4: No. HP (isLast: true agar tidak ada divider)
                    ProfileInfoRow(
                      label: 'No. HP',
                      value: noHp,
                      isLast: true, 
                    ),
                  ],
                ),
              ),
            ),
            
            // Jarak tambahan di bagian bawah
            SizedBox(height: size.height * 0.2),
          ],
        ),
      ),

      // 3. Bottom Navigation Bar (Warna Biru)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          // Border atas oranye sesuai BottomNavBar di HomePage
          border: Border(
            top: BorderSide(
              color: Color(0xFFF59E0B),
              width: 3,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.primaryBlue,
          selectedItemColor: Color(0xFFF59E0B), // Ikon 'person' aktif
          unselectedItemColor: Colors.white,
          iconSize: 35,
          // index 2 (person) adalah halaman profil
          currentIndex: 2, 
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (index) {
            // Logika navigasi BottomBar
            if (index == 0) {
              // Navigasi ke Home
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              // Navigasi ke Settings (jika ada)
              // Navigator.pushReplacementNamed(context, '/settings');
            }
            // Jika index == 2, tetap di halaman ini
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
}