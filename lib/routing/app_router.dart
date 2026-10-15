import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/responsive/platform_utils.dart';
import '../features/navigation/presentation/screens/main_user_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/admin_login_screen.dart';
import '../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../features/desktop/presentation/screens/desktop_shell_screen.dart';
import 'route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: PlatformUtils.isDesktop
        ? RouteNames.desktopHome
        : RouteNames.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => PlatformUtils.isDesktop
            ? const DesktopShellScreen()
            : const MainUserScreen(),
      ),
      GoRoute(
        path: RouteNames.desktopHome,
        builder: (context, state) => const DesktopShellScreen(),
      ),
      GoRoute(
        path: RouteNames.adminLogin,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text(
          'الصفحة غير موجودة',
          style: TextStyle(fontSize: 18, fontFamily: 'Tajawal'),
        ),
      ),
    ),
  );
}

