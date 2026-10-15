import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/eggs_remote_data_source.dart';
import 'eggs_state.dart';

class EggsCubit extends Cubit<EggsState> {
  final EggsRemoteDataSource dataSource;

  EggsCubit({required this.dataSource}) : super(const EggsInitial());

  Future<void> loadEggs() async {
    emit(const EggsLoading());
    try {
      final eggs = await dataSource.getActiveEggs();
      emit(EggsLoaded(eggs: eggs, lastUpdated: DateTime.now()));
    } catch (_) {
      emit(const EggsError('تعذر تحميل أسعار البيض حالياً'));
    }
  }

  Future<void> refreshEggs() async {
    try {
      final eggs = await dataSource.getActiveEggs();
      emit(EggsLoaded(eggs: eggs, lastUpdated: DateTime.now()));
    } catch (_) {}
  }
}
