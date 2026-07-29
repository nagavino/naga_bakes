import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:naga_cakes/core/utils/result.dart';
import 'package:naga_cakes/features/billing/domain/entities/cart_item_entity.dart';
import 'package:naga_cakes/features/billing/domain/entities/sale_entity.dart';
import 'package:naga_cakes/features/billing/domain/repositories/sale_repository.dart';
import 'package:naga_cakes/features/billing/domain/usecases/checkout_sale.dart';
import 'package:naga_cakes/features/products/domain/entities/product_entity.dart';

class MockSaleRepository extends Mock implements SaleRepository {}

void main() {
  late MockSaleRepository mockRepo;
  late CheckoutSale useCase;

  setUp(() {
    mockRepo = MockSaleRepository();
    useCase = CheckoutSale(mockRepo);
  });

  final tCartItem = CartItemEntity(
    product: ProductEntity(
      id: 'p1',
      name: 'Filter Tea',
      price: 15.0,
      createdAt: DateTime.now(),
    ),
    quantity: 2,
  );

  final tSale = SaleEntity(
    id: 's1',
    invoiceNumber: 'NB0001',
    timestamp: DateTime.now(),
    items: const [
      SaleItemEntity(
        productId: 'p1',
        name: 'Filter Tea',
        qty: 2,
        priceEach: 15.0,
        subtotal: 30.0,
      ),
    ],
    totalAmount: 30.0,
  );

  test('should execute checkoutSale on repository successfully', () async {
    when(() => mockRepo.checkoutSale([tCartItem]))
        .thenAnswer((_) async => Success(tSale));

    final result = await useCase([tCartItem]);

    expect(result.isSuccess, true);
    expect(result.data.invoiceNumber, 'NB0001');
    expect(result.data.totalAmount, 30.0);
    verify(() => mockRepo.checkoutSale([tCartItem])).called(1);
  });
}
