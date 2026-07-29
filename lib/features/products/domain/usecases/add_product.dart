import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;
  const AddProduct(this.repository);

  Future<Result<void>> call(ProductEntity product) {
    return repository.addProduct(product);
  }
}
