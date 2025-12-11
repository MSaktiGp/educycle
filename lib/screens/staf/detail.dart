import 'package:flutter/material.dart';

class KonfirmasiDetailPage extends StatefulWidget {
  final String title;

  const KonfirmasiDetailPage({super.key, required this.title});

  @override
  State<KonfirmasiDetailPage> createState() => _KonfirmasiDetailPageState();
}

class _KonfirmasiDetailPageState extends State<KonfirmasiDetailPage> {
  String status = "normal"; // normal, approved, rejected

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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),

      // ================= FIX BAGIAN BODY ==================
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Opacity(
                opacity: status == "normal" ? 1.0 : 0.4,
                child: detailCard(),
              ),

              const SizedBox(height: 25),

              if (status == "normal") actionButtons(),

              if (status == "approved") Center(child: approvedBox(context)),

              if (status == "rejected") Center(child: rejectedBox(context)),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      bottomNavigationBar: bottomNav(),
    );
  }

  // ================= DETAIL CARD ==================
  Widget detailCard() {
    return Container(
      width: 330,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF1A55A1),
            ),
          ),
          const SizedBox(height: 10),

          detailRow("Hari, Tanggal", "Selasa, 14 Mei 2025"),
          detailRow("Waktu", "13.00 – 15.30 WIB"),
          detailRow("Nama", "Adit Mahardika"),

          const SizedBox(height: 8),
          const Text(
            "Tambahan:",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text("• Terminal Listrik"),
          const Text("• Kabel HDMI"),
        ],
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // ================= NORMAL STATE BUTTONS ==================
  Widget actionButtons() {
    return Column(
      children: [
        const Text(
          "Setujui Peminjaman?",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TOLAK
            ElevatedButton(
              onPressed: () => setState(() => status = "rejected"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
              ),
              child: const Text(
                "Tolak",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),

            const SizedBox(width: 20),

            // SETUJU
            ElevatedButton(
              onPressed: () => setState(() => status = "approved"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
              ),
              child: const Text(
                "Setuju",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= APPROVED BOX ==================
  Widget approvedBox(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            "Peminjaman Telah Disetujui",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xFF1A55A1),
            ),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A55A1),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
            ),
            child: const Text("Kembali", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================= REJECTED BOX ==================
  Widget rejectedBox(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            "Pergi Berikan Alasan Penolakan",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xFF1A55A1),
            ),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AlasanPenolakanPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A55A1),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
            ),
            child: const Text("Ya", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================= BOTTOM NAV ==================
  Widget bottomNav() {
    return Container(
      height: 60,
      color: const Color(0xFF003B80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.settings, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}

// =============== HALAMAN ALASAN PENOLAKAN (dummy) ===============
// =============== HALAMAN ALASAN PENOLAKAN ===============
class AlasanPenolakanPage extends StatefulWidget {
  const AlasanPenolakanPage({super.key});

  @override
  State<AlasanPenolakanPage> createState() => _AlasanPenolakanPageState();
}

class _AlasanPenolakanPageState extends State<AlasanPenolakanPage> {
  final TextEditingController _controller = TextEditingController();
  bool pesanTerkirim = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003B80),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Peminjaman",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ================== FORM =====================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: pesanTerkirim
                    ? const Color(0xFFD6D9E0)
                    : const Color(0xFF003B80),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Berikan alasan Anda",
                    style: TextStyle(
                      fontSize: 16,
                      color: pesanTerkirim ? Colors.black54 : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // TextField
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    enabled: !pesanTerkirim,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: pesanTerkirim
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Tombol Kirim
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: pesanTerkirim
                          ? null
                          : () {
                              if (_controller.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Alasan tidak boleh kosong!"),
                                  ),
                                );
                                return;
                              }

                              setState(() => pesanTerkirim = true);

                              // POPUP BERHASIL
                              showDialog(
                                context: context,
                                builder: (_) => _popupSukses(context),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pesanTerkirim
                            ? Colors.grey.shade300
                            : const Color(0xFF3E8BFF),
                      ),
                      child: const Text("Kirim"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= PESAN TELAH DIKIRIM ===============
            if (pesanTerkirim)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D9E0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Pesan Telah Dikirim",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003B80),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E8BFF),
                      ),
                      child: const Text("Kembali"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),

      // ================== BOTTOM NAV =====================
      bottomNavigationBar: Container(
        height: 60,
        color: const Color(0xFF003B80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: Color(0xFFFFC727), size: 28),
            Icon(Icons.settings, color: Colors.white, size: 28),
            Icon(Icons.person_outline, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  // ====================== POPUP BERHASIL ======================
  Widget _popupSukses(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFFE7E9F0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 10),
          const Text(
            "Pesan berhasil dikirim!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E8BFF),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
