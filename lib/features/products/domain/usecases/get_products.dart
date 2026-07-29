import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;
  const GetProducts(this.repository);

  Future<Result<List<ProductEntity>>> call() {
    return repository.getProducts();
  }
}
