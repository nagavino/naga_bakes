import 'package:uuid/uuid.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/hive_product_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final HiveProductDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<Result<List<ProductEntity>>> getProducts() async {
    try {
      final models = await dataSource.getProducts();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return const ErrorResult(StorageFailure('Could not load products'));
    }
  }

  @override
  Future<Result<void>> addProduct(ProductEntity product) async {
    try {
      final model = ProductModel.fromEntity(product);
      await dataSource.saveProduct(model);
      return const Success(null);
    } catch (e) {
      return const ErrorResult(StorageFailure('Could not save product'));
    }
  }

  @override
  Future<Result<void>> editProduct(ProductEntity product) async {
    try {
      final model = ProductModel.fromEntity(product);
      await dataSource.saveProduct(model);
      return const Success(null);
    } catch (e) {
      return const ErrorResult(StorageFailure('Could not update product'));
    }
  }

  @override
  Future<Result<void>> deleteProduct(String productId) async {
    try {
      await dataSource.deleteProduct(productId);
      return const Success(null);
    } catch (e) {
      return const ErrorResult(StorageFailure('Could not delete product'));
    }
  }

  @override
  Future<Result<void>> seedInitialProducts() async {
    try {
      final existing = await dataSource.getProducts();
      if (existing.isNotEmpty) {
        return const Success(null);
      }

      final initialNames = [
        'Normal Tea',
        'Black Tea',
        'Filter Tea',
        'Black Coffee',
        'Filter Coffee',
        'Green Tea',
        'Lemon Tea',
        'Bajji',
        'Vada',
        'Egg Puffs',
        'Veg Puffs',
        'Muruku',
        'Mixture',
      ];

      const uuid = Uuid();
      for (final name in initialNames) {
        final product = ProductModel(
          id: uuid.v4(),
          name: name,
          price: 0.0,
          isActive: true,
          createdAt: DateTime.now().toIso8601String(),
        );
        await dataSource.saveProduct(product);
      }
      return const Success(null);
    } catch (e) {
      return const ErrorResult(StorageFailure('Could not seed initial products'));
    }
  }
}
