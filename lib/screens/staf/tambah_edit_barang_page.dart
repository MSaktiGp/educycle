import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educycle/constants/colors.dart';

class TambahEditBarangPage extends StatefulWidget {
  final String? docId; // Jika null = Mode Tambah
  final Map<String, dynamic>? existingData;

  const TambahEditBarangPage({super.key, this.docId, this.existingData});

  @override
  State<TambahEditBarangPage> createState() => _TambahEditBarangPageState();
}

class _TambahEditBarangPageState extends State<TambahEditBarangPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  String _category = "Elektronik"; // Default
  bool _isAvailable = true;
  bool _isLoading = false;

  final List<String> _categories = ["Elektronik", "Aksesoris", "Audio", "Perlengkapan", "Lainnya"];

  @override
  void initState() {
    super.initState();
    // Jika mode Edit, isi form dengan data lama
    if (widget.existingData != null) {
      final data = widget.existingData!;
      _nameController.text = data['name'] ?? '';
      _stockController.text = (data['stock'] ?? 0).toString();
      _descController.text = data['description'] ?? '';
      _category = data['category'] ?? "Elektronik";
      _isAvailable = data['is_available'] ?? true;
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final firestore = FirebaseFirestore.instance;
      final int stock = int.parse(_stockController.text);

      final dataToSave = {
        'name': _nameController.text.trim(),
        'category': _category,
        'stock': stock,
        'description': _descController.text.trim(),
        'is_available': _isAvailable,
        'image_url': 'https://placehold.co/600x400/png?text=Barang', // Placeholder sementara
        // 'updated_at': FieldValue.serverTimestamp(),
      };

      if (widget.docId == null) {
        // MODE TAMBAH
        await firestore.collection('items').add(dataToSave);
      } else {
        // MODE EDIT
        await firestore.collection('items').doc(widget.docId).update(dataToSave);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil disimpan!")));
      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Fitur Hapus (Hanya muncul saat Edit)
  Future<void> _deleteItem() async {
    final confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Barang?"),
        content: const Text("Tindakan ini tidak bisa dibatalkan."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true && widget.docId != null) {
      setState(() => _isLoading = true);
      await FirebaseFirestore.instance.collection('items').doc(widget.docId).delete();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.docId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Barang" : "Tambah Barang Baru"),
        backgroundColor: const Color(0xFF003B80),
        foregroundColor: Colors.white,
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _deleteItem,
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NAMA BARANG
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Barang", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // ROW: STOK & KATEGORI
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Stok", border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? "Wajib" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _categories.contains(_category) ? _category : _categories[0],
                      decoration: const InputDecoration(labelText: "Kategori", border: OutlineInputBorder()),
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _category = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // DESKRIPSI
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Deskripsi", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              // SWITCH TERSEDIA
              SwitchListTile(
                title: const Text("Status Barang Tersedia"),
                subtitle: const Text("Matikan jika barang rusak/hilang"),
                value: _isAvailable,
                activeColor: Colors.green,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 30),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveData,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryOrange),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("SIMPAN DATA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}