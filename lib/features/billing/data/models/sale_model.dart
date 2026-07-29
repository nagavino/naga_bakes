import '../../domain/entities/sale_entity.dart';

class SaleItemModel {
  final String productId;
  final String name;
  final String? imagePath;
  final int qty;
  final double priceEach;
  final double subtotal;

  const SaleItemModel({
    required this.productId,
    required this.name,
    this.imagePath,
    required this.qty,
    required this.priceEach,
    required this.subtotal,
  });

  factory SaleItemModel.fromMap(Map<dynamic, dynamic> map) {
    return SaleItemModel(
      productId: map['productId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      imagePath: map['imagePath'] as String?,
      qty: (map['qty'] as num?)?.toInt() ?? 1,
      priceEach: (map['priceEach'] as num?)?.toDouble() ?? 0.0,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imagePath': imagePath,
      'qty': qty,
      'priceEach': priceEach,
      'subtotal': subtotal,
    };
  }

  SaleItemEntity toEntity() {
    return SaleItemEntity(
      productId: productId,
      name: name,
      imagePath: imagePath,
      qty: qty,
      priceEach: priceEach,
      subtotal: subtotal,
    );
  }
}

class SaleModel {
  final String id;
  final String invoiceNumber;
  final String timestamp;
  final List<SaleItemModel> items;
  final double totalAmount;

  const SaleModel({
    required this.id,
    required this.invoiceNumber,
    required this.timestamp,
    required this.items,
    required this.totalAmount,
  });

  factory SaleModel.fromMap(Map<dynamic, dynamic> map) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    return SaleModel(
      id: map['id'] as String? ?? '',
      invoiceNumber: map['invoiceNumber'] as String? ?? '',
      timestamp: map['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      items: rawItems.map((e) => SaleItemModel.fromMap(e as Map)).toList(),
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'timestamp': timestamp,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
    };
  }

  SaleEntity toEntity() {
    return SaleEntity(
      id: id,
      invoiceNumber: invoiceNumber,
      timestamp: DateTime.tryParse(timestamp) ?? DateTime.now(),
      items: items.map((e) => e.toEntity()).toList(),
      totalAmount: totalAmount,
    );
  }

  factory SaleModel.fromEntity(SaleEntity entity) {
    return SaleModel(
      id: entity.id,
      invoiceNumber: entity.invoiceNumber,
      timestamp: entity.timestamp.toIso8601String(),
      items: entity.items
          .map(
            (e) => SaleItemModel(
              productId: e.productId,
              name: e.name,
              imagePath: e.imagePath,
              qty: e.qty,
              priceEach: e.priceEach,
              subtotal: e.subtotal,
            ),
          )
          .toList(),
      totalAmount: entity.totalAmount,
    );
  }
}
