import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../landing/presentation/screens/landing_screen.dart';
import '../../../prices/presentation/screens/home_screen.dart';
import '../../../poultry_market/presentation/screens/poultry_market_screen.dart';
import '../../../chicks/presentation/screens/chicks_prices_screen.dart';
import '../../../eggs/presentation/screens/eggs_prices_screen.dart';
import '../../../gallery/presentation/screens/gallery_screen.dart';

class MainUserScreen extends StatefulWidget {
  const MainUserScreen({super.key});

  @override
  State<MainUserScreen> createState() => _MainUserScreenState();
}

class _MainUserScreenState extends State<MainUserScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      LandingScreen(
        onNavigateToTab: (index) {
          if (index >= 0 && index < 6) {
            setState(() => _currentIndex = index);
          }
        },
      ),
      const HomeScreen(),
      const PoultryMarketScreen(),
      const ChicksPricesScreen(),
      const EggsPricesScreen(),
      const GalleryScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
          border: const Border(
            top: BorderSide(color: Color(0xFFEADBCA), width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          indicatorColor: AppColors.priceBackground,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined,
                  color: AppColors.textHint, size: 22),
              selectedIcon:
                  Icon(Icons.home_rounded, color: AppColors.primary, size: 22),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined,
                  color: AppColors.textHint, size: 22),
              selectedIcon: Icon(Icons.inventory_2_rounded,
                  color: AppColors.primary, size: 22),
              label: 'أسعار الدجاج',
            ),
            NavigationDestination(
              icon: Icon(Icons.storefront_outlined,
                  color: AppColors.textHint, size: 22),
              selectedIcon: Icon(Icons.storefront_rounded,
                  color: AppColors.primary, size: 22),
              label: 'أسعار اللحم الحي',
            ),
            NavigationDestination(
              icon: Icon(Icons.cruelty_free_outlined,
                  color: AppColors.textHint, size: 22),
              selectedIcon: Icon(Icons.cruelty_free_rounded,
                  color: AppColors.primary, size: 22),
              label: 'الكتاكيت',
            ),
            NavigationDestination(
              icon:
                  Icon(Icons.egg_outlined, color: AppColors.textHint, size: 22),
              selectedIcon:
                  Icon(Icons.egg_rounded, color: AppColors.primary, size: 22),
              label: 'البيض',
            ),
            NavigationDestination(
              icon: Icon(Icons.photo_library_outlined,
                  color: AppColors.textHint, size: 22),
              selectedIcon: Icon(Icons.photo_library_rounded,
                  color: AppColors.primary, size: 22),
              label: 'المعرض',
            ),
          ],
        ),
      ),
    );
  }
}
