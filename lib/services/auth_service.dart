import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      // Step A: Cek Autentikasi (Apakah email/pass terdaftar di Auth?)
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step B: Cek Otorisasi (Siapa dia di Database?)
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      if (!doc.exists) {
        // Kasus langka: Terdaftar di Auth tapi datanya dihapus di Database
        await _auth.signOut();
        throw Exception("Data pengguna korup/tidak ditemukan.");
      }

      // Step C: Kembalikan data utuh
      return UserModel.fromMap(
        doc.data() as Map<String, dynamic>,
        cred.user!.uid,
      );
    } on FirebaseAuthException catch (e) {
      // Error handling spesifik
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw Exception("NIM/NIP atau Password salah.");
      }
      throw Exception("Gagal Login: ${e.message}");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
