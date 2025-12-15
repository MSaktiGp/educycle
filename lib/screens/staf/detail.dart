import 'package:educycle/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KonfirmasiDetailPage extends StatefulWidget {
  final String loanId; // ID Dokumen untuk di-update
  final Map<String, dynamic> loanData; // Data untuk ditampilkan

  const KonfirmasiDetailPage({
    super.key,
    required this.loanId,
    required this.loanData,
  });

  @override
  State<KonfirmasiDetailPage> createState() => _KonfirmasiDetailPageState();
}

class _KonfirmasiDetailPageState extends State<KonfirmasiDetailPage> {
  bool _isLoading = false;
  
  // Fungsi Eksekusi Status (Approve/Reject)
  Future<void> _updateStatus(String newStatus, {String? reason}) async {
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('peminjaman')
          .doc(widget.loanId)
          .update({
        'status': newStatus, // 'Disetujui' atau 'Ditolak'
        'rejectionReason': reason ?? '-', // Simpan alasan jika ada
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // Tampilkan notifikasi sukses & kembali
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Berhasil mengubah status menjadi $newStatus")),
      );
      Navigator.pop(context); // Kembali ke list

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.loanData;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003B80),
        title: const Text("Detail Pengajuan", style: TextStyle(color: AppColors.secondaryOrange)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // KARTU DETAIL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['assetName'] ?? 'Aset',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003B80)),
                  ),
                  const Divider(height: 20),
                  
                  _detailRow("Peminjam", data['userName']),
                  _detailRow("Email/NIM", data['userEmail']),
                  const SizedBox(height: 10),
                  _detailRow("Hari, Tanggal", data['dateString']),
                  _detailRow("Waktu", data['timeString']),
                  _detailRow("Gedung", data['building']),
                  
                  if (data['type'] == 'barang' && data['room'] != null)
                    _detailRow("Digunakan di", data['room']),
                  
                  if (data['additionalItems'] != null && data['additionalItems'] != '-')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text("Tambahan:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(data['additionalItems']),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // TOMBOL AKSI
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  const Text(
                    "Tindakan Staf",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      // TOMBOL TOLAK
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Buka halaman/dialog alasan penolakan
                            _showRejectionDialog();
                          },
                          icon: const Icon(Icons.close),
                          label: const Text("Tolak"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // TOMBOL SETUJU
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _updateStatus("Disetujui"),
                          icon: const Icon(Icons.check),
                          label: const Text("Setujui"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value ?? '-', style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  // Dialog Alasan Penolakan Sederhana
  void _showRejectionDialog() {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alasan Penolakan"),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(hintText: "Contoh: Jadwal bentrok"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              if (reasonController.text.isNotEmpty) {
                _updateStatus("Ditolak", reason: reasonController.text);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Tolak", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}