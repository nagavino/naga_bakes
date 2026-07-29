import '../../../../core/utils/result.dart';
import '../repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;
  const DeleteProduct(this.repository);

  Future<Result<void>> call(String productId) {
    return repository.deleteProduct(productId);
  }
}
