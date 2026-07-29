import '../../../../core/utils/result.dart';
import '../entities/cart_item_entity.dart';
import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class CheckoutSale {
  final SaleRepository repository;
  const CheckoutSale(this.repository);

  Future<Result<SaleEntity>> call(List<CartItemEntity> items) {
    return repository.checkoutSale(items);
  }
}
