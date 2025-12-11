import 'package:flutter/material.dart';
import 'package:educycle/screens/staf/detail.dart';

class KonfirmasiPage extends StatefulWidget {
  const KonfirmasiPage({super.key});

  @override
  State<KonfirmasiPage> createState() => _KonfirmasiPageState();
}

class _KonfirmasiPageState extends State<KonfirmasiPage> {
  bool isRuangan = true; // default tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003B80),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Peminjaman",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),

      // ================== BODY ==================
      body: Column(
        children: [
          // ================= TAB =================
          Container(
            color: const Color(0xFF003B80),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isRuangan = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isRuangan
                              ? const Color(0xFFFFA726)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Ruangan",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isRuangan = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isRuangan
                              ? const Color(0xFFFFA726)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Barang",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ================= LIST =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: _getListData().map((item) {
                return buildCard(
                  title: item["title"] ?? "",
                  tanggal: item["tanggal"] ?? "",
                  waktu: item["waktu"] ?? "",
                  nama: item["nama"] ?? "",
                );
              }).toList(),
            ),
          ),
        ],
      ),

      // ================= BOTTOM NAV ==================
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(color: Color(0xFF003B80)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: Colors.white, size: 28),
            Icon(Icons.settings, color: Colors.white, size: 28),
            Icon(Icons.person, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  // =============== DATA EXAMPLE ===============
  List<Map<String, String>> _getListData() {
    if (isRuangan) {
      return [
        {
          "title": "Ruang 06 Lantai 2 Gedung FST B",
          "tanggal": "Selasa, 14 Mei 2025",
          "waktu": "13.00 - 15.30 WIB",
          "nama": "Adit Mahardika",
        },
        {
          "title": "Laboratorium ICT. 1 Gedung FST A",
          "tanggal": "Selasa, 14 Mei 2025",
          "waktu": "10.10 - 12.40 WIB",
          "nama": "Adit Mahardika",
        },
      ];
    } else {
      return [
        {
          "title": "Laptop Lenovo Thinkpad X390",
          "tanggal": "Selasa, 14 Mei 2025",
          "waktu": "08.00 - 17.00 WIB",
          "nama": "M. Satria Pradana",
        },
      ];
    }
  }

  // =============== CARD WIDGET ===============
  Widget buildCard({
    required String title,
    required String tanggal,
    required String waktu,
    required String nama,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => KonfirmasiDetailPage(title: title)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1A55A1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // INFO COLUMN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tanggal,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(waktu, style: const TextStyle(color: Colors.white)),
                    ],
                  ),

                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(nama, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),

            // ARROW
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
