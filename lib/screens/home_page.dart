import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryBlue;
    final accentColor = AppColors.secondaryOrange;
    final backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,

        title: const Text(
            'EduCycle',
            style: TextStyle(
                color:Color(0xFFF59E0B),
                fontWeight: FontWeight.bold,
                fontSize: 24,
            ),
        ),
        
        actions: [
          // Tombol Notifikasi
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/notification'),
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.notifications_none, color: Color(0xFFF59E0B), size: 28),
            ),
          ),
        ],
      ), 

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang,',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            Card(
              elevation: 5,
              shadowColor: primaryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Juliyando Akbar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('F1E123029'),
                          Text('Peminjam'),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.person_outline, size: 18),
                              SizedBox(width: 6),
                              Text('Mahasiswa'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/MyFoto.jpg'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.90,
              children: [
                _buildMenuButton(
                  icon: Icons.inventory_2,
                  label: 'Peminjaman',
                  color: primaryColor,
                ),
                _buildMenuButton(
                  icon: Icons.history,
                  label: 'Riwayat',
                  color: primaryColor,
                ),
                _buildMenuButton(
                  icon: Icons.hourglass_empty,
                  label: 'Akan Datang',
                  color: Colors.grey.shade300,
                  iconColor: Colors.black54,
                  textColor: Colors.black54,
                ),
                _buildMenuButton(
                  icon: Icons.hourglass_empty,
                  label: 'Akan Datang',
                  color: Colors.grey.shade300,
                  iconColor: Colors.black54,
                  textColor: Colors.black54,
                ),
                _buildMenuButton(
                  icon: Icons.hourglass_empty,
                  label: 'Akan Datang',
                  color: Colors.grey.shade300,
                  iconColor: Colors.black54,
                  textColor: Colors.black54,
                ),
                _buildMenuButton(
                  icon: Icons.hourglass_empty,
                  label: 'Akan Datang',
                  color: Colors.grey.shade300,
                  iconColor: Colors.black54,
                  textColor: Colors.black54,
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
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
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            onTap: (index) {
              // if (index == 0) {
              //   Navigator.pushReplacementNamed(context, '/home');
              // }
              if (index == 1) {
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
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required Color color,
    Color iconColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 36),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}