import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';

class PeminjamanRuangan extends StatefulWidget {
  const PeminjamanRuangan({super.key});

  @override
  State<PeminjamanRuangan> createState() => _PeminjamanRuanganState();
}

class _PeminjamanRuanganState extends State<PeminjamanRuangan> {
  String? _selectedBuilding;
  DateTime? _selectedDate;

  final GlobalKey _buildingDropdownKey = GlobalKey();
  OverlayEntry? _buildingOverlayEntry;
  final List<String> _buildingOptions = ['Gedung FST A', 'Gedung FST B'];

  final List<Map<String, dynamic>> availableRooms = [
    {'name': 'Ruang 08 Lantai 2 Gedung FST B', 'capacity': 30, 'id': 'B208-1'},
    {'name': 'Ruang 09 Lantai 2 Gedung FST B', 'capacity': 25, 'id': 'B209-2'},
    {'name': 'Ruang 01 Lantai 3 Gedung FST B', 'capacity': 50, 'id': 'A301-3'},
    {'name': 'Ruang 02 Lantai 3 Gedung FST B', 'capacity': 40, 'id': 'A302-4'},
  ];

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  String _formatDate(DateTime date) {
    final dayName = _getDayName(date.weekday);
    return '$dayName, ${date.day}/${date.month}/${date.year}';
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        building,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? AppColors.primaryBlue
                              : Colors.black87,
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

  Widget _buildBottomNavigationBar(
      BuildContext context, Color primaryColor, Color accentColor) {
    const activeIndex = 0;

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border(
          top: BorderSide(
            color: accentColor,
            width: 3,
          ),
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

  Widget _buildDropdownField(
      String label, String hintText, {VoidCallback? onTap, GlobalKey? key}) {
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
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

  Widget _buildRoomCard(String roomName, int capacity, String roomId) {
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
                        roomName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person,
                              color: Color(0xFFF5F5F5), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Kapasitas $capacity orang',
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFFF5F5F5)),
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
                  Navigator.pushNamed(
                    context, '/detail_peminjaman_ruangan',
                    arguments: {
                      'roomId': roomId,
                      'roomName': roomName,
                      'capacity': capacity,
                      'selectedDate': _selectedDate != null ? _formatDate(_selectedDate!) : null,
                      'selectedBuilding': _selectedBuilding,
                    },
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
    final primaryColor = AppColors.primaryBlue;
    const accentColor = Color(0xFFF59E0B);
    final bool allFiltersSelected = _selectedBuilding != null && _selectedDate != null;

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
            onTap: () {
              Navigator.pushNamed(context, '/notification');
            },

            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.notifications_none, color: accentColor, size: 28),
            ),
          ),
        ],
      ),


      body: GestureDetector(
        onTap: () {
          _hideAllOverlays();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          colorScheme: ColorScheme.light(
                            primary: primaryColor,
                            onPrimary: Colors.white,
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
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),

              const SizedBox(height: 24),
              const Text(
                'Ruangan Tersedia',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333)),
              ),

              const SizedBox(height: 16),
              if (!allFiltersSelected)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Silakan pilih Gedung dan Tanggal terlebih dahulu untuk melihat ruangan yang tersedia.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                )
              else
                ...availableRooms
                    .where((room) => room['name']
                        .toString()
                        .contains(_selectedBuilding!.split(' ').last))
                    .map((room) => _buildRoomCard(
                          room['name'] as String,
                          room['capacity'] as int,
                          room['id'] as String,
                        ))
            ],
          ),
        ),
      ),

      bottomNavigationBar:
          _buildBottomNavigationBar(context, primaryColor, accentColor),
    );
  }
}