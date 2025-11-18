import 'package:educycle/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:educycle/screens/login_page.dart';
import 'package:educycle/screens/home_page.dart';
import 'package:educycle/screens/profile_page.dart';
import 'package:educycle/screens/settings/setting_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCycle',
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/profile',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}