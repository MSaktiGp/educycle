import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createLoan({
    required String type, // 'barang' atau 'ruangan'
    required String assetId,
    required String assetName,
    required String building,
    required String date,
    required String time,
    String? room, // Opsional (untuk barang)
    String? additionalItems, // Opsional (untuk ruangan)
  }) async {
    try {
      // 1. Ambil User yang sedang Login
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("Anda harus login untuk melakukan peminjaman.");
      }

      // 2. Ambil Data Detail User dari Firestore (Termasuk Foto)
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw Exception("Data pengguna tidak ditemukan di database.");
      }
      
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // 3. Simpan Transaksi Peminjaman
      await _firestore.collection('peminjaman').add({
        'userId': user.uid,
        // Ambil Nama/Email dari database user agar selalu update
        'userName': userData['full_name'] ?? 'Mahasiswa', 
        'userEmail': userData['email'] ?? user.email,
        
        // --- INI KUNCI PERBAIKANNYA ---
        // Simpan foto profil saat transaksi dibuat
        'userPhotoUrl': userData['photo_url'] ?? '', 
        // ------------------------------

        'type': type,
        'assetId': assetId,
        'assetName': assetName,
        'building': building,
        'room': room ?? '-', // Jika null, simpan strip
        'additionalItems': additionalItems ?? '-',
        'dateString': date, // Format String: "25/11/2025"
        'timeString': time, // Format String: "10:00 - 12:00 WIB"
        
        'status': 'Menunggu Persetujuan', // Status Awal
        'createdAt': FieldValue.serverTimestamp(), // Waktu Server
        'rejectionReason': '-', // Default kosong
      });

    } catch (e) {
      throw Exception("Gagal mengajukan peminjaman: $e");
    }
  }
}