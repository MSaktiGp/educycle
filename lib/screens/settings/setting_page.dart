import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      // APP BAR
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Pengaturan",
          style: TextStyle(
            color:Color(0xFFF59E0B),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color:Color(0xFFF59E0B)),
          ),
        ],
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _menuItem(
              title: "Bahasa",
              onTap: () {
                Navigator.pushNamed(context, "/bahasa");
              },
            ),
            const SizedBox(height: 12),

            _menuItem(
              title: "FAQ",
              onTap: () {
                Navigator.pushNamed(context, "/faq");
              },
            ),
            const SizedBox(height: 12),

            _menuItem(
              title: "Laporan Masalah",
              onTap: () {
                Navigator.pushNamed(context, "/laporan_masalah");
              },
            ),

            const Spacer(),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF4D4D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Log out",
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

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          // Border atas oranye sesuai BottomNavBar di HomePage
          border: Border(
            top: BorderSide(
              color: Color(0xFFF59E0B),
              width: 3,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.primaryBlue,
          selectedItemColor: Color(0xFFF59E0B), // Ikon 'settings' aktif
          unselectedItemColor: Colors.white,
          iconSize: 35,
          // index 1 adalah halaman settings
          currentIndex: 1, 
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (index) {
            // Logika navigasi BottomBar
            if (index == 0) {
              // Navigasi ke Home
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              // Navigasi ke Profile (jika ada)
              Navigator.pushReplacementNamed(context, '/profile');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
            // Jika index == 1, tetap di halaman ini
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

  // MENU ITEM WIDGET
  Widget _menuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryBlue, width: 1.5),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff1A1A1A),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
