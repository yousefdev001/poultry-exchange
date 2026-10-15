import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/responsive/platform_utils.dart';
import 'core/analytics/analytics_service.dart';
import 'core/di/injection_container.dart' as di;
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/presentation/cubit/admin_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/chicks/presentation/cubit/chicks_cubit.dart';
import 'features/eggs/presentation/cubit/eggs_cubit.dart';
import 'features/poultry_market/presentation/cubit/poultry_market_cubit.dart';
import 'features/prices/presentation/cubit/prices_cubit.dart';
import 'firebase_options.dart';
import 'routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('ar', null);

  // Only lock orientation on mobile (not needed on desktop)
  if (PlatformUtils.isMobile) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  await di.setupDependencies();

  // Initialize analytics session and presence
  try {
    await sl<AnalyticsService>().initSession();
  } catch (_) {}

  runApp(const ElshamsApp());
}

class ElshamsApp extends StatelessWidget {
  const ElshamsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkCurrentUser(),
        ),
        BlocProvider<PricesCubit>(
          create: (_) => sl<PricesCubit>(),
        ),
        BlocProvider<ChicksCubit>(
          create: (_) => sl<ChicksCubit>(),
        ),
        BlocProvider<EggsCubit>(
          create: (_) => sl<EggsCubit>(),
        ),
        BlocProvider<PoultryMarketCubit>(
          create: (_) => sl<PoultryMarketCubit>(),
        ),
        BlocProvider<AdminCubit>(
          create: (_) => sl<AdminCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'أسعار دواجن الشمس',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        locale: const Locale('ar'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar')],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
