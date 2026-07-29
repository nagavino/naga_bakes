import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class EditProduct {
  final ProductRepository repository;
  const EditProduct(this.repository);

  Future<Result<void>> call(ProductEntity product) {
    return repository.editProduct(product);
  }
}
