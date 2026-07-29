class SaleItemEntity {
  final String productId;
  final String name;
  final String? imagePath;
  final int qty;
  final double priceEach;
  final double subtotal;

  const SaleItemEntity({
    required this.productId,
    required this.name,
    this.imagePath,
    required this.qty,
    required this.priceEach,
    required this.subtotal,
  });
}

class SaleEntity {
  final String id;
  final String invoiceNumber;
  final DateTime timestamp;
  final List<SaleItemEntity> items;
  final double totalAmount;

  const SaleEntity({
    required this.id,
    required this.invoiceNumber,
    required this.timestamp,
    required this.items,
    required this.totalAmount,
  });
}
