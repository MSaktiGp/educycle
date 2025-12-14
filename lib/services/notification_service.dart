import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream notifications for a specific user. If userId is null, returns global notifications.
  Stream<List<NotificationModel>> streamNotifications({String? userId}) {
    Query query = _firestore
        .collection('notifications')
        .orderBy('created_at', descending: true);
    if (userId != null) {
      query = query.where('user_id', isEqualTo: userId);
    }
    return query.snapshots().map(
      (snap) => snap.docs.map((d) => NotificationModel.fromDoc(d)).toList(),
    );
  }

  Future<void> markAsRead(String id) async {
    await _firestore.collection('notifications').doc(id).update({
      'is_read': true,
    });
  }
}
