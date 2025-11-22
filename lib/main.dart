import 'package:educycle/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:educycle/screens/login_page.dart';
import 'package:educycle/screens/home_page.dart';
import 'package:educycle/screens/profile_page.dart';
import 'package:educycle/screens/notification_page.dart';
import 'package:educycle/screens/settings/setting_page.dart';
import 'package:educycle/screens/settings/language_page.dart';
import 'package:educycle/screens/settings/faq_page.dart';
import 'package:educycle/screens/settings/laporan_masalah_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCycle',
      theme: ThemeData(primaryColor: AppColors.primaryBlue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/notification': (context) => const NotificationPage(),
        '/settings': (context) => const SettingsPage(),
        '/bahasa': (context) => const LanguagePage(),
        '/faq': (context) => const FAQPage(),
        '/laporan_masalah': (context) => const LaporanMasalahPage()
      },
    );
  }
}
