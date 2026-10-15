import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:elshams/core/errors/failures.dart';
import 'package:elshams/core/network/connectivity_service.dart';
import 'package:elshams/features/prices/domain/entities/live_price.dart';
import 'package:elshams/features/prices/domain/entities/product.dart';
import 'package:elshams/features/prices/domain/usecases/get_live_price.dart';
import 'package:elshams/features/prices/domain/usecases/get_products.dart';
import 'package:elshams/features/prices/presentation/cubit/prices_cubit.dart';
import 'package:elshams/features/prices/presentation/cubit/prices_state.dart';

// ---- Mocktail Mocks (no codegen needed) ----
class MockGetLivePrice extends Mock implements GetLivePrice {}
class MockGetActiveProducts extends Mock implements GetActiveProducts {}
class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late MockGetLivePrice mockGetLivePrice;
  late MockGetActiveProducts mockGetActiveProducts;
  late MockConnectivityService mockConnectivity;

  final tLivePrice = LivePrice(
    price: 100.0,
    updatedAt: DateTime(2024, 1, 1),
    updatedBy: 'test@test.com',
  );

  final tProducts = [
    Product(
      id: '1',
      name: 'فراخ كاملة',
      multiplier: 1.60,
      increase: 25,
      isActive: true,
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
      order: 0,
    ),
  ];

  setUp(() {
    mockGetLivePrice = MockGetLivePrice();
    mockGetActiveProducts = MockGetActiveProducts();
    mockConnectivity = MockConnectivityService();
  });

  PricesCubit buildCubit() => PricesCubit(
        getLivePrice: mockGetLivePrice,
        getActiveProducts: mockGetActiveProducts,
        connectivityService: mockConnectivity,
      );

  group('PricesCubit', () {
    test('initial state is PricesInitial', () {
      expect(buildCubit().state, const PricesInitial());
    });

    blocTest<PricesCubit, PricesState>(
      'emits [Loading, Loaded] on successful load',
      build: () {
        when(() => mockConnectivity.isConnected()).thenAnswer((_) async => true);
        when(() => mockGetLivePrice()).thenAnswer((_) async => Right(tLivePrice));
        when(() => mockGetActiveProducts()).thenAnswer((_) async => Right(tProducts));
        return buildCubit();
      },
      act: (cubit) => cubit.loadPrices(),
      expect: () => [
        const PricesLoading(),
        isA<PricesLoaded>()
            .having((s) => s.livePrice, 'livePrice', tLivePrice)
            .having((s) => s.products, 'products', tProducts)
            .having((s) => s.isOffline, 'isOffline', false),
      ],
    );

    blocTest<PricesCubit, PricesState>(
      'emits [Loading, Error] on network failure with no cache',
      build: () {
        when(() => mockConnectivity.isConnected()).thenAnswer((_) async => false);
        when(() => mockGetLivePrice())
            .thenAnswer((_) async => const Left(NetworkFailure()));
        when(() => mockGetActiveProducts())
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return buildCubit();
      },
      act: (cubit) => cubit.loadPrices(),
      expect: () => [
        const PricesLoading(),
        isA<PricesError>(),
      ],
    );
  });
}

