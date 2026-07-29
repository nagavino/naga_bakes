import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:naga_cakes/core/utils/result.dart';
import 'package:naga_cakes/features/products/domain/entities/product_entity.dart';
import 'package:naga_cakes/features/products/domain/repositories/product_repository.dart';
import 'package:naga_cakes/features/products/domain/usecases/get_products.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepo;
  late GetProducts useCase;

  setUp(() {
    mockRepo = MockProductRepository();
    useCase = GetProducts(mockRepo);
  });

  final tProductsList = [
    ProductEntity(
      id: '1',
      name: 'Filter Tea',
      price: 15.0,
      createdAt: DateTime.now(),
    ),
  ];

  test('should return list of products from repository', () async {
    when(() => mockRepo.getProducts())
        .thenAnswer((_) async => Success(tProductsList));

    final result = await useCase();

    expect(result.isSuccess, true);
    expect(result.data, tProductsList);
    verify(() => mockRepo.getProducts()).called(1);
  });
}
