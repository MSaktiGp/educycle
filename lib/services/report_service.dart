import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitReport(String content) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("Anda belum login");

      // Ambil data user agar admin tahu siapa yang melapor
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      await _firestore.collection('reports').add({
        'userId': currentUser.uid,
        'userName': userData['full_name'] ?? 'Tanpa Nama',
        'userEmail': userData['email'] ?? '-',
        'content': content, // Isi keluhan
        'createdAt': FieldValue.serverTimestamp(), // Waktu lapor
        'status': 'Open', // Status awal: Open, In Progress, Resolved
        'isRead': false, // Penanda untuk admin
      });
    } catch (e) {
      throw Exception("Gagal mengirim laporan: $e");
    }
  }
}