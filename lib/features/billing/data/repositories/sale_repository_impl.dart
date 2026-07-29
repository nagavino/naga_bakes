import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/sale_entity.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/hive_sale_data_source.dart';
import '../models/sale_model.dart';
import '../services/pdf_invoice_service.dart';
import '../../../settings/data/datasources/hive_settings_data_source.dart';

class SaleRepositoryImpl implements SaleRepository {
  final HiveSaleDataSource saleDataSource;
  final HiveSettingsDataSource settingsDataSource;
  final PdfInvoiceService pdfInvoiceService;

  SaleRepositoryImpl({
    required this.saleDataSource,
    required this.settingsDataSource,
    required this.pdfInvoiceService,
  });

  @override
  Future<Result<SaleEntity>> checkoutSale(List<CartItemEntity> items) async {
    try {
      final settings = await settingsDataSource.getSettings();
      final currentCounter = settings.invoiceCounter;
      final invoiceNum = 'NB${currentCounter.toString().padLeft(4, '0')}';

      final uuid = const Uuid().v4();
      final now = DateTime.now();

      final saleItems = items
          .map(
            (item) => SaleItemEntity(
              productId: item.product.id,
              name: item.product.name,
              imagePath: item.product.imagePath,
              qty: item.quantity,
              priceEach: item.product.price,
              subtotal: item.subtotal,
            ),
          )
          .toList();

      final total = items.fold(0.0, (sum, i) => sum + i.subtotal);

      final saleEntity = SaleEntity(
        id: uuid,
        invoiceNumber: invoiceNum,
        timestamp: now,
        items: saleItems,
        totalAmount: total,
      );

      final model = SaleModel.fromEntity(saleEntity);
      await saleDataSource.saveSale(model);

      // Increment invoice counter
      final updatedSettings = settings.copyWith(invoiceCounter: currentCounter + 1);
      await settingsDataSource.saveSettings(updatedSettings);

      return Success(saleEntity);
    } catch (e) {
      return const ErrorResult(StorageFailure('Failed to complete checkout'));
    }
  }

  @override
  Future<Result<List<SaleEntity>>> getSales() async {
    try {
      final models = await saleDataSource.getSales();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return const ErrorResult(StorageFailure('Failed to load sales history'));
    }
  }

  @override
  Future<Result<Uint8List>> generateInvoicePdf(SaleEntity sale, {String? shopName, String? logoPath}) async {
    try {
      final pdfBytes = await pdfInvoiceService.generateInvoice(
        sale: sale,
        shopName: shopName,
        logoPath: logoPath,
      );
      return Success(pdfBytes);
    } catch (e) {
      return const ErrorResult(PdfFailure('Could not render invoice PDF'));
    }
  }
}
