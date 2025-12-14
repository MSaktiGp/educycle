import 'package:flutter/material.dart';
import 'package:educycle/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educycle/models/notification_model.dart';
import 'package:educycle/services/notification_service.dart';
import 'package:educycle/models/user_model.dart';

class NotificationPage extends StatefulWidget {
  final UserModel? user;
  const NotificationPage({super.key, this.user});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService _service = NotificationService();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = widget.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      // 1. App Bar
      appBar: AppBar(
        // Tombol kembali (Back Button)
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFFF59E0B),
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: AppColors.secondaryOrange,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      // 2. Body: Daftar Notifikasi
      body: StreamBuilder<List<NotificationModel>>(
        stream: _service.streamNotifications(userId: _userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Belum ada notifikasi',
                  style: TextStyle(color: AppColors.textGray),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = items[index];
              return _buildNotificationCard(
                title: n.title,
                subtitle: n.body,
                isImportant: n.isImportant,
                isRedDot: !n.isRead,
                onTap: () async {
                  if (!n.isRead) {
                    await _service.markAsRead(n.id);
                  }
                  // could navigate to detail page here
                },
              );
            },
          );
        },
      ),
    );
  }

  // Widget Pembantu untuk Kartu Notifikasi
  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required bool isImportant,
    bool isRedDot = false,
    VoidCallback? onTap,
  }) {
    final cardColor = isImportant
        ? AppColors.primaryBlue
        : AppColors.backgroundLightBlue;
    final titleColor = isImportant ? Colors.white : AppColors.textDark;
    final subtitleColor = isImportant ? Colors.white70 : AppColors.textGray;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
      child: Card(
        color: cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isRedDot)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0, top: 4.0),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
