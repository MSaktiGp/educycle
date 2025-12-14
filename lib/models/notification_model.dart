import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isImportant;
  final bool isRead;
  final Timestamp? createdAt;
  final String? userId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isImportant,
    required this.isRead,
    this.createdAt,
    this.userId,
  }); 

  factory NotificationModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      isImportant: data['is_important'] ?? false,
      isRead: data['is_read'] ?? false,
      createdAt: data['created_at'] as Timestamp?,
      userId: data['user_id'],
    );
  }
}
