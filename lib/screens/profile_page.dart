import 'package:educycle/constants/colors.dart';
import 'package:flutter/material.dart';
import '../widgets/profile_info_row.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // --- Data Mockup Sesuai Gambar ---
    const String userName = 'Adit Mahardika';
    const String nim = 'F1E123018';
    const String programStudi = 'Sistem Informasi';
    const String status = 'Mahasiswa';
    const String noHp = '082345678910';
    const String avatarAsset = 'assets/images/MyFoto.jpg'; 

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      
      // 1. App Bar (Bagian Biru di atas)
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,

        title: const Text(
            'Profile',
            style: TextStyle(
                color:Color(0xFFF59E0B),
                fontWeight: FontWeight.bold,
                fontSize: 24,
            ),
        ),
        
        actions: [
          // Tombol Notifikasi
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/notification'),
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.notifications_none, color: Color(0xFFF59E0B), size: 28),
            ),
          ),
        ],
      ), 

      // 2. Body Halaman
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width,
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              color: Color(0xFFF5F5F5), 
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                    backgroundImage: const AssetImage(avatarAsset),
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
                  color: Color(0xFFF5F5F5),
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
                    ProfileInfoRow(label: 'NIM', value: nim),
                    ProfileInfoRow(label: 'Program Studi', value: programStudi),
                    ProfileInfoRow(label: 'Status', value: status),
                    ProfileInfoRow(
                      label: 'No. HP',
                      value: noHp,
                      isLast: true, 
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: size.height * 0.2),
          ],
        ),
      ),

      // 3. Bottom Navigation Bar (Warna Biru)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          border: Border(
            top: BorderSide(
              color: Color(0xFFF59E0B),
              width: 3,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.primaryBlue,
          selectedItemColor: Color(0xFFF59E0B), 
          unselectedItemColor: Color(0xFFF5F5F5),
          iconSize: 35,
          
          currentIndex: 2, 
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/settings');
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
}