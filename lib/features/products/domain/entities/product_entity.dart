class ProductEntity {
  final String id;
  final String name;
  final String? imagePath;
  final double price;
  final bool isActive;
  final DateTime createdAt;

  const ProductEntity({
    required this.id,
    required this.name,
    this.imagePath,
    required this.price,
    this.isActive = true,
    required this.createdAt,
  });

  ProductEntity copyWith({
    String? id,
    String? name,
    String? imagePath,
    double? price,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
