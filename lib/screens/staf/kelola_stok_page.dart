import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educycle/constants/colors.dart';
import 'tambah_edit_barang_page.dart'; 

class KelolaStokPage extends StatelessWidget {
  const KelolaStokPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF59E0B), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Kelola Inventaris"),
        backgroundColor: const Color(0xFF003B80), // Warna Admin
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      
      // Tombol Tambah Barang
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahEditBarangPage()),
          );
        },
        backgroundColor: const Color(0xFFFFA726),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah Barang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error memuat data"));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data?.docs ?? [];

          if (data.isEmpty) {
            return const Center(child: Text("Belum ada barang di database."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = data[index];
              final item = doc.data() as Map<String, dynamic>;
              
              return _buildStockCard(context, item, doc.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildStockCard(BuildContext context, Map<String, dynamic> item, String docId) {
    final int stock = (item['stock'] ?? 0).toInt();
    final String name = item['name'] ?? 'Tanpa Nama';
    final bool isAvailable = item['is_available'] ?? false;

    // Logika Warna Indikator Stok
    Color stockColor;
    if (stock == 0) stockColor = Colors.red;
    else if (stock < 5) stockColor = Colors.orange;
    else stockColor = Colors.green;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.inventory_2, color: AppColors.primaryBlue),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(color: stockColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text("Stok: $stock Unit", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              isAvailable ? "Status: Aktif" : "Status: Non-Aktif (Rusak/Hilang)",
              style: TextStyle(
                fontSize: 12,
                color: isAvailable ? Colors.grey : Colors.red,
                fontStyle: isAvailable ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            // Edit Mode: Kirim data yang ada
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TambahEditBarangPage(
                  docId: docId,
                  existingData: item,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}