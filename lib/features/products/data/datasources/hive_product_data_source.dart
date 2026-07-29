import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/app_exception.dart';
import '../models/product_model.dart';

class HiveProductDataSource {
  static const String boxName = 'products';

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

  Future<List<ProductModel>> getProducts() async {
    try {
      final box = await _getBox();
      final products = <ProductModel>[];
      for (final key in box.keys) {
        final val = box.get(key);
        if (val != null) {
          products.add(ProductModel.fromMap(val));
        }
      }
      return products;
    } catch (_) {
      throw const StorageException('Failed to retrieve products from local storage');
    }
  }

  Future<void> saveProduct(ProductModel product) async {
    try {
      final box = await _getBox();
      await box.put(product.id, product.toMap());
    } catch (_) {
      throw const StorageException('Failed to save product');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final box = await _getBox();
      await box.delete(productId);
    } catch (_) {
      throw const StorageException('Failed to delete product');
    }
  }
}
