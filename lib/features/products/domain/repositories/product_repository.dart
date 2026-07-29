import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Result<List<ProductEntity>>> getProducts();
  Future<Result<void>> addProduct(ProductEntity product);
  Future<Result<void>> editProduct(ProductEntity product);
  Future<Result<void>> deleteProduct(String productId);
  Future<Result<void>> seedInitialProducts();
}
