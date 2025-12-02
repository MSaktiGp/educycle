import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryBlue;
    final accentColor = AppColors.secondaryOrange;

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
          currentIndex: currentIndex,
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
}
