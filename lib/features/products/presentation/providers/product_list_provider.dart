import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dependency_injection.dart';
import '../../domain/entities/product_entity.dart';

final productListProvider = StateNotifierProvider<ProductListNotifier, AsyncValue<List<ProductEntity>>>((ref) {
  return ProductListNotifier(ref);
});

class ProductListNotifier extends StateNotifier<AsyncValue<List<ProductEntity>>> {
  final Ref ref;

  ProductListNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    final repo = ref.read(productRepositoryProvider);
    await repo.seedInitialProducts();
    final result = await repo.getProducts();
    result.when(
      success: (products) => state = AsyncValue.data(products),
      error: (failure) => state = AsyncValue.error(failure, StackTrace.current),
    );
  }

  Future<bool> addProduct(ProductEntity product) async {
    final repo = ref.read(productRepositoryProvider);
    final res = await repo.addProduct(product);
    if (res.isSuccess) {
      loadProducts();
      return true;
    }
    return false;
  }

  Future<bool> editProduct(ProductEntity product) async {
    final repo = ref.read(productRepositoryProvider);
    final res = await repo.editProduct(product);
    if (res.isSuccess) {
      loadProducts();
      return true;
    }
    return false;
  }

  Future<bool> deleteProduct(String productId) async {
    final repo = ref.read(productRepositoryProvider);
    final res = await repo.deleteProduct(productId);
    if (res.isSuccess) {
      loadProducts();
      return true;
    }
    return false;
  }
}
