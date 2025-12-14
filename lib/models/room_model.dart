class RoomModel {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final List<String> facilities;
  final String imageUrl;
  final bool isAvailable;

  RoomModel({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.facilities,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory RoomModel.fromMap(Map<String, dynamic> data, String documentId) {
    return RoomModel(
      id: documentId,
      name: data['name'] ?? 'Ruangan Tanpa Nama',
      location: data['location'] ?? '-',
      capacity: (data['capacity'] ?? 0).toInt(),
      // Logika aman untuk mengambil Array dari Firebase
      facilities: List<String>.from(data['facilities'] ?? []),
      imageUrl: data['image_url'] ?? '',
      isAvailable: data['is_available'] ?? false,
    );
  }
}