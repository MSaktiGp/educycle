import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educycle/constants/colors.dart';
import 'package:educycle/screens/staf/detail.dart';

class KonfirmasiPage extends StatefulWidget {
  const KonfirmasiPage({super.key});

  @override
  State<KonfirmasiPage> createState() => _KonfirmasiPageState();
}

class _KonfirmasiPageState extends State<KonfirmasiPage> {
  bool isRuangan = true; // Filter Tab: Ruangan vs Barang

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.secondaryOrange, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Konfirmasi Peminjaman",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondaryOrange),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // ================= TAB SWITCHER (match Riwayat style) =================
          Container(
            height: 55.0,
            color: AppColors.primaryBlue,
            child: Row(
              children: [
                _tabButton(
                  "Ruangan",
                  isRuangan,
                  () => setState(() => isRuangan = true),
                ),
                _tabButton(
                  "Barang",
                  !isRuangan,
                  () => setState(() => isRuangan = false),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ================= LIST DATA LIVE =================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getPendingLoansStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Tidak ada pengajuan ${isRuangan ? 'ruangan' : 'barang'} baru.",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return _buildCard(data, doc.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIC: Ambil data pending ---
  Stream<QuerySnapshot> _getPendingLoansStream() {
    return FirebaseFirestore.instance
        .collection('peminjaman')
        .where('status', isEqualTo: 'Menunggu Persetujuan') // Hanya yg pending
        .where(
          'type',
          isEqualTo: isRuangan ? 'ruangan' : 'barang',
        ) // Filter tipe
        .orderBy('createdAt', descending: true) // Yang terbaru di atas
        .snapshots();
  }

  // --- UI COMPONENTS ---
  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.secondaryOrange : const Color(0xFFF4C981),
            border: active
                ? const Border(
                    bottom: BorderSide(color: Colors.white, width: 3),
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: active ? Colors.white : Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> data, String docId) {
    // Ambil data dengan aman
    String title = data['assetName'] ?? 'Tanpa Nama';
    String date = data['dateString'] ?? '-';
    String time = data['timeString'] ?? '-';
    String userName = data['userName'] ?? 'Mahasiswa';
    String gedung = data['building'] ?? '';

    Color statusColor = AppColors.secondaryOrange;
    final statusLabel = 'Pending';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  KonfirmasiDetailPage(loanId: docId, loanData: data),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: statusColor, width: 5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF063DA7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              if (gedung.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  gedung,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(time, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
