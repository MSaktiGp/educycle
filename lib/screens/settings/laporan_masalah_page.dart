import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import '../../services/report_service.dart'; // Import Service Baru

class LaporanMasalahPage extends StatefulWidget {
  const LaporanMasalahPage({super.key});

  @override
  State<LaporanMasalahPage> createState() => _LaporanMasalahPageState();
}

class _LaporanMasalahPageState extends State<LaporanMasalahPage> {
  final TextEditingController _laporanController = TextEditingController();
  bool _isSubmitting = false; // Status Loading

  @override
  void dispose() {
    _laporanController.dispose();
    super.dispose();
  }

  void _kirimLaporan() async {
    final text = _laporanController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true); // Mulai Loading

    try {
      // Panggil Service untuk simpan ke Firebase
      await ReportService().submitReport(text);

      if (!mounted) return;

      // Tampilkan Dialog Sukses
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    "Laporan Terkirim!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Terima kasih atas laporannya. Kami akan meninjau keluhan Anda secepatnya.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Tutup dialog
                        Navigator.pop(context); // Kembali ke settings
                      },
                      child: const Text("Kembali", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF59E0B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Laporan Masalah",
          style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sampaikan Keluhan Anda",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Text Field Laporan
            Container(
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextField(
                controller: _laporanController,
                maxLines: null, // Unlimited lines
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "Jelaskan masalah yang Anda alami secara rinci...",
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Kirim dengan Loading
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _laporanController.text.trim().isEmpty 
                      ? Colors.grey 
                      : AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: (_laporanController.text.trim().isEmpty || _isSubmitting)
                    ? null 
                    : _kirimLaporan,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Kirim Laporan",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}