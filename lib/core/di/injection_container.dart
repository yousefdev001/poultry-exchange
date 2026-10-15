import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/analytics/analytics_service.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/storage/local_cache_service.dart';
import '../../features/admin/data/datasources/admin_remote_data_source.dart';
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/usecases/create_product.dart';
import '../../features/admin/domain/usecases/get_audit_logs.dart';
import '../../features/admin/domain/usecases/toggle_product_status.dart';
import '../../features/admin/domain/usecases/update_live_price.dart';
import '../../features/admin/domain/usecases/update_product.dart';
import '../../features/admin/presentation/cubit/admin_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_admin.dart';
import '../../features/auth/domain/usecases/logout_admin.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/chicks/data/datasources/chicks_remote_data_source.dart';
import '../../features/chicks/presentation/cubit/chicks_cubit.dart';
import '../../features/eggs/data/datasources/eggs_remote_data_source.dart';
import '../../features/eggs/presentation/cubit/eggs_cubit.dart';
import '../../features/prices/data/datasources/prices_local_data_source.dart';
import '../../features/prices/data/datasources/prices_remote_data_source.dart';
import '../../features/prices/data/repositories/prices_repository_impl.dart';
import '../../features/prices/domain/repositories/prices_repository.dart';
import '../../features/prices/domain/usecases/get_live_price.dart';
import '../../features/prices/domain/usecases/get_products.dart';
import '../../features/prices/presentation/cubit/prices_cubit.dart';
import '../../features/poultry_market/data/datasources/poultry_market_remote_data_source.dart';
import '../../features/poultry_market/presentation/cubit/poultry_market_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<LocalCacheService>(() => LocalCacheService(sl()));
  sl.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService(connectivity: sl()));

  // Analytics & Presence
  sl.registerLazySingleton<AnalyticsService>(
      () => AnalyticsService(firestore: sl(), prefs: sl()));

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(auth: sl(), firestore: sl()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => LoginAdmin(sl()));
  sl.registerLazySingleton(() => LogoutAdmin(sl()));
  sl.registerFactory(
      () => AuthCubit(loginAdmin: sl(), logoutAdmin: sl(), authRepository: sl()));

  // Prices (Poultry)
  sl.registerLazySingleton<PricesRemoteDataSource>(
      () => PricesRemoteDataSourceImpl(firestore: sl()));
  sl.registerLazySingleton<PricesLocalDataSource>(
      () => PricesLocalDataSourceImpl(cacheService: sl()));
  sl.registerLazySingleton<PricesRepository>(() => PricesRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        connectivity: sl(),
      ));
  sl.registerLazySingleton(() => GetLivePrice(sl()));
  sl.registerLazySingleton(() => GetActiveProducts(sl()));
  sl.registerFactory(() => PricesCubit(
        getLivePrice: sl(),
        getActiveProducts: sl(),
        connectivityService: sl(),
      ));

  // Chicks
  sl.registerLazySingleton<ChicksRemoteDataSource>(
      () => ChicksRemoteDataSourceImpl(firestore: sl()));
  sl.registerFactory(() => ChicksCubit(dataSource: sl()));

  // Eggs
  sl.registerLazySingleton<EggsRemoteDataSource>(
      () => EggsRemoteDataSourceImpl(firestore: sl()));
  sl.registerFactory(() => EggsCubit(dataSource: sl()));

  // Poultry Market
  sl.registerLazySingleton<PoultryMarketRemoteDataSource>(
      () => PoultryMarketRemoteDataSourceImpl(firestore: sl()));
  sl.registerFactory(() => PoultryMarketCubit(remoteDataSource: sl()));

  // Admin
  sl.registerLazySingleton<AdminRemoteDataSource>(
      () => AdminRemoteDataSourceImpl(firestore: sl()));
  sl.registerLazySingleton<AdminRepository>(
      () => AdminRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => UpdateLivePrice(sl()));
  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => ToggleProductStatus(sl()));
  sl.registerLazySingleton(() => GetAuditLogs(sl()));
  sl.registerFactory(() => AdminCubit(
        getLivePrice: sl(),
        updateLivePrice: sl(),
        createProduct: sl(),
        updateProduct: sl(),
        toggleProductStatus: sl(),
        getAuditLogs: sl(),
        adminRepository: sl(),
      ));
}
