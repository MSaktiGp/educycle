import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:educycle/constants/colors.dart';
import '../../models/user_model.dart';
import '../../services/loan_service.dart';
import 'status_peminjaman_page.dart';

class DetailPeminjamanBarangArguments {
  final String itemName;
  final String itemId;
  final String itemCode;
  final String? selectedDateString;
  final String? selectedBuilding;

  DetailPeminjamanBarangArguments({
    required this.itemName,
    required this.itemId,
    required this.itemCode,
    this.selectedDateString,
    this.selectedBuilding,
  });
}

class DetailPeminjamanBarangPage extends StatefulWidget {
  final UserModel user;
  const DetailPeminjamanBarangPage({super.key, required this.user});

  @override
  State<DetailPeminjamanBarangPage> createState() =>
      _DetailPeminjamanBarangPageState();
}

class _DetailPeminjamanBarangPageState
    extends State<DetailPeminjamanBarangPage> {
  // DUA VARIABEL WAKTU (Mulai & Selesai)
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  
  late DetailPeminjamanBarangArguments _data;

  String? _selectedBuilding;
  String? _selectedRoom;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  final GlobalKey _buildingDropdownKey = GlobalKey();
  final GlobalKey _roomDropdownKey = GlobalKey();
  OverlayEntry? _buildingOverlayEntry;
  OverlayEntry? _roomOverlayEntry;

  // List Gedung tetap Hardcode sebagai Kategori Utama (Kecuali Anda punya collection 'buildings' terpisah)
  final List<String> _buildingOptions = ['Gedung FST A', 'Gedung FST B'];
  
  // HAPUS _roomsByBuilding KARENA KITA AKAN AMBIL DARI DATABASE

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final rawArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      _data = DetailPeminjamanBarangArguments(
        itemName: rawArgs['itemName'] as String,
        itemId: rawArgs['itemId'] as String,
        itemCode: rawArgs['itemCode'] as String,
        selectedDateString: rawArgs['selectedDate'] as String?,
        selectedBuilding: rawArgs['selectedBuilding'] as String?,
      );

      _selectedBuilding = _data.selectedBuilding;
      
      // Ambil Raw Date
      if (rawArgs['rawDate'] != null) {
        _selectedDate = rawArgs['rawDate'] as DateTime;
      }
    } else {
      _data = DetailPeminjamanBarangArguments(
        itemName: 'Kabel HDMI',
        itemId: 'HDMI-1',
        itemCode: 'HDMI-01-FSTB',
        selectedDateString: 'Senin, 25 November 2025',
        selectedBuilding: 'Gedung FST B',
      );
    }
  }

  String _formatDate(DateTime date) {
    // Format: dd/mm/yyyy
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _hideAllOverlays() {
    _buildingOverlayEntry?.remove();
    _buildingOverlayEntry = null;
    _roomOverlayEntry?.remove();
    _roomOverlayEntry = null;
  }

  // Dropdown Gedung (Tetap Statis / Kategori)
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
                    _selectedRoom = null; // Reset ruangan jika gedung berubah
                  });
                  _hideAllOverlays();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(building, style: TextStyle(color: isSelected ? AppColors.primaryBlue : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      if (isSelected) Icon(Icons.check, color: AppColors.primaryBlue, size: 20),
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

  // --- DROPDOWN RUANGAN (DINAMIS DARI FIREBASE) ---
  void _showRoomDropdownOverlay() {
    if (_selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih Gedung terlebih dahulu')));
      return;
    }

    _hideAllOverlays();

    final RenderBox? renderBox = _roomDropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _roomOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4.0,
        width: size.width,
        child: Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          // MENGGUNAKAN STREAM BUILDER UNTUK AMBIL DATA REALTIME
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Padding(padding: EdgeInsets.all(16), child: Text("Gagal memuat ruangan"));
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
              }

              final allRooms = snapshot.data?.docs ?? [];
              
              // FILTER MANUAL DI SINI (Karena struktur 'location' berisi string panjang)
              // Kita cari ruangan yang lokasi-nya MENGANDUNG nama gedung yang dipilih.
              final filteredRooms = allRooms.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final location = data['location']?.toString() ?? '';
                return location.contains(_selectedBuilding!); 
              }).toList();

              if (filteredRooms.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16), 
                  child: Text("Tidak ada ruangan terdaftar di gedung ini", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                );
              }

              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250), // Batasi tinggi agar bisa scroll
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: filteredRooms.length,
                  itemBuilder: (context, index) {
                    final data = filteredRooms[index].data() as Map<String, dynamic>;
                    final roomName = data['name'] ?? 'Ruangan Tanpa Nama';
                    final isSelected = _selectedRoom == roomName;

                    return InkWell(
                      onTap: () {
                        setState(() { _selectedRoom = roomName; });
                        _hideAllOverlays();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                roomName,
                                style: TextStyle(
                                  color: isSelected ? AppColors.primaryBlue : Colors.black87,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                                )
                              )
                            ),
                            if (isSelected) Icon(Icons.check, color: AppColors.primaryBlue, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_roomOverlayEntry!);
  }

  // FUNGSI PILIH WAKTU (Generic)
  Future<void> _pickTime(bool isStart) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryBlue, onPrimary: Colors.white, onSurface: Colors.black),
          ),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      setState(() {
        if (isStart) {
          _selectedStartTime = newTime;
          _selectedEndTime = null; 
        } else {
          _selectedEndTime = newTime;
        }
      });
    }
  }

  void _submitPeminjaman() async {
    if (_selectedBuilding == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi data gedung dan tanggal')));
      return;
    }
    
    // VALIDASI WAKTU
    if (_selectedStartTime == null || _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mohon isi Jam Mulai dan Jam Selesai')));
      return;
    }

    // Validasi Logika: Jam Selesai harus setelah Jam Mulai
    final double startDouble = _selectedStartTime!.hour + _selectedStartTime!.minute / 60.0;
    final double endDouble = _selectedEndTime!.hour + _selectedEndTime!.minute / 60.0;

    if (endDouble <= startDouble) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jam Selesai harus lebih besar dari Jam Mulai')));
      return;
    }

    // Format Waktu Range
    final timeString = "${_selectedStartTime!.format(context)} - ${_selectedEndTime!.format(context)} WIB";

    setState(() => _isSubmitting = true);

    try {
      await LoanService().createLoan(
        type: 'barang',
        assetId: _data.itemId,
        assetName: _data.itemName,
        building: _selectedBuilding!,
        date: _formatDate(_selectedDate!),
        time: timeString, // Waktu hasil pilihan user
        room: _selectedRoom,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 60, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text('Berhasil!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Peminjaman berhasil diajukan.', textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatusPeminjamanPage(user: widget.user),
                            settings: RouteSettings(
                              arguments: {
                                'type': 'barang',
                                'itemName': _data.itemName,
                                'itemCode': _data.itemCode,
                                'building': _selectedBuilding,
                                'room': _selectedRoom,
                                'date': _formatDate(_selectedDate!),
                                'time': timeString,
                                'status': 'Menunggu Persetujuan',
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text('Lihat Status', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // WIDGET UI INPUT WAKTU (DUA KOLOM)
  Widget _buildTimeRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text("Durasi Peminjaman", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        ),
        Row(
          children: [
            // JAM MULAI
            Expanded(
              child: InkWell(
                onTap: () => _pickTime(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedStartTime?.format(context) ?? "Mulai",
                        style: TextStyle(fontWeight: FontWeight.w600, color: _selectedStartTime == null ? Colors.grey : Colors.black87),
                      ),
                      const Icon(Icons.access_time, size: 20, color: AppColors.primaryBlue),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("-", style: TextStyle(fontWeight: FontWeight.bold))),
            // JAM SELESAI
            Expanded(
              child: InkWell(
                onTap: () => _pickTime(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedEndTime?.format(context) ?? "Selesai",
                        style: TextStyle(fontWeight: FontWeight.w600, color: _selectedEndTime == null ? Colors.grey : Colors.black87),
                      ),
                      const Icon(Icons.access_time_filled, size: 20, color: AppColors.primaryBlue),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Helper UI Dropdown
  Widget _buildDropdownField(String label, String hintText, {VoidCallback? onTap, GlobalKey? key}) {
    final String displayText = label.isNotEmpty ? label : hintText;
    final bool isPlaceholder = label.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(hintText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        ),
        InkWell(
          key: key,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryBlue, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(displayText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isPlaceholder ? Colors.grey.shade600 : const Color(0xff1A1A1A)))),
                const Icon(Icons.keyboard_arrow_down, size: 24),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // HELPER BOTTOM NAVBAR
  Widget _buildBottomNavigationBar(BuildContext context, Color primaryColor, Color accentColor) {
    return Container(
      decoration: BoxDecoration(color: primaryColor, border: Border(top: BorderSide(color: accentColor, width: 3))),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: BottomNavigationBar(
          backgroundColor: primaryColor,
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.white,
          iconSize: 40,
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) { if(index==0) Navigator.of(context).popUntil((route) => route.isFirst); },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF59E0B), size: 28), onPressed: () => Navigator.pop(context)),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text('Peminjaman', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: GestureDetector(
        onTap: _hideAllOverlays,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdownField(_data.itemCode, 'Barang', onTap: () {}),
              _buildDropdownField(_selectedBuilding ?? '', 'Gedung', onTap: _showBuildingDropdownOverlay, key: _buildingDropdownKey),
              _buildDropdownField(_selectedRoom ?? '', 'Ruangan', onTap: _showRoomDropdownOverlay, key: _roomDropdownKey),
              _buildDropdownField(_selectedDate != null ? _formatDate(_selectedDate!) : '', 'Hari, Tanggal', onTap: () async {
                _hideAllOverlays();
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  builder: (context, child) => Theme(data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: AppColors.primaryBlue, onPrimary: Colors.white, onSurface: Colors.black)), child: child!),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              }),
              
              _buildTimeRangePicker(),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPeminjaman,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                  child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Ajukan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, AppColors.primaryBlue, const Color(0xFFF59E0B)),
    );
  }
}