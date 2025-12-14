import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import 'package:educycle/widgets/navbar.dart';
import '../../models/user_model.dart';
import '../../services/loan_service.dart';
import 'status_peminjaman_page.dart'; // Import Wajib

class DetailPeminjamanRuanganArguments {
  final String roomName;
  final String roomId;
  final String selectedDateString;
  final String? selectedBuilding;
  final int capacity;

  DetailPeminjamanRuanganArguments({
    required this.roomName,
    required this.roomId,
    required this.selectedDateString,
    required this.capacity,
    this.selectedBuilding,
  });
}

class DetailPeminjamanRuangan extends StatefulWidget {
  final UserModel user;
  const DetailPeminjamanRuangan({super.key, required this.user});

  @override
  State<DetailPeminjamanRuangan> createState() =>
      _DetailPeminjamanRuanganState();
}

class _DetailPeminjamanRuanganState extends State<DetailPeminjamanRuangan> {
  // DUA WAKTU: MULAI & SELESAI
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  late DetailPeminjamanRuanganArguments _data;
  final List<String> _selectedItems = [];
  final List<String> _availableItems = [
    'Kabel HDMI',
    'Terminal Listrik',
    'Proyektor',
    'Layar Proyektor',
  ];
  
  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final rawArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      _data = DetailPeminjamanRuanganArguments(
        roomName: rawArgs['roomName'] as String,
        roomId: rawArgs['roomId'] as String,
        selectedDateString: rawArgs['selectedDate'] as String,
        capacity: rawArgs['capacity'] as int,
        selectedBuilding: rawArgs['selectedBuilding'] as String?,
      );
    } else {
      // Data Dummy untuk debug
      _data = DetailPeminjamanRuanganArguments(
        roomName: 'Ruang Serbaguna A201',
        roomId: 'A201',
        selectedDateString: 'Senin, 25 November 2025',
        capacity: 50,
        selectedBuilding: 'Gedung A',
      );
    }
  }

  // FUNGSI PICKER WAKTU (START/END)
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
          _selectedEndTime = null; // Reset end time jika start berubah
        } else {
          _selectedEndTime = newTime;
        }
      });
    }
  }

  Widget _buildItemCheckbox(String item) {
    final isChecked = _selectedItems.contains(item);

    return InkWell(
      onTap: () {
        setState(() {
          if (isChecked) {
            _selectedItems.remove(item);
          } else {
            _selectedItems.add(item);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedItems.add(item);
                    } else {
                      _selectedItems.remove(item);
                    }
                  });
                },
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Text(item, style: const TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  // --- LOGIKA TRANSAKSI ---
  void _submitPeminjaman() async {
    // Validasi Waktu Lengkap
    if (_selectedStartTime == null || _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi Jam Mulai dan Jam Selesai.')),
      );
      return;
    }

    // Validasi Logika: End harus > Start
    final double startDouble = _selectedStartTime!.hour + _selectedStartTime!.minute / 60.0;
    final double endDouble = _selectedEndTime!.hour + _selectedEndTime!.minute / 60.0;

    if (endDouble <= startDouble) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jam Selesai harus lebih besar dari Jam Mulai.')),
      );
      return;
    }

    // Format Waktu Range
    final timeString = "${_selectedStartTime!.format(context)} - ${_selectedEndTime!.format(context)} WIB";
    final additionalItemsStr = _selectedItems.isEmpty ? '-' : _selectedItems.join(', ');

    setState(() => _isSubmitting = true);

    try {
      await LoanService().createLoan(
        type: 'ruangan',
        assetId: _data.roomId,
        assetName: _data.roomName,
        building: _data.selectedBuilding ?? 'Gedung FST',
        date: _data.selectedDateString,
        time: timeString, // Gunakan hasil range
        additionalItems: additionalItemsStr,
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
                  const Icon(Icons.check_circle, size: 48, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text("Permintaan Terkirim!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      
                      // Navigasi ke Status
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatusPeminjamanPage(user: widget.user),
                          settings: RouteSettings(
                            arguments: {
                              'type': 'ruangan',
                              'roomName': _data.roomName,
                              'date': _data.selectedDateString,
                              'time': timeString,
                              'status': 'Menunggu Persetujuan',
                              'itemCode': _data.roomId,
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text("Lihat Status", style: TextStyle(color: Colors.white)),
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

  Widget _buildReadonlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          width: double.infinity,
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // WIDGET UI RANGE PICKER (GANTI PICKER LAMA)
  Widget _buildTimeRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text("Durasi Peminjaman", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedStartTime?.format(context) ?? "Mulai",
                        style: TextStyle(
                          fontSize: 15,
                          color: _selectedStartTime == null ? Colors.grey : Colors.black87
                        ),
                      ),
                      const Icon(Icons.access_time, size: 20, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("-", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            // JAM SELESAI
            Expanded(
              child: InkWell(
                onTap: () => _pickTime(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedEndTime?.format(context) ?? "Selesai",
                        style: TextStyle(
                          fontSize: 15,
                          color: _selectedEndTime == null ? Colors.grey : Colors.black87
                        ),
                      ),
                      const Icon(Icons.access_time_filled, size: 20, color: Colors.grey),
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

  Widget _buildAdditionalItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text("Barang tambahan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            children: _availableItems.map(_buildItemCheckbox).toList(),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryBlue;
    const accentColor = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF59E0B), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Peminjaman', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReadonlyField(
              "Ruangan",
              "${_data.roomName} (${_data.selectedBuilding ?? 'N/A'})",
            ),
            _buildReadonlyField("Hari, Tanggal", _data.selectedDateString),
            
            // GANTI PICKER LAMA DENGAN RANGE PICKER
            _buildTimeRangePicker(),
            
            _buildAdditionalItemsSection(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPeminjaman,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isSubmitting 
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                  : const Text("Ajukan", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNav(currentIndex: 0, user: widget.user),
    );
  }
}