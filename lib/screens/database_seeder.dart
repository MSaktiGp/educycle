import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educycle/constants/colors.dart';

class DatabaseSeeder extends StatefulWidget {
  const DatabaseSeeder({super.key});

  @override
  State<DatabaseSeeder> createState() => _DatabaseSeederState();
}

class _DatabaseSeederState extends State<DatabaseSeeder> {
  bool _isLoading = false;
  String _status = "Siap melakukan seeding data...";

  // ================= DATA BARANG (ITEMS) =================
  final List<Map<String, dynamic>> _dummyItems = [
    {
      "name": "Kabel HDMI",
      "category": "Aksesoris",
      "stock": 12,
      "description": "Kabel HDMI.",
      "image_url": "https://placehold.co/600x400/png?text=HDMI+Cable",
      "is_available": true,
    },
    {
      "name": "Speaker Portable",
      "category": "Audio",
      "stock": 1,
      "description": "Speaker portable dengan mic wireless.",
      "image_url": "https://placehold.co/600x400/png?text=Speaker",
      "is_available": true,
    },
     {
      "name": "Layar Tripod 70 Inch",
      "category": "Perlengkapan",
      "stock": 3,
      "description": "Layar proyektor portable kaki tiga.",
      "image_url": "https://placehold.co/600x400/png?text=Layar",
      "is_available": true,
    },
  ];

  // ================= DATA RUANGAN (ROOMS) =================
  final List<Map<String, dynamic>> _dummyRooms = [
    {
      "name": "Aula Utama FST",
      "location": "Gedung FST B Lt. 3",
      "capacity": 150,
      "facilities": ["AC", "Sound System", "Panggung", "Smart TV"],
      "image_url": "https://placehold.co/600x400/png?text=Aula+FST",
      "is_available": true,
    },
    {
      "name": "Laboratorium Komputasi Sains",
      "location": "Gedung FST A",
      "capacity": 40,
      "facilities": ["AC", "Smart TV"],
      "image_url": "https://placehold.co/600x400/png?text=Lab+Komputasi+Sains",
      "is_available": true,
    },
    {
      "name": "Ruang 10 Lantai 2",
      "location": "Gedung FST B",
      "capacity": 36,
      "facilities": ["AC", "Whiteboard", "Smart TV"],
      "image_url": "https://placehold.co/600x400/png?text=Ruang+Kelas",
      "is_available": true,
    },
  ];

  Future<void> _seedData() async {
    setState(() {
      _isLoading = true;
      _status = "Sedang menulis data ke Firestore...";
    });

    final firestore = FirebaseFirestore.instance;
    int successCount = 0;

    try {
      // 1. Inject Items
      for (var item in _dummyItems) {
        await firestore.collection('items').add(item);
        successCount++;
      }

      // 2. Inject Rooms
      for (var room in _dummyRooms) {
        await firestore.collection('rooms').add(room);
        successCount++;
      }

      setState(() {
        _status = "SUKSES! $successCount data berhasil ditambahkan.";
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Seeding Selesai!")),
        );
      }
    } catch (e) {
      setState(() {
        _status = "GAGAL: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Database Seeder")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload, size: 80, color: AppColors.primaryBlue),
              const SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _seedData,
                      icon: const Icon(Icons.rocket_launch),
                      label: const Text("Mulai Seeding Data"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
              const SizedBox(height: 20),
              const Text(
                "PERINGATAN: Jangan tekan tombol 2x agar data tidak duplikat.",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}