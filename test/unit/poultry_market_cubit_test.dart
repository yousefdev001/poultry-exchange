import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:elshams/features/poultry_market/data/datasources/poultry_market_remote_data_source.dart';
import 'package:elshams/features/poultry_market/data/models/poultry_market_product_model.dart';
import 'package:elshams/features/poultry_market/presentation/cubit/poultry_market_cubit.dart';
import 'package:elshams/features/poultry_market/presentation/cubit/poultry_market_state.dart';

class MockPoultryMarketRemoteDataSource extends Mock
    implements PoultryMarketRemoteDataSource {}

void main() {
  late MockPoultryMarketRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPoultryMarketRemoteDataSource();
  });

  group('PoultryMarketProductModel rounding test', () {
    test('rounds up decimal prices (ceilToDouble)', () {
      final model1 = PoultryMarketProductModel.fromMap({
        'name': 'أمهات أبيض',
        'price': 85.2,
        'isActive': true,
      }, '1');
      expect(model1.price, 86.0);

      final model2 = PoultryMarketProductModel.fromMap({
        'name': 'بط مسكوفي',
        'price': 130.0,
        'isActive': true,
      }, '2');
      expect(model2.price, 130.0);

      final model3 = PoultryMarketProductModel.fromMap({
        'name': 'ديك رومي',
        'price': 140.7,
        'isActive': true,
      }, '3');
      expect(model3.price, 141.0);
    });
  });

  group('PoultryMarketCubit', () {
    final tProducts = [
      PoultryMarketProductModel(
        id: '1',
        name: 'أمهات أبيض',
        price: 86.0,
        isActive: true,
        updatedAt: DateTime(2026, 1, 1),
      ),
    ];

    test('initial state is PoultryMarketInitial', () {
      final cubit = PoultryMarketCubit(remoteDataSource: mockDataSource);
      expect(cubit.state, const PoultryMarketInitial());
    });

    blocTest<PoultryMarketCubit, PoultryMarketState>(
      'emits [Loading, Loaded] on successful load',
      build: () {
        when(() => mockDataSource.getActiveProducts())
            .thenAnswer((_) async => tProducts);
        return PoultryMarketCubit(remoteDataSource: mockDataSource);
      },
      act: (cubit) => cubit.loadProducts(),
      expect: () => [
        const PoultryMarketLoading(),
        isA<PoultryMarketLoaded>()
            .having((s) => s.products.length, 'products length', 1),
      ],
    );

    blocTest<PoultryMarketCubit, PoultryMarketState>(
      'emits [Loading, Error] on exception',
      build: () {
        when(() => mockDataSource.getActiveProducts())
            .thenThrow(Exception('Firestore error'));
        return PoultryMarketCubit(remoteDataSource: mockDataSource);
      },
      act: (cubit) => cubit.loadProducts(),
      expect: () => [
        const PoultryMarketLoading(),
        isA<PoultryMarketError>(),
      ],
    );
  });
}
