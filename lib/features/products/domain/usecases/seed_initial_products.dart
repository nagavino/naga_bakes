import '../../../../core/utils/result.dart';
import '../repositories/product_repository.dart';

class SeedInitialProducts {
  final ProductRepository repository;
  const SeedInitialProducts(this.repository);

  Future<Result<void>> call() {
    return repository.seedInitialProducts();
  }
}
