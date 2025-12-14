import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPeminjamPage extends StatelessWidget {
  final String userId; 
  final String title;
  final String hariTanggal;
  final String waktu;
  final String status;
  final bool isStaff; // Variabel Penentu Hak Akses

  const DetailPeminjamPage({
    super.key,
    required this.userId,
    required this.title,
    required this.hariTanggal,
    required this.waktu,
    required this.status,
    required this.isStaff, // Wajib diisi saat navigasi
  });

  String formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.startsWith('0')) {
      phone = "62" + phone.substring(1);
    }
    return phone;
  }

  void launchWhatsApp(String phone, String nama, String judul) async {
    final formattedPhone = formatPhoneNumber(phone);
    final message = "Halo $nama, terkait peminjaman $judul pada $hariTanggal...";
    final url = Uri.parse("https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Tidak dapat membuka WhatsApp";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF063DA7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Peminjam",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 20),
        ),
      ),
      
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Data pengguna tidak ditemukan"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String namaPeminjam = userData['full_name'] ?? 'Tanpa Nama';
          final String email = userData['email'] ?? '-';
          final String nim = email.contains('@') ? email.split('@')[0].toUpperCase() : '-';
          final String noHp = userData['phone_number'] ?? '-';
          final String? photoUrl = userData['photo_url'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.blue.shade100, width: 2),
                      boxShadow: [
                        BoxShadow(blurRadius: 6, offset: Offset(0, 3), color: Colors.blue.shade100),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        _infoRow("Hari, Tanggal:", hariTanggal),
                        _infoRow("Waktu:", waktu),
                        _infoRow("Status:", status),
                        const Divider(height: 30, thickness: 1),

                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                            image: (photoUrl != null && photoUrl.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(photoUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (photoUrl == null || photoUrl.isEmpty)
                              ? Icon(Icons.person, size: 50, color: Colors.grey.shade400)
                              : null,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          namaPeminjam,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(nim, style: const TextStyle(color: Colors.black87)),
                        
                        // Tampilkan No HP hanya jika Admin
                        if (isStaff)
                          Text(formatPhoneNumber(noHp), style: const TextStyle(color: Colors.black87)),

                        const SizedBox(height: 10),

                        // LOGIKA TOMBOL WA: Hanya muncul jika USER ADALAH STAFF
                        if (isStaff && (status.toLowerCase() == "terlambat" || status.toLowerCase() == "disetujui")) ...[
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: (noHp == '-' || noHp.isEmpty) 
                              ? null 
                              : () => launchWhatsApp(noHp, namaPeminjam, title),
                            child: const Text("Hubungi via WhatsApp", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}