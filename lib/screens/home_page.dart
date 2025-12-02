import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import 'package:educycle/widgets/navbar.dart'; // Import layout navbar

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryBlue;
    final accentColor = AppColors.secondaryOrange;
    final backgroundColor = const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,

      // AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'EduCycle',
          style: TextStyle(
            color: Color(0xFFF59E0B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/notification'),
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.notifications_none,
                color: Color(0xFFF59E0B),
                size: 28,
              ),
            ),
          ),
        ],
      ),

      // Body
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

            // Card Profil
            Card(
              elevation: 5,
              shadowColor: primaryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: primaryColor, width: 1.5),
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

            // Menu Grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.90,
              children: [
                _buildMenuButton(
                  context: context,
                  icon: Icons.inventory_2,
                  label: 'Peminjaman',
                  color: primaryColor,
                  onTap: () => Navigator.pushNamed(context, '/peminjaman_main'),
                ),
                _buildMenuButton(
                  context: context,
                  icon: Icons.history,
                  label: 'Riwayat',
                  color: primaryColor,
                  onTap: () => Navigator.pushNamed(context, '/riwayat'),
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

      bottomNavigationBar: CustomBottomNav(currentIndex: 0),
    );
  }

  // Menu Button Widget
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required Color color,
    Color iconColor = Colors.white,
    Color textColor = Colors.black,
    BuildContext? context,
    VoidCallback? onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Column(
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
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
