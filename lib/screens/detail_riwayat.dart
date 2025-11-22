import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPeminjamPage extends StatelessWidget {
  final String namaPeminjam;
  final String nim;
  final String noHp;
  final String title;
  final String hariTanggal;
  final String waktu;
  final String status;

  const DetailPeminjamPage({
    super.key,
    required this.namaPeminjam,
    required this.nim,
    required this.noHp,
    required this.title,
    required this.hariTanggal,
    required this.waktu,
    required this.status,
  });

  // ------------------------------------------------------
  // 🔧 FUNGSI FORMAT NOMOR → WAJIB AGAR WA TIDAK JADI +8
  // ------------------------------------------------------
  String formatPhoneNumber(String phone) {
    // Hilangkan karakter selain angka
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Jika dimulai dengan 0 → ubah ke 62
    if (phone.startsWith('0')) {
      phone = "62" + phone.substring(1);
    }

    return phone;
  }

  // ------------------------------------------------------
  // 🔧 FUNGSI BUKA WHATSAPP (sudah pakai nomor ter-format)
  // ------------------------------------------------------
  void launchWhatsApp(String phone, String message) async {
    // Format nomor sebelum dipakai
    final formattedPhone = formatPhoneNumber(phone);

    final url = Uri.parse("https://wa.me/$formattedPhone?text=$message");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Tidak dapat membuka WhatsApp";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nomor yang ditampilkan juga akan otomatis ter-format
    final formattedDisplayPhone = formatPhoneNumber(noHp);

    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APPBAR ===================
      appBar: AppBar(
        backgroundColor: const Color(0xFF063DA7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Peminjam",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            fontSize: 20,
          ),
        ),
      ),

      // ================= BODY ===================
      body: SingleChildScrollView(
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
                    BoxShadow(
                      blurRadius: 6,
                      offset: Offset(0, 3),
                      color: Colors.blue.shade100,
                    ),
                  ],
                ),

                // ================= CARD CONTENT ===================
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title Ruangan/Barang
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info hari, waktu, status
                    infoRow("Hari, Tanggal:", hariTanggal),
                    infoRow("Waktu:", waktu),
                    infoRow("Status:", status),
                    const Divider(height: 30, thickness: 1),

                    // Foto Profil
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white, size: 50),
                    ),
                    const SizedBox(height: 10),

                    // Peminjam info
                    Text(
                      namaPeminjam,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(nim, style: const TextStyle(color: Colors.black87)),

                    // ==== nomor HP tampil dalam format internasional ====
                    Text(
                      formattedDisplayPhone,
                      style: const TextStyle(color: Colors.black87),
                    ),

                    const SizedBox(height: 10),

                    // Tombol WhatsApp muncul jika status terlambat
                    if (status.toLowerCase() == "terlambat") ...[
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          launchWhatsApp(
                            noHp, // nomor mentah (nanti diformat)
                            "Halo $namaPeminjam, terkait peminjaman $title...",
                          );
                        },
                        child: const Text(
                          "Hubungi via WhatsApp",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
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
