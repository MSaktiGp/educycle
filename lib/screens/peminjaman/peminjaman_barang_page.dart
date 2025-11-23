import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';

class PeminjamanBarangPage extends StatelessWidget {
  const PeminjamanBarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // APP BAR
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF59E0B)),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Peminjaman",
          style: TextStyle(
            color: Color(0xFFF59E0B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),

       actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Color(0xFFF59E0B),
                size: 28,
              ),
              onPressed: () => Navigator.pushNamed(context, '/notification'),
            ),
          )
        ],
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Gedung
            _dropdownBox("Pilih Gedung"),

            const SizedBox(height: 12),

            // Dropdown Hari Tanggal
            _dropdownBox("Hari, Tanggal"),

            const SizedBox(height: 20),

            const Text(
              "Barang Tersedia",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // LIST BARANG
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _itemCard();
                },
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          border: const Border(
            top: BorderSide(
              color: Color(0xFFF59E0B),
              width: 3,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.primaryBlue,
          selectedItemColor: const Color(0xFFF59E0B),
          unselectedItemColor: Colors.white,
          iconSize: 35,
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
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

  // DROPDOWN UI MOCKUP (belum fungsi)
  Widget _dropdownBox(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.3),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff1A1A1A),
              )),
          const Icon(Icons.keyboard_arrow_down, size: 22),
        ],
      ),
    );
  }

  // CARD BARANG - Updated Design
  Widget _itemCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon kabel dengan warna orange
              const Icon(Icons.cable, color: Color(0xFFF59E0B), size: 28),
              const SizedBox(width: 12),
              
              // Informasi barang
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // Nama barang - warna orange
                    Text(
                      "Kabel HDMI",
                      style: TextStyle(
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2),
                    // Kode barang - warna putih
                    Text(
                      "HDMI-01-FSTB",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Barcode icon di sebelah kanan
             // Container(
               // padding: const EdgeInsets.all(6),
                //decoration: BoxDecoration(
                  //color: Colors.white,
                  //borderRadius: BorderRadius.circular(6),
                //),
               // child: const Icon(
                 // Icons.qr_code_2,
                 // color: Color(0xFF1E3A8A),
                 // size: 32,
                //),
              //),
            ],
          ),

          const SizedBox(height: 16),

          // Tombol ajukan
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
              ),
              onPressed: () {},
              child: const Text(
                "Ajukan Peminjaman",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}