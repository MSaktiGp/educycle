import 'package:educycle/screens/detail_riwayat.dart';
import 'package:educycle/screens/peminjaman/detail_peminjaman_ruangan.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educycle/constants/colors.dart';
import 'package:educycle/widgets/navbar.dart';
import '../../models/user_model.dart'; 

class PeminjamanRuangan extends StatefulWidget {
  final UserModel user; 

  const PeminjamanRuangan({super.key, required this.user});

  @override
  State<PeminjamanRuangan> createState() => _PeminjamanRuanganState();
}

class _PeminjamanRuanganState extends State<PeminjamanRuangan> {
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
    final RenderBox? renderBox = _buildingDropdownKey.currentContext?.findRenderObject() as RenderBox?;
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

  Widget _buildRoomCard(Map<String, dynamic> data, String docId) {
    String name = data['name'] ?? 'Ruangan Tanpa Nama';
    int capacity = data['capacity'] ?? 0;
    String location = data['location'] ?? '-';

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
                const Icon(Icons.location_on, color: Color(0xFFF59E0B), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location, 
                        style: const TextStyle(
                          fontSize: 14, 
                          color: Colors.white70,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.people, color: Color(0xFFF5F5F5), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Kapasitas $capacity orang',
                            style: const TextStyle(fontSize: 14, color: Color(0xFFF5F5F5)),
                          ),
                        ],
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
                onPressed: () {                  
                  // NAVIGASI: Menggunakan push dan mengirim User + RawDate
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => DetailPeminjamanRuangan(
                        user: widget.user, 
                      ),
                      settings: RouteSettings(
                        arguments: {
                          'roomId': docId,
                          'roomName': name,
                          'capacity': capacity,
                          // Format String
                          'selectedDate': _selectedDate != null ? _formatDate(_selectedDate!) : null,
                          // Objek Asli (PENTING)
                          'rawDate': _selectedDate, 
                          'selectedBuilding': _selectedBuilding,
                        }
                      )
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: const Text(
                  'Ajukan Peminjaman',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
    // Validasi Tanggal tetap kita pakai (agar user pilih tanggal dulu)
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
          'Peminjaman Ruangan',
          style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),

      body: GestureDetector(
        onTap: _hideAllOverlays,
        child: Column(
          children: [
            // BAGIAN FILTER
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
                              textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue)),
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

            const SizedBox(height: 10),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ruangan Tersedia',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // STREAM BUILDER
            Expanded(
              child: !isReadyToSearch
                  ? Center(
                      child: Text(
                        'Pilih Tanggal dulu untuk melihat ruangan.',
                        style: TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('rooms')
                          .where('is_available', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text("Gagal memuat data."));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final data = snapshot.data?.docs ?? [];

                        // FILTER LOGIC TETAP ADA (Tapi Cerdas)
                        final filteredData = data.where((doc) {
                          var roomData = doc.data() as Map<String, dynamic>;
                          String location = roomData['location'] ?? '';
                          
                          // Kita pakai CONTAINS, bukan ==
                          // Jadi "Gedung FST A" akan cocok dengan "Gedung FST A Lt. 1"
                          if (_selectedBuilding != null) {
                            return location.contains(_selectedBuilding!); 
                          }
                          return true;
                        }).toList();

                        if (filteredData.isEmpty) {
                          return const Center(child: Text("Tidak ada ruangan di gedung ini."));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            var roomData = filteredData[index].data() as Map<String, dynamic>;
                            String docId = filteredData[index].id;
                            
                            return _buildRoomCard(roomData, docId);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0, 
        user: widget.user,
      ),
    );
  }
}