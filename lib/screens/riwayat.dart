import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educycle/models/user_model.dart';
import 'package:educycle/screens/detail_riwayat.dart'; 

class RiwayatPage extends StatefulWidget {
  final UserModel user;
  const RiwayatPage({super.key, required this.user});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  bool showRuangan = true; // Toggle: True = Ruangan, False = Barang

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
      ),
      body: Column(
        children: [
          // 1. TAB SWITCHER (Ruangan / Barang)
          _buildTopTabBar(),
          
          // 2. LIST DATA (Realtime dari Firebase)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getRiwayatStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data?.docs ?? [];

                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 10),
                        Text(
                          "Belum ada riwayat ${showRuangan ? 'ruangan' : 'barang'}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final doc = data[index];
                    final item = doc.data() as Map<String, dynamic>;
                    
                    return _buildHistoryCard(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIKA FILTER DATA ---
  Stream<QuerySnapshot> _getRiwayatStream() {
    Query query = FirebaseFirestore.instance.collection('peminjaman');

    // Filter Tipe (Ruangan vs Barang)
    String typeFilter = showRuangan ? 'ruangan' : 'barang';
    query = query.where('type', isEqualTo: typeFilter);

    // Filter Hak Akses (Privasi)
    // Jika BUKAN staf (Mahasiswa), hanya lihat punya sendiri.
    if (!widget.user.isStaff) {
      query = query.where('userId', isEqualTo: widget.user.uid);
    }
    // Staf/Admin melihat semuanya (tidak difilter userId)

    // Urutkan Terbaru
    query = query.orderBy('createdAt', descending: true);

    return query.snapshots();
  }

  // --- UI WIDGETS ---

  Widget _buildTopTabBar() {
    return Container(
      height: 55.0,
      color: const Color(0xFF063DA7),
      child: Row(
        children: [
          _tabButton("Ruangan", showRuangan, () => setState(() => showRuangan = true)),
          _tabButton("Barang", !showRuangan, () => setState(() => showRuangan = false)),
        ],
      ),
    );
  }

  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFF59E0B) : const Color(0xFFF4C981),
            border: active ? const Border(bottom: BorderSide(color: Colors.white, width: 3)) : null,
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

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    String title = item['assetName'] ?? 'Item Tanpa Nama';
    String time = item['timeString'] ?? '-';
    String date = item['dateString'] ?? '-';
    String status = item['status'] ?? 'Pending';
    String gedung = item['building'] ?? '';
    
    // Logika Warna Status
    Color statusColor;
    if (status == 'Disetujui') {
      statusColor = Colors.green;
    } else if (status == 'Ditolak') {
      statusColor = Colors.red;
    } else {
      statusColor = const Color(0xFFF59E0B);
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // Kirim data ke Detail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPeminjamPage(
                title: title,
                hariTanggal: date,
                waktu: time,
                status: status,
                userId: item['userId'],
                isStaff: widget.user.isStaff,
              ),
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
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF063DA7)),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Badge Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              if (gedung.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(gedung, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
              const SizedBox(height: 12),
              
              // Tampilan Tanggal & Waktu (Fixed Overflow)
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      time, 
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}