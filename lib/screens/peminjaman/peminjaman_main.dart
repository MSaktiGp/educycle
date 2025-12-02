import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import 'package:educycle/widgets/navbar.dart'; // Import layout navbar

class PeminjamanMain extends StatelessWidget {
  const PeminjamanMain({super.key});

  Widget _buildMenuButton({
    required BuildContext context, 
    required IconData icon,
    required String label,
    required Color color,
    Color iconColor = Colors.white,
    Color textColor = Colors.black,
    VoidCallback? onTap, 
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(5),
          child: Container(
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
  
  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryBlue;
    const accentColor = Color(0xFFF59E0B); 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, 
          color: Color(0xFFF59E0B),
          size: 28),
          onPressed: () => Navigator.pushNamed(context, '/home'), 
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), 
            GridView.count(
              crossAxisCount: 2, 
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.0,
              children: [
                _buildMenuButton(
                  context: context,
                  icon: Icons.inventory_2, 
                  label: 'Barang',
                  color: primaryColor, 
                  onTap: () {
                    Navigator.pushNamed(context, '/peminjaman_barang');
                  },
                ),
                
                _buildMenuButton(
                  context: context,
                  icon: Icons.home_work, 
                  label: 'Ruangan',
                  color: primaryColor, 
                  onTap: () {
                    Navigator.pushNamed(context, '/peminjaman_ruangan');
                  },
                ),
                
                _buildMenuButton(
                  context: context,
                  icon: Icons.hourglass_empty, 
                  label: 'Akan Datang',
                  color: Colors.grey.shade300,
                  iconColor: Colors.black54,
                  textColor: Colors.black54,
                ),
                
                _buildMenuButton(
                  context: context,
                  icon: Icons.hourglass_empty,
                  label: 'Akan Datang',
                  color: Colors.grey.shade300,
                  iconColor: Colors.black54,
                  textColor: Colors.black54,
                ),
                
                _buildMenuButton(
                  context: context,
                  icon: Icons.hourglass_empty,
                  label: 'Akan Datang',
                  color: Colors.grey.shade300,
                  iconColor: Colors.black54,
                  textColor: Colors.black54,
                ),
              
                _buildMenuButton(
                  context: context,
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
}