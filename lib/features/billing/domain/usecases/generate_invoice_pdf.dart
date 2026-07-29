import 'dart:typed_data';
import '../../../../core/utils/result.dart';
import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class GenerateInvoicePdf {
  final SaleRepository repository;
  const GenerateInvoicePdf(this.repository);

  Future<Result<Uint8List>> call(SaleEntity sale, {String? shopName, String? logoPath}) {
    return repository.generateInvoicePdf(sale, shopName: shopName, logoPath: logoPath);
  }
}
