import '../../domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String name;
  final String? imagePath;
  final double price;
  final bool isActive;
  final String createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    this.imagePath,
    required this.price,
    this.isActive = true,
    required this.createdAt,
  });

  factory ProductModel.fromMap(Map<dynamic, dynamic> map) {
    return ProductModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      imagePath: map['imagePath'] as String?,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: map['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'price': price,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      imagePath: imagePath,
      price: price,
      isActive: isActive,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      imagePath: entity.imagePath,
      price: entity.price,
      isActive: entity.isActive,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
