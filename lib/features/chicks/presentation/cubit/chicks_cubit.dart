import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/chicks_remote_data_source.dart';
import 'chicks_state.dart';

class ChicksCubit extends Cubit<ChicksState> {
  final ChicksRemoteDataSource dataSource;

  ChicksCubit({required this.dataSource}) : super(const ChicksInitial());

  Future<void> loadChicks() async {
    emit(const ChicksLoading());
    try {
      final chicks = await dataSource.getActiveChicks();
      emit(ChicksLoaded(chicks: chicks, lastUpdated: DateTime.now()));
    } catch (_) {
      emit(const ChicksError('تعذر تحميل أسعار الكتاكيت حالياً'));
    }
  }

  Future<void> refreshChicks() async {
    try {
      final chicks = await dataSource.getActiveChicks();
      emit(ChicksLoaded(chicks: chicks, lastUpdated: DateTime.now()));
    } catch (_) {}
  }
}
