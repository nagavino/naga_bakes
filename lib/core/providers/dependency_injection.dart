import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/products/data/datasources/hive_product_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/billing/data/datasources/hive_sale_data_source.dart';
import '../../features/billing/data/repositories/sale_repository_impl.dart';
import '../../features/billing/data/services/pdf_invoice_service.dart';
import '../../features/billing/domain/repositories/sale_repository.dart';
import '../../features/reports/data/repositories/reports_repository_impl.dart';
import '../../features/reports/domain/repositories/reports_repository.dart';
import '../../features/settings/data/datasources/hive_settings_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';

// Data Sources
final hiveProductDataSourceProvider = Provider((ref) => HiveProductDataSource());
final hiveSaleDataSourceProvider = Provider((ref) => HiveSaleDataSource());
final hiveSettingsDataSourceProvider = Provider((ref) => HiveSettingsDataSource());
final pdfInvoiceServiceProvider = Provider((ref) => PdfInvoiceService());

// Repositories
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.watch(hiveProductDataSourceProvider);
  return ProductRepositoryImpl(dataSource);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final dataSource = ref.watch(hiveSettingsDataSourceProvider);
  return SettingsRepositoryImpl(dataSource);
});

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  return SaleRepositoryImpl(
    saleDataSource: ref.watch(hiveSaleDataSourceProvider),
    settingsDataSource: ref.watch(hiveSettingsDataSourceProvider),
    pdfInvoiceService: ref.watch(pdfInvoiceServiceProvider),
  );
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepositoryImpl(ref.watch(hiveSaleDataSourceProvider));
});
