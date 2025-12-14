import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import 'package:educycle/widgets/navbar.dart';
import '../../models/user_model.dart';

class StatusPeminjamanPage extends StatelessWidget {
  final UserModel user;
  const StatusPeminjamanPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Data Peminjaman dari Arguments (Sudah Benar)
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String titleDisplay = '';
    if (args?['type'] == 'barang') {
      titleDisplay = args?['itemName'] ?? 'Barang';
    } else {
      titleDisplay = args?['roomName'] ?? 'Ruangan';
    }
    final date = args?['date'] ?? '';
    final time = args?['time'] ?? '';
    final status = args?['status'] ?? 'Menunggu Persetujuan';

    // 2. Siapkan Data User (INI YANG BARU)
    final String displayName = user.fullName.isNotEmpty ? user.fullName : 'Tanpa Nama';
    // Logika NIM: Ambil teks sebelum '@' dari email dan jadikan huruf besar
    final String displayNim = user.email.contains('@') 
        ? user.email.split('@')[0].toUpperCase() 
        : user.email;
    final String displayPhone = user.phoneNumber ?? '-';

    final primaryColor = AppColors.primaryBlue;
    const accentColor = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: accentColor, size: 28),
          onPressed: () {
            // Kembali ke Home (bersihkan tumpukan halaman)
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Keterangan',
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor, width: 3),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header: Kode Barang/Ruangan
                Text(
                  titleDisplay,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                ),

                const SizedBox(height: 20),

                // Detail Data Peminjaman
                _buildDetailRow('Hari, Tanggal:', date, primaryColor),
                const SizedBox(height: 12),
                _buildDetailRow('Waktu:', time, primaryColor),
                const SizedBox(height: 12),
                _buildDetailRow('Status:', status, primaryColor),

                const SizedBox(height: 24),
                const Divider(), // Garis pemisah
                const SizedBox(height: 16),

                // Profile Section (DATA DINAMIS)
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    image: (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(user.photoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (user.photoUrl == null || user.photoUrl!.isEmpty)
                      ? Icon(Icons.person, size: 50, color: Colors.grey.shade400)
                      : null,
                ),

                const SizedBox(height: 16),

                // User Info (TIDAK HARDCODE LAGI)
                Text(
                  displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: primaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  displayNim, // NIM Otomatis
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 2),
                Text(
                  displayPhone, // No HP Otomatis
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0, user: user),
    );
  }

  Widget _buildDetailRow(String label, String value, Color primaryColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333), fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}