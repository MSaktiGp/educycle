import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import '../widgets/navbar.dart';
import '../models/user_model.dart';
import '../widgets/profile_info_row.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;

  const ProfilePage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // Logika NIM: Ambil dari bagian depan email jika formatnya angka (misal f1e...@unja)
    String nimDisplay = user.email.split('@')[0].toUpperCase();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background abu-abu muda
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryOrange, fontSize: 24),
        ),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0, // Hilangkan bayangan agar menyatu dengan body
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER BIRU & AVATAR =================
            Stack(
              clipBehavior: Clip.none, // Izinkan elemen keluar dari kotak stack
              alignment: Alignment.center,
              children: [
                // 1. Background Biru
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),

                // 2. Avatar & Nama (Posisi agak turun menimpa batas biru)
                Positioned(
                  top: 20, 
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4), // Border putih avatar
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                              ? NetworkImage(user.photoUrl!)
                              : null,
                          child: (user.photoUrl == null || user.photoUrl!.isEmpty)
                              ? Text(
                                  user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                                  style: const TextStyle(fontSize: 40, color: AppColors.primaryBlue),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      // Nama User
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark, // Warna gelap karena sudah keluar dari area biru
                        ),
                      ),
                      
                      // Role Badge (Pill Shape)
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: user.isStaff ? Colors.orange.withOpacity(0.2) : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: user.isStaff ? Colors.orange : Colors.blue,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          user.isStaff ? "Administrator" : "Mahasiswa",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: user.isStaff ? Colors.orange[800] : Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Memberi jarak karena Avatar kita geser pakai Stack
            const SizedBox(height: 100), 

            // ================= DATA CARD =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Menggunakan Widget Baru yang Rapi
                    ProfileInfoRow(
                      label: user.isStaff ? 'NIP' : 'NIM',
                      value: nimDisplay,
                      icon: Icons.badge_outlined,
                    ),
                    ProfileInfoRow(
                      label: 'Status',
                      value: user.isStaff ? 'Staf Tata Usaha' : 'Mahasiswa',
                      icon: user.isStaff ? Icons.admin_panel_settings_outlined : Icons.school_outlined,
                    ),
                    ProfileInfoRow(
                      label: 'No. Telepon',
                      value: user.phoneNumber ?? '-',
                      icon: Icons.phone_android_outlined,
                    ),
                    // Jika ada Program Studi di data user model, tampilkan disini
                    // ProfileInfoRow(label: 'Prodi', value: 'Sistem Informasi', icon: Icons.school_outlined, isLast: true),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),

      // Navbar Wajib
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2, // Index Profil
        user: user,
      ),
    );
  }
}