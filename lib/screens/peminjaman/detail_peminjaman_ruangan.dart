import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';

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
  const DetailPeminjamanRuangan({super.key});

  @override
  State<DetailPeminjamanRuangan> createState() =>
      _DetailPeminjamanRuanganState();
}

class _DetailPeminjamanRuanganState extends State<DetailPeminjamanRuangan> {
  TimeOfDay? _selectedStartTime;
  late DetailPeminjamanRuanganArguments _data;
  final List<String> _selectedItems = [];
  final List<String> _availableItems = [
    'Kabel HDMI',
    'Terminal Listrik',
    'Proyektor',
    'Layar Proyektor',
  ];

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
      _data = DetailPeminjamanRuanganArguments(
        roomName: 'Ruang Serbaguna A201',
        roomId: 'A201',
        selectedDateString: 'Senin, 25 November 2025',
        capacity: 50,
        selectedBuilding: 'Gedung A',
      );
    }
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
        // Waktu akhir dihitung 2 jam setelah waktu mulai
        // _selectedEndTime = newTime.replacing(
        //     hour: (newTime.hour + 2) % 24, minute: newTime.minute);
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

  void _submitPeminjaman() {
    if (_selectedStartTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Jam Peminjaman.')),
      );
      return;
    }

    final endTime = _selectedStartTime!.replacing(
        hour: (_selectedStartTime!.hour + 2) % 24,
        minute: _selectedStartTime!.minute);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Peminjaman diajukan untuk ${_data.roomName} (${_data.selectedBuilding}) pada ${_data.selectedDateString}, pukul ${_selectedStartTime!.format(context)} - ${endTime.format(context)} WIB. Barang tambahan: ${_selectedItems.isEmpty ? 'Tidak ada' : _selectedItems.join(', ')}"),
      ),
    );
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
              border: Border.all(color: Colors.grey.shade400)),
          width: double.infinity,
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 16)
      ],
    );
  }

  
  Widget _buildTimeInputField() {
    final endTime = _selectedStartTime != null
        ? _selectedStartTime!.replacing(
            hour: (_selectedStartTime!.hour + 2) % 24,
            minute: _selectedStartTime!.minute)
        : null;

    final timeRange = (_selectedStartTime != null && endTime != null)
        ? "${_selectedStartTime!.format(context)} - ${endTime.format(context)} WIB"
        : " "; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text("Jam", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        InkWell(
          onTap: _pickTime,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                timeRange,
                style: TextStyle(
                    fontSize: 16,
                    color: _selectedStartTime == null
                        ? Colors.grey.shade600
                        : Colors.black87),
              ),
            ),
          ),
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
          child: Text(
            "Barang tambahan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryBlue; 
    const accentColor = Color(0xFFF59E0B); 

    return Scaffold(
      backgroundColor: Colors.white, 

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFFF59E0B), size: 28),
          onPressed: () => Navigator.pushNamed(context, '/peminjaman_ruangan'), 
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
              child: Icon(Icons.notifications_none,
                  color: accentColor, size: 28),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildReadonlyField(
                "Ruangan", "${_data.roomName} (${_data.selectedBuilding})"),
            _buildReadonlyField("Hari, Tanggal", _data.selectedDateString),
            _buildTimeInputField(),
            _buildAdditionalItemsSection(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPeminjaman,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text(
                  "Ajukan",
                  style: TextStyle(
                      color: Colors
                          .black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar:
          _buildBottomNavigationBar(context, primaryColor, accentColor),
    );
  }
}