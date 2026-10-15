import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_live_price.dart';
import '../../domain/usecases/get_products.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import 'prices_state.dart';

class PricesCubit extends Cubit<PricesState> {
  final GetLivePrice getLivePrice;
  final GetActiveProducts getActiveProducts;
  final ConnectivityService connectivityService;

  PricesCubit({
    required this.getLivePrice,
    required this.getActiveProducts,
    required this.connectivityService,
  }) : super(const PricesInitial());

  Future<void> loadPrices() async {
    emit(const PricesLoading());

    final isConnected = await connectivityService.isConnected();

    // Load live price
    final livePriceResult = await getLivePrice();
    final productsResult = await getActiveProducts();

    bool hasError = false;
    String errorMessage = '';
    bool isNetworkError = false;

    livePriceResult.fold(
      (failure) {
        hasError = true;
        isNetworkError = failure is NetworkFailure;
        errorMessage = failure.message;
      },
      (_) {},
    );

    if (hasError) {
      // Check if we have cached products to show offline mode
      productsResult.fold(
        (_) => emit(PricesError(message: errorMessage, isNetworkError: isNetworkError)),
        (_) => emit(PricesError(message: errorMessage, isNetworkError: isNetworkError)),
      );
      return;
    }

    livePriceResult.fold(
      (failure) => emit(PricesError(message: failure.message, isNetworkError: failure is NetworkFailure)),
      (livePrice) {
        productsResult.fold(
          (failure) => emit(PricesError(message: failure.message, isNetworkError: failure is NetworkFailure)),
          (products) => emit(PricesLoaded(
            livePrice: livePrice,
            products: products,
            isOffline: !isConnected,
            lastUpdated: DateTime.now(),
          )),
        );
      },
    );
  }

  Future<void> refreshPrices() async {
    // Keep current state visible while refreshing
    await loadPrices();
  }
}
