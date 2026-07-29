import 'dart:typed_data';
import '../../../../core/utils/result.dart';
import '../entities/cart_item_entity.dart';
import '../entities/sale_entity.dart';

abstract class SaleRepository {
  Future<Result<SaleEntity>> checkoutSale(List<CartItemEntity> items);
  Future<Result<List<SaleEntity>>> getSales();
  Future<Result<Uint8List>> generateInvoicePdf(SaleEntity sale, {String? shopName, String? logoPath});
}
