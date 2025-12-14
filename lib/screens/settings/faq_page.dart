import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  // DAFTAR PERTANYAAN & JAWABAN (Hardcode)
  final List<Map<String, String>> _faqList = const [
    {
      "question": "Apa itu EduCycle?",
      "answer": "EduCycle adalah sistem manajemen peminjaman fasilitas dan inventaris (ruangan & barang) khusus untuk civitas akademika Fakultas Sains dan Teknologi (FST) UNJA."
    },
    {
      "question": "Bagaimana cara mengajukan peminjaman?",
      "answer": "Masuk ke menu Peminjaman (Barang/Ruangan) > Pilih Aset > Tentukan Tanggal & Jam > Klik 'Ajukan'. Status pengajuan Anda akan muncul di menu 'Status' atau 'Riwayat'."
    },
    {
      "question": "Berapa lama saya harus menunggu persetujuan?",
      "answer": "Biasanya staf kami memproses pengajuan dalam waktu 15-30 menit pada jam kerja (Senin-Jumat, 08:00 - 16:00 WIB). Jika mendesak, silakan hubungi Tata Usaha."
    },
    {
      "question": "Apakah saya bisa membatalkan peminjaman?",
      "answer": "Saat ini pembatalan hanya bisa dilakukan dengan menghubungi Admin/Staf secara langsung atau datang ke ruang inventaris sebelum waktu peminjaman dimulai."
    },
    {
      "question": "Apa yang terjadi jika saya terlambat mengembalikan?",
      "answer": "Keterlambatan akan tercatat di sistem. Akun yang sering terlambat mungkin akan dikenakan sanksi berupa penangguhan izin peminjaman sementara (Suspend)."
    },
    {
      "question": "Apakah aplikasi ini bisa dipakai di luar kampus?",
      "answer": "Ya, Anda bisa mengajukan peminjaman dari mana saja selama terhubung ke internet. Namun, pengambilan barang dan penggunaan ruangan tetap dilakukan di area kampus FST."
    },
    {
      "question": "Saya menemukan barang rusak, harus lapor ke mana?",
      "answer": "Silakan gunakan menu 'Laporan Masalah' di halaman Pengaturan untuk melaporkan kerusakan fasilitas atau kendala teknis lainnya."
    },
  ];

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
          "FAQ",
          style: TextStyle(
            color: Color(0xFFF59E0B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _faqList.length,
        itemBuilder: (context, index) {
          final item = _faqList[index];
          return _buildFAQItem(item['question']!, item['answer']!);
        },
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: AppColors.primaryBlue,
          collapsedIconColor: Colors.grey,
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          children: [
            Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}