import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:naga_cakes/core/utils/result.dart';
import 'package:naga_cakes/features/products/domain/entities/product_entity.dart';
import 'package:naga_cakes/features/products/domain/repositories/product_repository.dart';
import 'package:naga_cakes/features/products/domain/usecases/add_product.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepo;
  late AddProduct useCase;

  setUp(() {
    mockRepo = MockProductRepository();
    useCase = AddProduct(mockRepo);
  });

  final tProduct = ProductEntity(
    id: '1',
    name: 'Filter Tea',
    price: 15.0,
    createdAt: DateTime.now(),
  );

  test('should call addProduct on repository and return Success', () async {
    when(() => mockRepo.addProduct(tProduct))
        .thenAnswer((_) async => const Success(null));

    final result = await useCase(tProduct);

    expect(result.isSuccess, true);
    verify(() => mockRepo.addProduct(tProduct)).called(1);
  });
}
