class ServiceModel {
  final String? id;
  final String name;
  final String description;
  final String category;
  final String address;
  final String? transport;
  final double? price;
  final bool isVerified;
  final String? imageUrl;

  ServiceModel({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    this.transport,
    this.price,
    required this.isVerified,
    this.imageUrl,
  });

  // Para convertir lo que viene de Supabase a un objeto de Flutter
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      address: map['address'] ?? '',
      transport: map['transport'],
      price: map['price']?.toDouble(),
      isVerified: map['verified'] ?? false,
      imageUrl: map['image_url'],
    );
  }
}
