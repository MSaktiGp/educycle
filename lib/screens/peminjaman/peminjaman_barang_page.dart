import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educycle/constants/colors.dart';
import 'package:educycle/screens/peminjaman/detail_peminjaman_barang_page.dart';
import '../../models/user_model.dart'; 

class PeminjamanBarangPage extends StatefulWidget {
  final UserModel user;
  const PeminjamanBarangPage({super.key, required this.user});

  @override
  State<PeminjamanBarangPage> createState() => _PeminjamanBarangPageState();
}

class _PeminjamanBarangPageState extends State<PeminjamanBarangPage> {
  String? _selectedBuilding;
  DateTime? _selectedDate;

  final GlobalKey _buildingDropdownKey = GlobalKey();
  OverlayEntry? _buildingOverlayEntry;

  final List<String> _buildingOptions = ['Gedung FST A', 'Gedung FST B'];

  String _formatDate(DateTime date) {
    // Format: dd/mm/yyyy
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _hideAllOverlays() {
    _buildingOverlayEntry?.remove();
    _buildingOverlayEntry = null;
  }

  void _showBuildingDropdownOverlay() {
    _hideAllOverlays();
    final RenderBox? renderBox =
        _buildingDropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _buildingOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4.0,
        width: size.width,
        child: Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildingOptions.map((building) {
              final isSelected = _selectedBuilding == building;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedBuilding = building;
                  });
                  _hideAllOverlays();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        building,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? AppColors.primaryBlue : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check, color: AppColors.primaryBlue, size: 20),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_buildingOverlayEntry!);
  }

  Widget _buildDropdownField(String label, String hintText, {VoidCallback? onTap, GlobalKey? key}) {
    final String displayText = label.isNotEmpty ? label : hintText;
    final bool isPlaceholder = label.isEmpty;

    return InkWell(
      key: key,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayText,
              style: TextStyle(
                fontSize: 16,
                color: isPlaceholder ? Colors.grey.shade600 : Colors.black87,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> data, String docId) {
    String name = data['name'] ?? 'Tanpa Nama';
    int stock = data['stock'] ?? 0;
    String category = data['category'] ?? '-';
    String code = "ITM-${docId.substring(0, 4).toUpperCase()}";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.primaryBlue,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.cable, color: Color(0xFFF59E0B), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFF59E0B)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$category • Stok: $stock",
                        style: const TextStyle(fontSize: 14, color: Color(0xFFF5F5F5)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: stock > 0
                    ? () {
                        // NAVIGASI: Kirim User + Raw Date
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPeminjamanBarangPage(
                              user: widget.user, 
                            ),
                            settings: RouteSettings(
                              arguments: {
                                'itemId': docId,
                                'itemName': name,
                                'itemCode': code,
                                'selectedDate': _selectedDate != null ? _formatDate(_selectedDate!) : null,
                                'rawDate': _selectedDate, // PENTING: Kirim objek tanggal asli
                                'selectedBuilding': _selectedBuilding,
                              },
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: Text(
                  stock > 0 ? 'Ajukan Peminjaman' : 'Stok Habis',
                  style: const TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideAllOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // KITA HAPUS SYARAT FILTER TANGGAL DISINI
    // Agar user bisa melihat barang dulu meskipun belum pilih tanggal (Opsional)
    // TAPI karena Anda ingin validasi tanggal, kita biarkan logic "IsReadyToSearch"
    // Namun kita HAPUS logic filter 'building' di dalam ListView
    final bool isReadyToSearch = _selectedDate != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF59E0B), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Peminjaman Barang',
          style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),

      body: GestureDetector(
        onTap: _hideAllOverlays,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDropdownField(
                    _selectedBuilding ?? '',
                    'Pilih Gedung',
                    onTap: _showBuildingDropdownOverlay,
                    key: _buildingDropdownKey,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    _selectedDate != null ? _formatDate(_selectedDate!) : '',
                    'Hari, Tanggal',
                    onTap: () async {
                      _hideAllOverlays();
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(primary: AppColors.primaryBlue, onPrimary: Colors.white, onSurface: Colors.black),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: !isReadyToSearch
                  ? Center(
                      child: Text(
                        'Silakan pilih Tanggal terlebih dahulu.',
                        style: TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('items')
                          .where('is_available', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return const Center(child: Text("Terjadi kesalahan memuat data."));
                        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                        final data = snapshot.data?.docs ?? [];

                        if (data.isEmpty) return const Center(child: Text("Tidak ada barang tersedia."));

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var itemData = data[index].data() as Map<String, dynamic>;
                            String docId = data[index].id;

                            // --- PERBAIKAN: HAPUS FILTER GEDUNG ---
                            // Barang biasanya bersifat universal (bisa di gedung A atau B)
                            // Jika database Anda tidak punya field 'building', kode sebelumnya akan menyembunyikan semuanya.
                            // Kita hapus kode if (...) { return SizedBox.shrink(); }
                            
                            return _buildItemCard(itemData, docId);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}