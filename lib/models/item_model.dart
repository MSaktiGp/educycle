class ItemModel {
  final String id;
  final String name;
  final String category;
  final int stock;
  final String description;
  final String imageUrl;
  final bool isAvailable;

  ItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.description,
    required this.imageUrl,
    required this.isAvailable,
  });

  // Factory untuk mengubah Data Firebase (Map) menjadi Object Dart
  factory ItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ItemModel(
      id: documentId,
      name: data['name'] ?? 'Tanpa Nama',
      category: data['category'] ?? 'Umum',
      stock: (data['stock'] ?? 0).toInt(), // Konversi aman ke Integer
      description: data['description'] ?? '-',
      imageUrl: data['image_url'] ?? '',
      isAvailable: data['is_available'] ?? false,
    );
  }
}