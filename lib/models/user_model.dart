import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String job;
  final String role; 
  final String? phoneNumber; 
  final String? photoUrl; 
  final String? fcmToken; 

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.job,
    required this.role,
    this.phoneNumber,
    this.photoUrl,
    this.fcmToken,
  });

  // Factory untuk mengubah data JSON dari Firebase menjadi Object Dart
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      fullName: data['full_name'] ?? 'Tanpa Nama',
      job: data['job'] ?? '', 
      role: data['role'] ?? 'mahasiswa', 
      phoneNumber: data['phone_number'],
      photoUrl: data['photo_url'],
      fcmToken: data['fcm_token'],
    );
  }

  // Method untuk mengubah Object Dart menjadi JSON agar bisa dikirim ke Firebase
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'full_name': fullName,
      'job': job,
      'role': role,
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'fcm_token': fcmToken,
      'created_at':
          FieldValue.serverTimestamp(), // Mencatat waktu pembuatan akun
    };
  }

  // Helper untuk cek apakah user ini staf (Admin)
  bool get isStaff => role == 'staf';
}
