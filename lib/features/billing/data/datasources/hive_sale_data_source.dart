import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/app_exception.dart';
import '../models/sale_model.dart';

class HiveSaleDataSource {
  static const String boxName = 'sales';

  Future<Box<Map>> _getBox() async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box<Map>(boxName);
      }
      return await Hive.openBox<Map>(boxName);
    } catch (_) {
      // Silent auto-recovery on corruption
      await Hive.deleteBoxFromDisk(boxName);
      return await Hive.openBox<Map>(boxName);
    }
  }

  Future<List<SaleModel>> getSales() async {
    try {
      final box = await _getBox();
      final sales = <SaleModel>[];
      for (final key in box.keys) {
        final val = box.get(key);
        if (val != null) {
          sales.add(SaleModel.fromMap(val));
        }
      }
      // Sort newest first
      sales.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return sales;
    } catch (_) {
      throw const StorageException('Failed to retrieve sales history');
    }
  }

  Future<void> saveSale(SaleModel sale) async {
    try {
      final box = await _getBox();
      await box.put(sale.id, sale.toMap());
    } catch (_) {
      throw const StorageException('Failed to record sale transaction');
    }
  }
}
