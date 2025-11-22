import 'package:educycle/screens/detail_riwayat.dart';
import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  bool showRuangan = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF063DA7),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF59E0B)),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Riwayat",
          style: TextStyle(
            color: Color(0xFFF59E0B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFFF59E0B)),
            onPressed: () {},
          ),
        ],
      ),

      // ================= BODY =================
      body: Column(
        children: [
          topTabBar(),
          Expanded(child: showRuangan ? ruanganList() : barangList()),
        ],
      ),
    );
  }

  // ================= TAB RUANGAN/BARANG =================
  Widget topTabBar() {
    return Container(
      height: 55.0,
      color: const Color(0xFF063DA7),
      // padding: const EdgeInsets.all(1),
      child: Row(
        children: [
          tabButton("Ruangan", showRuangan, () {
            setState(() => showRuangan = true);
          }),
          // const SizedBox(width: 1),
          tabButton("Barang", !showRuangan, () {
            setState(() => showRuangan = false);
          }),
        ],
      ),
    );
  }

  Widget tabButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Color(0xFFF59E0B) : Color(0xFFF4C981),
            // borderRadius: BorderRadius.circular(2),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: active ? Colors.white : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // ========================= LIST RUANGAN ================
  // ======================================================
  Widget ruanganList() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text("Hari ini", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 1),

        Divider(
          color: Colors.grey, // warna garis
          thickness: 1, // ketebalan
          height: 20, // jarak vertikal antar widget
        ),

        // 1 SEDANG DIGUNAKAN
        buildHistoryCard(
          title: "Ruang 15 Lantai 2 Gedung FST B",
          time: "13.00 – 15.30 WIB",
          status: "Sedang Digunakan",
          color: Colors.blue.shade800,
          tanggal: "Selasa, 14 Mei 2025",
          nama: "M. Sakti Guruh Pratama",
          nim: "F1E122002",
          noHp: "08123456789",
        ),

        // 2 TERLAMBAT
        buildHistoryCard(
          title: "Laboratorium ICT. 1 Gedung FST A",
          time: "10.10 – 12.40 WIB",
          status: "Terlambat",
          color: Colors.red,
          tanggal: "Selasa, 14 Mei 2025",
          nama: "Adit Mahardika",
          nim: "F1E122001",
          noHp: "08123456789",
        ),

        // 3 SELESAI
        buildHistoryCard(
          title: "Laboratorium ICT. 2 Gedung FST A",
          time: "08.00 – 10.40 WIB",
          status: "Selesai",
          color: Colors.green.shade700,
          tanggal: "Selasa, 14 Mei 2025",
          nama: "Julyiando Akbar",
          nim: "F1E122002",
          noHp: "08123456789",
        ),

        const SizedBox(height: 15),
        const Text("Kemarin", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 1),
        Divider(
          color: Colors.grey, // warna garis
          thickness: 1, // ketebalan
          height: 20, // jarak vertikal antar widget
        ),

        buildHistoryCard(
          title: "Ruang 08 Lantai 3 Gedung FST B",
          time: "13.00 – 15.30 WIB",
          status: "Selesai",
          color: Colors.green.shade700,
          tanggal: "Senin, 13 Mei 2025",
          nama: "John Doe",
          nim: "F1E122005",
          noHp: "08123456789",
        ),
      ],
    );
  }

  // ======================================================
  // ========================= LIST BARANG ================
  // ======================================================
  Widget barangList() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text("Hari ini", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 1),
        Divider(
          color: Colors.grey, // warna garis
          thickness: 1, // ketebalan
          height: 20, // jarak vertikal antar widget
        ),

        buildHistoryCard(
          title: "Proyektor 01-FSTA",
          time: "13.00 – 15.30 WIB",
          status: "Sedang Digunakan",
          color: Colors.blue.shade800,
          tanggal: "Selasa, 14 Mei 2025",
          nama: "M. Raga Putra",
          nim: "F1E122010",
          noHp: "08123456711",
        ),

        buildHistoryCard(
          title: "Kabel HDMI 02-FSTB",
          time: "10.10 – 12.40 WIB",
          status: "Terlambat",
          color: Colors.red,
          tanggal: "Selasa, 14 Mei 2025",
          nama: "Adit Mahardika",
          nim: "F1E122001",
          noHp: "08123456789",
        ),

        buildHistoryCard(
          title: "Terminal Listrik 02-FSTB",
          time: "08.00 – 10.40 WIB",
          status: "Selesai",
          color: Colors.green.shade700,
          tanggal: "Selasa, 14 Mei 2025",
          nama: "Julyiando Akbar",
          nim: "F1E122002",
          noHp: "08123456789",
        ),

        const SizedBox(height: 15),
        const Text("Kemarin", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 1),
        Divider(
          color: Colors.grey, // warna garis
          thickness: 1, // ketebalan
          height: 20, // jarak vertikal antar widget
        ),

        buildHistoryCard(
          title: "Kabel HDMI 01-FSTB",
          time: "13.00 – 15.30 WIB",
          status: "Selesai",
          color: Colors.green.shade700,
          tanggal: "Senin, 13 Mei 2025",
          nama: "Nadia Zahra",
          nim: "F1E122008",
          noHp: "08128765432",
        ),
      ],
    );
  }

  // ======================================================
  // ===================== CARD TEMPLATE ==================
  // ======================================================
  Widget buildHistoryCard({
    required String title,
    required String time,
    required String status,
    required Color color,
    required String tanggal,
    required String nama,
    required String nim,
    required String noHp,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPeminjamPage(
              title: title,
              hariTanggal: tanggal,
              waktu: time,
              status: status,
              namaPeminjam: nama,
              nim: nim,
              noHp: noHp,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ====================== TIME WITH ICON ======================
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(time, style: const TextStyle(color: Colors.white)),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(status, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
