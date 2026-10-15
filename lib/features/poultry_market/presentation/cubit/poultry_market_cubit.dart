import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/poultry_market_remote_data_source.dart';
import 'poultry_market_state.dart';

class PoultryMarketCubit extends Cubit<PoultryMarketState> {
  final PoultryMarketRemoteDataSource remoteDataSource;

  PoultryMarketCubit({required this.remoteDataSource}) : super(const PoultryMarketInitial());

  Future<void> loadProducts() async {
    emit(const PoultryMarketLoading());
    try {
      final items = await remoteDataSource.getActiveProducts();
      emit(PoultryMarketLoaded(products: items, lastUpdated: DateTime.now()));
    } catch (e) {
      emit(PoultryMarketError(e.toString()));
    }
  }

  Future<void> refresh() async {
    try {
      final items = await remoteDataSource.getActiveProducts();
      emit(PoultryMarketLoaded(products: items, lastUpdated: DateTime.now()));
    } catch (_) {
      // Keep existing state on silent refresh failure
    }
  }
}
