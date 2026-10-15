import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/presentation/screens/admin_login_screen.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../landing/presentation/screens/landing_screen.dart';
import '../../../prices/presentation/screens/home_screen.dart';
import '../../../poultry_market/presentation/screens/poultry_market_screen.dart';
import '../../../chicks/presentation/screens/chicks_prices_screen.dart';
import '../../../eggs/presentation/screens/eggs_prices_screen.dart';
import '../../../gallery/presentation/screens/gallery_screen.dart';
import '../widgets/desktop_sidebar.dart';

/// The two modes available in the desktop shell.
enum DesktopMode { user, admin }

/// Main desktop shell screen with sidebar navigation and
/// quick toggle between Admin Dashboard and User Screens.
///
/// This screen is exclusive to the Windows (desktop) version.
class DesktopShellScreen extends StatefulWidget {
  const DesktopShellScreen({super.key});

  @override
  State<DesktopShellScreen> createState() => _DesktopShellScreenState();
}

class _DesktopShellScreenState extends State<DesktopShellScreen> {
  DesktopMode _mode = DesktopMode.user;
  int _userTabIndex = 0;

  late final List<Widget> _userPages;

  @override
  void initState() {
    super.initState();
    _userPages = [
      LandingScreen(
        onNavigateToTab: (index) {
          if (index >= 0 && index < 6) {
            setState(() => _userTabIndex = index);
          }
        },
        onSwitchToAdmin: _switchToAdmin,
      ),
      const HomeScreen(),
      const PoultryMarketScreen(),
      const ChicksPricesScreen(),
      const EggsPricesScreen(),
      const GalleryScreen(),
    ];
  }

  void _switchToAdmin() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      setState(() => _mode = DesktopMode.admin);
    } else {
      _showAdminLoginDialog();
    }
  }

  void _switchToUser() {
    setState(() => _mode = DesktopMode.user);
  }

  void _toggleMode() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        _mode =
            _mode == DesktopMode.user ? DesktopMode.admin : DesktopMode.user;
      });
    } else {
      // If not authenticated, show login dialog
      _showAdminLoginDialog();
    }
  }

  void _showAdminLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const AdminLoginScreen(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // After successful login, switch to admin mode
          setState(() => _mode = DesktopMode.admin);
          // Close any open dialogs (login dialog)
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        } else if (state is AuthUnauthenticated) {
          // If logged out, switch back to user mode
          if (_mode == DesktopMode.admin) {
            setState(() => _mode = DesktopMode.user);
          }
        }
      },
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(
            LogicalKeyboardKey.keyA,
            control: true,
            shift: true,
          ): _toggleMode,
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: Row(
              textDirection: TextDirection.rtl,
              children: [
                // Sidebar
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    return DesktopSidebar(
                      currentMode: _mode,
                      selectedUserTab: _userTabIndex,
                      isAdminAuthenticated: authState is AuthAuthenticated,
                      onModeToggle: _toggleMode,
                      onUserTabSelected: (index) {
                        setState(() {
                          _userTabIndex = index;
                          _mode = DesktopMode.user;
                        });
                      },
                      onAdminPressed: () {
                        if (authState is AuthAuthenticated) {
                          setState(() => _mode = DesktopMode.admin);
                        } else {
                          _showAdminLoginDialog();
                        }
                      },
                    );
                  },
                ),

                // Vertical divider
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: _mode == DesktopMode.admin
                      ? AppColors.adminPrimary.withValues(alpha: 0.2)
                      : AppColors.border.withValues(alpha: 0.4),
                ),

                // Main content area
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: _mode == DesktopMode.admin
                        ? AdminDashboardScreen(
                            key: const ValueKey('admin'),
                            onSwitchToUser: _switchToUser,
                          )
                        : IndexedStack(
                            key: const ValueKey('user'),
                            index: _userTabIndex,
                            children: _userPages,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
