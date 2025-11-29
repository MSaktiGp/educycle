import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';

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
  const DetailPeminjamanBarangPage({super.key});

  @override
  State<DetailPeminjamanBarangPage> createState() =>
      _DetailPeminjamanBarangPageState();
}

class _DetailPeminjamanBarangPageState extends State<DetailPeminjamanBarangPage> {
  TimeOfDay? _selectedStartTime;
  late DetailPeminjamanBarangArguments _data;
  
  String? _selectedBuilding;
  String? _selectedRoom;
  DateTime? _selectedDate;

  final GlobalKey _buildingDropdownKey = GlobalKey();
  final GlobalKey _roomDropdownKey = GlobalKey();
  OverlayEntry? _buildingOverlayEntry;
  OverlayEntry? _roomOverlayEntry;

  final List<String> _buildingOptions = ['Gedung FST A', 'Gedung FST B'];
  final Map<String, List<String>> _roomsByBuilding = {
    'Gedung FST A': [
      'Ruang 01 Lantai 2 Gedung FST A',
      'Ruang 02 Lantai 2 Gedung FST A',
      'Ruang 03 Lantai 3 Gedung FST A',
    ],
    'Gedung FST B': [
      'Laboratorim ICT 1 FST Gedung A',
      'Ruang 08 Lantai 2 Gedung FST B',
      'Ruang 09 Lantai 2 Gedung FST B',
    ],
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final rawArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      _data = DetailPeminjamanBarangArguments(
        itemName: rawArgs['itemName'] as String,
        itemId: rawArgs['itemId'] as String,
        itemCode: rawArgs['itemCode'] as String,
        selectedDateString: rawArgs['selectedDate'] as String?,
        selectedBuilding: rawArgs['selectedBuilding'] as String?,
      );

      _selectedBuilding = _data.selectedBuilding;
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

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Senin';
      case 2: return 'Selasa';
      case 3: return 'Rabu';
      case 4: return 'Kamis';
      case 5: return 'Jumat';
      case 6: return 'Sabtu';
      case 7: return 'Minggu';
      default: return '';
    }
  }

  String _formatDate(DateTime date) {
    final dayName = _getDayName(date.weekday);
    return '$dayName, ${date.day}/${date.month}/${date.year}';
  }

  void _hideAllOverlays() {
    _buildingOverlayEntry?.remove();
    _buildingOverlayEntry = null;
    _roomOverlayEntry?.remove();
    _roomOverlayEntry = null;
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
                    _selectedRoom = null;
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

  void _showRoomDropdownOverlay() {
    if (_selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih Gedung terlebih dahulu')),
      );
      return;
    }

    _hideAllOverlays();

    final RenderBox? renderBox = _roomDropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final rooms = _roomsByBuilding[_selectedBuilding!] ?? [];

    _roomOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4.0,
        width: size.width,
        child: Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rooms.map((room) {
                  final isSelected = _selectedRoom == room;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRoom = room;
                      });
                      _hideAllOverlays();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              room,
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected ? AppColors.primaryBlue : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
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
        ),
      ),
    );

    Overlay.of(context).insert(_roomOverlayEntry!);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        final primaryColor = AppColors.primaryBlue;
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      setState(() {
        _selectedStartTime = newTime;
      });
    }
  }

  void _submitPeminjaman() {
    if (_selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Gedung')),
      );
      return;
    }

    if (_selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Ruangan')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Tanggal')),
      );
      return;
    }

    if (_selectedStartTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Jam Peminjaman')),
      );
      return;
    }

    // Tampilkan dialog notifikasi sukses
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 32,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Permintaan peminjaman telah diajukan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Mohon tunggu persetujuan dari staf.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext); // Tutup dialog
                      
                      // Navigate ke status peminjaman
                      final endTime = _selectedStartTime!.replacing(
                        hour: (_selectedStartTime!.hour + 2) % 24,
                        minute: _selectedStartTime!.minute,
                      );

                      Navigator.pushNamed(
                        context,
                        '/status_peminjaman',
                        arguments: {
                          'type': 'barang',
                          'itemName': _data.itemName,
                          'itemCode': _data.itemCode,
                          'building': _selectedBuilding,
                          'room': _selectedRoom,
                          'date': _formatDate(_selectedDate!),
                          'time': '${_selectedStartTime!.format(context)} - ${endTime.format(context)} WIB',
                          'status': 'Menunggu Persetujuan',
                        },
                      );
                    },
                    child: const Text(
                      'Lihat Status Peminjaman',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownField(
    String label,
    String hintText, {
    VoidCallback? onTap,
    GlobalKey? key,
  }) {
    final String displayText = label.isNotEmpty ? label : hintText;
    final bool isPlaceholder = label.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            hintText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
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
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isPlaceholder ? Colors.grey.shade600 : const Color(0xff1A1A1A),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 24),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTimeInputField() {
    String timeRange = "";

    if (_selectedStartTime != null) {
      final endTime = _selectedStartTime!.replacing(
        hour: (_selectedStartTime!.hour + 2) % 24,
        minute: _selectedStartTime!.minute,
      );
      timeRange = "${_selectedStartTime!.format(context)} - ${endTime.format(context)} WIB";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Jam",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        InkWell(
          onTap: _pickTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryBlue, width: 2),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeRange.isEmpty ? "Pilih Jam" : timeRange,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: timeRange.isEmpty ? Colors.grey.shade600 : const Color(0xff1A1A1A),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 24),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, Color primaryColor, Color accentColor) {
    const activeIndex = 0;

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border(
          top: BorderSide(color: accentColor, width: 3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: BottomNavigationBar(
          backgroundColor: primaryColor,
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.white,
          iconSize: 40,
          currentIndex: activeIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (index) {
            if (index == activeIndex) {
              return;
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/settings');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          },
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
  void dispose() {
    _hideAllOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryBlue;
    const accentColor = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: accentColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Peminjaman',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/notification'),
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.notifications_none, color: accentColor, size: 28),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _hideAllOverlays,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdownField(
                _data.itemCode,
                'Barang',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Barang: ${_data.itemName} (${_data.itemCode})')),
                  );
                },
              ),
              _buildDropdownField(
                _selectedBuilding ?? '',
                'Gedung',
                onTap: _showBuildingDropdownOverlay,
                key: _buildingDropdownKey,
              ),
              _buildDropdownField(
                _selectedRoom ?? '',
                'Ruangan',
                onTap: _showRoomDropdownOverlay,
                key: _roomDropdownKey,
              ),
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
                          colorScheme: ColorScheme.light(
                            primary: primaryColor,
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(foregroundColor: primaryColor),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              _buildTimeInputField(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitPeminjaman,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Ajukan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, primaryColor, accentColor),
    );
  }
}