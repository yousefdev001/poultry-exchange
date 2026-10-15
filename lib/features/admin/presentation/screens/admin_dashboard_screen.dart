import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../routing/route_names.dart';
import '../../../../core/responsive/platform_utils.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../chicks/data/datasources/chicks_remote_data_source.dart';
import '../../../chicks/data/models/chick_product_model.dart';
import '../../../chicks/domain/entities/chick_product.dart';
import '../../../chicks/presentation/cubit/chicks_cubit.dart';
import '../../../eggs/data/datasources/eggs_remote_data_source.dart';
import '../../../eggs/data/models/egg_product_model.dart';
import '../../../eggs/domain/entities/egg_product.dart';
import '../../../eggs/presentation/cubit/eggs_cubit.dart';
import '../../../prices/domain/entities/product.dart';
import '../../../prices/presentation/cubit/prices_cubit.dart';
import '../cubit/admin_cubit.dart';
import '../cubit/admin_state.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/audit_log_tile.dart';
import '../widgets/product_admin_tile.dart';
import '../widgets/add_edit_product_sheet.dart';
import '../widgets/add_edit_chick_sheet.dart';
import '../../../poultry_market/data/datasources/poultry_market_remote_data_source.dart';
import '../../../poultry_market/data/models/poultry_market_product_model.dart';
import '../../../poultry_market/domain/entities/poultry_market_product.dart';
import '../../../poultry_market/presentation/cubit/poultry_market_cubit.dart';
import '../widgets/add_edit_market_sheet.dart';
import '../widgets/add_edit_egg_sheet.dart';

class AdminDashboardScreen extends StatefulWidget {
  final VoidCallback? onSwitchToUser;
  const AdminDashboardScreen({super.key, this.onSwitchToUser});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  String _adminPoultryCategory = 'frozen';
  String _adminChicksCategory = 'fattening';
  List<ChickProductModel> _allChicks = [];
  List<EggProductModel> _allEggs = [];
  List<PoultryMarketProductModel> _allMarketProducts = [];
  bool _isLoadingChicks = false;
  bool _isLoadingEggs = false;
  bool _isLoadingMarket = false;
  String? _chicksError;
  String? _eggsError;
  String? _marketError;
  AdminLoaded? _lastLoaded;

  late final AnalyticsService _analyticsService;

  @override
  void initState() {
    super.initState();
    _analyticsService = sl<AnalyticsService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAll();
    });
  }

  void _refreshAll() {
    if (!mounted) return;
    context.read<AdminCubit>().loadDashboard();
    _loadChicks();
    _loadEggs();
    _loadMarket();
  }

  Future<void> _loadChicks() async {
    setState(() {
      _isLoadingChicks = true;
      _chicksError = null;
    });
    try {
      final chicks = await sl<ChicksRemoteDataSource>().getAllChicks();
      if (mounted) setState(() => _allChicks = chicks);
    } catch (e) {
      if (mounted) setState(() => _chicksError = e.toString());
    }
    if (mounted) setState(() => _isLoadingChicks = false);
  }

  Future<void> _loadEggs() async {
    setState(() {
      _isLoadingEggs = true;
      _eggsError = null;
    });
    try {
      final eggs = await sl<EggsRemoteDataSource>().getAllEggs();
      if (mounted) setState(() => _allEggs = eggs);
    } catch (e) {
      if (mounted) setState(() => _eggsError = e.toString());
    }
    if (mounted) setState(() => _isLoadingEggs = false);
  }

  Future<void> _loadMarket() async {
    setState(() {
      _isLoadingMarket = true;
      _marketError = null;
    });
    try {
      final products =
          await sl<PoultryMarketRemoteDataSource>().getAllProducts();
      if (mounted) setState(() => _allMarketProducts = products);
    } catch (e) {
      if (mounted) setState(() => _marketError = e.toString());
    }
    if (mounted) setState(() => _isLoadingMarket = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminLoaded) {
          setState(() => _lastLoaded = state);
        }
        if (state is AdminOperationSuccess) {
          AppSnackbar.showSuccess(context, state.message);
          context.read<PricesCubit>().loadPrices();
          _loadChicks();
          _loadEggs();
          _loadMarket();
        }
        if (state is AdminError) {
          AppSnackbar.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.adminBackground,
        appBar: _buildAppBar(context),
        bottomNavigationBar: _buildBottomNav(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    String title = 'لوحة التحكم والإحصائيات';
    if (_selectedIndex == 1) title = 'إدارة أسعار الدجاج';
    if (_selectedIndex == 2) title = 'إدارة أسعار اللحم الحي';
    if (_selectedIndex == 3) title = 'إدارة أسعار الكتاكيت';
    if (_selectedIndex == 4) title = 'إدارة أسعار البيض';

    return AppBar(
      backgroundColor: AppColors.adminSurface,
      title: Text(
        title,
        style: AppTextStyles.headlineSmall
            .copyWith(color: AppColors.primary, fontSize: 18),
      ),
      actions: [
        if (PlatformUtils.isDesktop && widget.onSwitchToUser != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.storefront_rounded, size: 18),
              label: const Text(
                'واجهة المستخدم',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              onPressed: widget.onSwitchToUser,
            ),
          ),
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
          tooltip: 'تحديث',
          onPressed: _refreshAll,
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: AppColors.primary),
          tooltip: AppStrings.logout,
          onPressed: () async {
            final confirmed = await ConfirmationDialog.show(
              context,
              title: AppStrings.confirmLogoutTitle,
              message: AppStrings.confirmLogoutBody,
              confirmLabel: AppStrings.logout,
              icon: Icons.logout_rounded,
            );
            if (confirmed && context.mounted) {
              await context.read<AuthCubit>().logout();
              if (context.mounted) {
                context.go(PlatformUtils.isDesktop ? RouteNames.desktopHome : RouteNames.home);
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      backgroundColor: AppColors.adminSurface,
      indicatorColor: AppColors.primary.withValues(alpha: 0.25),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (i) => setState(() => _selectedIndex = i),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined, color: AppColors.textHint),
          selectedIcon: Icon(Icons.analytics_rounded, color: AppColors.primary),
          label: 'الداش بورد',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined, color: AppColors.textHint),
          selectedIcon:
              Icon(Icons.inventory_2_rounded, color: AppColors.primary),
          label: 'أسعار الدجاج',
        ),
        NavigationDestination(
          icon: Icon(Icons.storefront_outlined, color: AppColors.textHint),
          selectedIcon:
              Icon(Icons.storefront_rounded, color: AppColors.primary),
          label: 'أسعار اللحم الحي',
        ),
        NavigationDestination(
          icon: Icon(Icons.cruelty_free_outlined, color: AppColors.textHint),
          selectedIcon:
              Icon(Icons.cruelty_free_rounded, color: AppColors.primary),
          label: 'الكتاكيت',
        ),
        NavigationDestination(
          icon: Icon(Icons.egg_outlined, color: AppColors.textHint),
          selectedIcon: Icon(Icons.egg_rounded, color: AppColors.primary),
          label: 'البيض',
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardOverview();
      case 1:
        return _buildPoultryManagementTab();
      case 2:
        return _buildMarketManagementTab();
      case 3:
        return _buildChicksManagementTab();
      case 4:
        return _buildEggsManagementTab();
      default:
        return _buildDashboardOverview();
    }
  }

  Widget _buildDashboardOverview() {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final loaded = (state is AdminLoaded ? state : null) ??
            _lastLoaded ??
            const AdminLoaded();
        final isLoading = state is AdminLoading && _lastLoaded == null;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => _refreshAll(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isLoading) ...[
                  const LinearProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Text(
                  'إحصائيات وزيارات التطبيق الحية',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<int>(
                        stream: _analyticsService.getOnlineUsersCount(),
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 1;
                          return _buildMetricCard(
                            title: 'المتصلين الآن',
                            value: '$count',
                            icon: Icons.person_pin_circle_rounded,
                            color: const Color(0xFF00E676),
                            isLive: true,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: StreamBuilder<int>(
                        stream: _analyticsService.getTodayVisits(),
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return _buildMetricCard(
                            title: 'زيارات اليوم',
                            value: '$count',
                            icon: Icons.today_rounded,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: StreamBuilder<int>(
                        stream: _analyticsService.getMonthlyVisits(),
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return _buildMetricCard(
                            title: 'زيارات الشهر',
                            value: '$count',
                            icon: Icons.calendar_view_month_rounded,
                            color: AppColors.secondary,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'ملخص أصناف البورصة',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AdminStatCard(
                        title: 'أسعار الدجاج',
                        value: '${loaded.products.length}',
                        icon: Icons.inventory_2_rounded,
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AdminStatCard(
                        title: 'أسعار اللحم الحي',
                        value: '${_allMarketProducts.length}',
                        icon: Icons.storefront_rounded,
                        onTap: () => setState(() => _selectedIndex = 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AdminStatCard(
                        title: 'أصناف الكتاكيت',
                        value: '${_allChicks.length}',
                        icon: Icons.cruelty_free_rounded,
                        onTap: () => setState(() => _selectedIndex = 3),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AdminStatCard(
                        title: 'أصناف البيض',
                        value: '${_allEggs.length}',
                        icon: Icons.egg_rounded,
                        onTap: () => setState(() => _selectedIndex = 4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    const Icon(Icons.history_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'أحدث سجل العمليات',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (loaded.auditLogs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.adminSurface,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.cardRadius),
                    ),
                    child: Center(
                      child: Text(
                        'لا توجد عمليات مسجلة حديثاً',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textHint),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: loaded.auditLogs.length > 5
                        ? 5
                        : loaded.auditLogs.length,
                    itemBuilder: (context, index) {
                      return AuditLogTile(log: loaded.auditLogs[index]);
                    },
                  ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Text(
                    '© ${DateTime.now().year} Yousef Sallam (01000585478) - All Rights Reserved',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textHint.withValues(alpha: 0.5),
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isLive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              if (isLive) ...[
                const SizedBox(width: 4),
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00E676),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textHint,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPoultryManagementTab() {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final loaded = (state is AdminLoaded ? state : null) ?? _lastLoaded;
        final isLoading = state is AdminLoading && loaded == null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLoading) ...[
                const LinearProgressIndicator(color: AppColors.primary),
                const SizedBox(height: AppSpacing.md),
              ],
              if (state is AdminError && loaded == null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.error),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          state.message,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: _refreshAll,
                        child: const Text('إعادة المحاولة',
                            style: TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              ],
              Container(
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: BoxDecoration(
                  color: AppColors.adminSurface,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.trending_up_rounded,
                          color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('سعر الفراخ الحي الحالي',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.textHint)),
                          const SizedBox(height: 4),
                          Text(
                            loaded?.livePrice != null
                                ? PriceFormatter.format(
                                    loaded!.livePrice!.price)
                                : 'غير محدد',
                            style: AppTextStyles.titleLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showEditLivePriceDialog(
                          context, loaded ?? const AdminLoaded()),
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      label: const Text('تعديل السعر'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // تبديل التصنيف: الدجاج المجمد / الدجاج الفريش
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.adminSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _adminPoultryCategory = 'frozen'),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _adminPoultryCategory == 'frozen'
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.ac_unit_rounded,
                                size: 16,
                                color: _adminPoultryCategory == 'frozen'
                                    ? Colors.black
                                    : AppColors.textHint,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'الدجاج المجمد (${loaded?.products.where((p) => p.isFrozen).length ?? 0})',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _adminPoultryCategory == 'frozen'
                                      ? Colors.black
                                      : AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _adminPoultryCategory = 'fresh'),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _adminPoultryCategory == 'fresh'
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.eco_rounded,
                                size: 16,
                                color: _adminPoultryCategory == 'fresh'
                                    ? Colors.black
                                    : AppColors.textHint,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'الدجاج الفريش (${loaded?.products.where((p) => p.isFresh).length ?? 0})',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _adminPoultryCategory == 'fresh'
                                      ? Colors.black
                                      : AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Builder(
                builder: (context) {
                  final displayedProducts = loaded?.products
                          .where((p) => _adminPoultryCategory == 'fresh' ? p.isFresh : p.isFrozen)
                          .toList() ??
                      [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _adminPoultryCategory == 'fresh'
                                ? 'أصناف الدجاج الفريش (${displayedProducts.length})'
                                : 'أصناف الدجاج المجمد (${displayedProducts.length})',
                            style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showAddProductSheet(context, _adminPoultryCategory),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: Text(
                              _adminPoultryCategory == 'fresh' ? 'إضافة صنف فريش' : 'إضافة صنف مجمد',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(0, 36),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (displayedProducts.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xxl),
                          decoration: BoxDecoration(
                            color: AppColors.adminSurface,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  _adminPoultryCategory == 'fresh'
                                      ? Icons.eco_outlined
                                      : Icons.ac_unit_outlined,
                                  size: 48,
                                  color: AppColors.textHint,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  _adminPoultryCategory == 'fresh'
                                      ? 'لم تتم إضافة أي أصناف دجاج فريش بعد'
                                      : 'لم تتم إضافة أي أصناف دجاج مجمد بعد',
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(color: AppColors.textHint),
                                ),
                                const SizedBox(height: AppSpacing.base),
                                ElevatedButton(
                                  onPressed: () => _showAddProductSheet(context, _adminPoultryCategory),
                                  child: Text(
                                    _adminPoultryCategory == 'fresh' ? 'إضافة أول صنف فريش' : 'إضافة أول صنف مجمد',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedProducts.length,
                          itemBuilder: (context, index) {
                            final product = displayedProducts[index];
                            return ProductAdminTile(
                              product: product,
                              livePrice: loaded?.livePrice?.price ?? 100.0,
                              onEdit: () => _showEditProductSheet(context, product),
                              onToggle: () {
                                final authUser = context.read<AuthCubit>().currentUser;
                                context.read<AdminCubit>().toggleStatus(
                                      productId: product.id,
                                      isActive: !product.isActive,
                                      updatedBy: authUser?.email ?? 'admin',
                                      productName: product.name,
                                    );
                              },
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarketManagementTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isLoadingMarket) ...[
            const LinearProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSpacing.md),
          ],
          if (_marketError != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.error),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'تعذر تحميل أصناف أسعار اللحم الحي من السيرفر',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: _loadMarket,
                    child: const Text('إعادة المحاولة',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أصناف أسعار اللحم الحي (${_allMarketProducts.length})',
                style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddMarketSheet(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('إضافة صنف'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 36),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_allMarketProducts.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.adminSurface,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.storefront_outlined,
                        size: 48, color: AppColors.textHint),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'لم تتم إضافة أي أصناف في أسعار اللحم الحي بعد',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textHint),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    ElevatedButton(
                      onPressed: () => _showAddMarketSheet(context),
                      child: const Text('إضافة أول صنف'),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allMarketProducts.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = _allMarketProducts[index];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.adminSurface,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(
                      color: item.isActive
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.border.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                            child: Text('🍗', style: TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: AppTextStyles.titleMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              PriceFormatter.format(item.price),
                              style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.primary),
                        tooltip: 'تعديل',
                        onPressed: () => _showEditMarketSheet(context, item),
                      ),
                      IconButton(
                        icon: Icon(
                          item.isActive
                              ? Icons.check_circle_rounded
                              : Icons.block_rounded,
                          color: item.isActive
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        tooltip: item.isActive ? 'تعطيل' : 'تفعيل',
                        onPressed: () async {
                          final authUser =
                              context.read<AuthCubit>().currentUser;
                          final marketCubit =
                              context.read<PoultryMarketCubit>();
                          await sl<PoultryMarketRemoteDataSource>()
                              .toggleProductStatus(
                            id: item.id,
                            isActive: !item.isActive,
                            updatedBy: authUser?.email ?? 'admin',
                          );
                          _loadMarket();
                          marketCubit.loadProducts();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: AppColors.error),
                        tooltip: 'حذف',
                        onPressed: () async {
                          final marketCubit =
                              context.read<PoultryMarketCubit>();
                          final confirm = await ConfirmationDialog.show(
                            context,
                            title: 'حذف الصنف',
                            message:
                                'هل أنت متأكد من حذف ${item.name} نهائياً؟',
                            confirmLabel: 'حذف',
                            icon: Icons.delete_forever_rounded,
                          );
                          if (confirm) {
                            await sl<PoultryMarketRemoteDataSource>()
                                .deleteProduct(item.id);
                            _loadMarket();
                            marketCubit.loadProducts();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildChicksManagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isLoadingChicks) ...[
            const LinearProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSpacing.md),
          ],
          if (_chicksError != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.error),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'تعذر تحميل أسعار الكتاكيت من السيرفر',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: _loadChicks,
                    child: const Text('إعادة المحاولة',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
          ],
          // تبديل أقسام الكتاكيت: تسمين / ساسو وبلدي / بط ورومي
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.adminSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _adminChicksCategory = 'fattening'),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _adminChicksCategory == 'fattening'
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🐣', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(
                            'تسمين (${_allChicks.where((c) => c.isFattening).length})',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _adminChicksCategory == 'fattening'
                                  ? Colors.black
                                  : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _adminChicksCategory = 'sasso_baladi'),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _adminChicksCategory == 'sasso_baladi'
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🐓', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(
                            'ساسو وبلدي (${_allChicks.where((c) => c.isSassoBaladi).length})',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _adminChicksCategory == 'sasso_baladi'
                                  ? Colors.black
                                  : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _adminChicksCategory = 'duck_turkey'),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _adminChicksCategory == 'duck_turkey'
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🦆', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(
                            'بط ورومي (${_allChicks.where((c) => c.isDuckTurkey).length})',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _adminChicksCategory == 'duck_turkey'
                                  ? Colors.black
                                  : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Builder(
            builder: (context) {
              final displayedChicks = _allChicks.where((c) {
                if (_adminChicksCategory == 'sasso_baladi') return c.isSassoBaladi;
                if (_adminChicksCategory == 'duck_turkey') return c.isDuckTurkey;
                return c.isFattening;
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'أسعار الكتاكيت (${displayedChicks.length})',
                        style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAddChickSheet(context, _adminChicksCategory),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('إضافة كتكوت'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 36),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (displayedChicks.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        color: AppColors.adminSurface,
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.cruelty_free_outlined,
                                size: 48, color: AppColors.textHint),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              _allChicks.isEmpty
                                  ? 'لم تتم إضافة أي أسعار كتاكيت بعد'
                                  : 'لا توجد أصناف في هذا القسم حالياً',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textHint),
                            ),
                            const SizedBox(height: AppSpacing.base),
                            ElevatedButton(
                              onPressed: () => _showAddChickSheet(context, _adminChicksCategory),
                              child: const Text('إضافة صنف كتكوت'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedChicks.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final item = displayedChicks[index];
                        return Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.adminSurface,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            border: Border.all(
                              color: item.isActive
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : AppColors.border.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    item.isDuckTurkey
                                        ? '🦆'
                                        : (item.isSassoBaladi ? '🐓' : '🐣'),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.name,
                                            style: AppTextStyles.titleMedium.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                                          ),
                                          child: Text(
                                            item.categoryName,
                                            style: const TextStyle(
                                              fontFamily: 'Tajawal',
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      PriceFormatter.format(item.price),
                                      style: AppTextStyles.labelLarge.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: AppColors.primary),
                                tooltip: 'تعديل',
                                onPressed: () => _showEditChickSheet(context, item),
                              ),
                      IconButton(
                        icon: Icon(
                          item.isActive
                              ? Icons.check_circle_rounded
                              : Icons.block_rounded,
                          color: item.isActive
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        tooltip: item.isActive ? 'تعطيل' : 'تفعيل',
                        onPressed: () async {
                          final authUser =
                              context.read<AuthCubit>().currentUser;
                          final chicksCubit = context.read<ChicksCubit>();
                          await sl<ChicksRemoteDataSource>().toggleChickStatus(
                            id: item.id,
                            isActive: !item.isActive,
                            updatedBy: authUser?.email ?? 'admin',
                          );
                          _loadChicks();
                          chicksCubit.loadChicks();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: AppColors.error),
                        tooltip: 'حذف',
                        onPressed: () async {
                          final chicksCubit = context.read<ChicksCubit>();
                          final confirm = await ConfirmationDialog.show(
                            context,
                            title: 'حذف صنف الكتكوت',
                            message:
                                'هل أنت متأكد من حذف ${item.name} نهائياً؟',
                            confirmLabel: 'حذف',
                            icon: Icons.delete_forever_rounded,
                          );
                          if (confirm) {
                            await sl<ChicksRemoteDataSource>()
                                .deleteChick(item.id);
                            _loadChicks();
                            chicksCubit.loadChicks();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    ),
        ],
      ),
    );
  }

  Widget _buildEggsManagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isLoadingEggs) ...[
            const LinearProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSpacing.md),
          ],
          if (_eggsError != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.error),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'تعذر تحميل أسعار البيض من السيرفر',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: _loadEggs,
                    child: const Text('إعادة المحاولة',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أسعار البيض (${_allEggs.length})',
                style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEggSheet(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('إضافة بيض'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 36),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_allEggs.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.adminSurface,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.egg_outlined,
                        size: 48, color: AppColors.textHint),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'لم تتم إضافة أي أسعار بيض بعد',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textHint),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    ElevatedButton(
                      onPressed: () => _showAddEggSheet(context),
                      child: const Text('إضافة أول صنف بيض'),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allEggs.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = _allEggs[index];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.adminSurface,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(
                      color: item.isActive
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.border.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                            child: Text('🥚', style: TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: AppTextStyles.titleMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              PriceFormatter.format(item.price),
                              style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.primary),
                        tooltip: 'تعديل',
                        onPressed: () => _showEditEggSheet(context, item),
                      ),
                      IconButton(
                        icon: Icon(
                          item.isActive
                              ? Icons.check_circle_rounded
                              : Icons.block_rounded,
                          color: item.isActive
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        tooltip: item.isActive ? 'تعطيل' : 'تفعيل',
                        onPressed: () async {
                          final authUser =
                              context.read<AuthCubit>().currentUser;
                          final eggsCubit = context.read<EggsCubit>();
                          await sl<EggsRemoteDataSource>().toggleEggStatus(
                            id: item.id,
                            isActive: !item.isActive,
                            updatedBy: authUser?.email ?? 'admin',
                          );
                          _loadEggs();
                          eggsCubit.loadEggs();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: AppColors.error),
                        tooltip: 'حذف',
                        onPressed: () async {
                          final eggsCubit = context.read<EggsCubit>();
                          final confirm = await ConfirmationDialog.show(
                            context,
                            title: 'حذف صنف البيض',
                            message:
                                'هل أنت متأكد من حذف ${item.name} نهائياً؟',
                            confirmLabel: 'حذف',
                            icon: Icons.delete_forever_rounded,
                          );
                          if (confirm) {
                            await sl<EggsRemoteDataSource>().deleteEgg(item.id);
                            _loadEggs();
                            eggsCubit.loadEggs();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showEditLivePriceDialog(BuildContext context, AdminLoaded state) {
    final priceController = TextEditingController(
      text: state.livePrice != null
          ? state.livePrice!.price.toStringAsFixed(0)
          : '100',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF2C1E0A),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg)),
            title: Text(AppStrings.editLivePriceTitle,
                style: AppTextStyles.headlineSmall
                    .copyWith(color: AppColors.primary)),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.livePrice != null)
                    Text(
                      '${AppStrings.currentPrice}: ${PriceFormatter.format(state.livePrice!.price)}',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textHint),
                    ),
                  const SizedBox(height: AppSpacing.base),
                  AppTextField(
                    label: AppStrings.newPrice,
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: const Icon(Icons.attach_money_rounded),
                    isDark: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.priceRequired;
                      }
                      final price = double.tryParse(value.trim());
                      if (price == null) {
                        return AppStrings.priceInvalid;
                      }
                      if (price <= 0) {
                        return AppStrings.priceMustBePositive;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(AppStrings.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    Navigator.of(dialogContext).pop();
                    final newPrice = double.parse(priceController.text.trim());
                    final confirmed = await ConfirmationDialog.show(
                      context,
                      title: AppStrings.confirmChangePriceTitle,
                      message: AppStrings.confirmChangePriceBody,
                      confirmLabel: AppStrings.confirm,
                      icon: Icons.price_change_outlined,
                    );
                    if (confirmed && context.mounted) {
                      final authUser = context.read<AuthCubit>().currentUser;
                      final pricesCubit = context.read<PricesCubit>();
                      await context.read<AdminCubit>().changeLivePrice(
                            newPrice: newPrice,
                            updatedBy: authUser?.email ?? 'admin',
                          );
                      pricesCubit.loadPrices();
                    }
                  }
                },
                child: Text(AppStrings.save),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddProductSheet(BuildContext context, [String defaultCategory = 'frozen']) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditProductSheet(
        initialCategory: defaultCategory,
        onSave: (name, multiplier, increase, category) {
          final authUser = context.read<AuthCubit>().currentUser;
          context.read<AdminCubit>().addProduct(
                name: name,
                multiplier: multiplier,
                increase: increase,
                createdBy: authUser?.email ?? 'admin',
                category: category,
              );
        },
      ),
    );
  }

  void _showEditProductSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditProductSheet(
        existingProduct: product,
        onSave: (name, multiplier, increase, category) {
          final authUser = context.read<AuthCubit>().currentUser;
          context.read<AdminCubit>().editProduct(
                productId: product.id,
                name: name,
                multiplier: multiplier,
                increase: increase,
                updatedBy: authUser?.email ?? 'admin',
                oldProduct: product,
                category: category,
              );
        },
      ),
    );
  }

  void _showAddChickSheet(BuildContext context, [String defaultCategory = 'fattening']) {
    final chicksCubit = context.read<ChicksCubit>();
    final adminCubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditChickSheet(
        initialCategory: defaultCategory,
        onSave: (name, price, category) async {
          final authUser = context.read<AuthCubit>().currentUser;
          try {
            await sl<ChicksRemoteDataSource>().addChick(
              name: name,
              price: price,
              category: category,
              updatedBy: authUser?.email ?? 'admin',
            );
            await _loadChicks();
            chicksCubit.loadChicks();
            adminCubit.loadDashboard();
            if (context.mounted) {
              AppSnackbar.showSuccess(context, 'تمت إضافة الكتكوت بنجاح');
            }
          } catch (e) {
            if (context.mounted) {
              AppSnackbar.showError(context, 'خطأ في إضافة الكتكوت: $e');
            }
          }
        },
      ),
    );
  }

  void _showEditChickSheet(BuildContext context, ChickProduct chick) {
    final chicksCubit = context.read<ChicksCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditChickSheet(
        existing: chick,
        onSave: (name, price, category) async {
          final authUser = context.read<AuthCubit>().currentUser;
          try {
            await sl<ChicksRemoteDataSource>().updateChick(
              id: chick.id,
              name: name,
              price: price,
              category: category,
              updatedBy: authUser?.email ?? 'admin',
            );
            await _loadChicks();
            chicksCubit.loadChicks();
            if (context.mounted) {
              AppSnackbar.showSuccess(context, 'تم تعديل صنف الكتكوت بنجاح');
            }
          } catch (e) {
            if (context.mounted) {
              AppSnackbar.showError(context, 'خطأ في تعديل الكتكوت: $e');
            }
          }
        },
      ),
    );
  }

  void _showAddEggSheet(BuildContext context) {
    final eggsCubit = context.read<EggsCubit>();
    final adminCubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditEggSheet(
        onSave: (name, price) async {
          final authUser = context.read<AuthCubit>().currentUser;
          try {
            await sl<EggsRemoteDataSource>().addEgg(
              name: name,
              price: price,
              updatedBy: authUser?.email ?? 'admin',
            );
            await _loadEggs();
            eggsCubit.loadEggs();
            adminCubit.loadDashboard();
            if (context.mounted) {
              AppSnackbar.showSuccess(context, 'تمت إضافة صنف البيض بنجاح');
            }
          } catch (e) {
            if (context.mounted) {
              AppSnackbar.showError(context, 'خطأ في إضافة البيض: $e');
            }
          }
        },
      ),
    );
  }

  void _showEditEggSheet(BuildContext context, EggProduct egg) {
    final eggsCubit = context.read<EggsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditEggSheet(
        existing: egg,
        onSave: (name, price) async {
          final authUser = context.read<AuthCubit>().currentUser;
          try {
            await sl<EggsRemoteDataSource>().updateEgg(
              id: egg.id,
              name: name,
              price: price,
              updatedBy: authUser?.email ?? 'admin',
            );
            await _loadEggs();
            eggsCubit.loadEggs();
            if (context.mounted) {
              AppSnackbar.showSuccess(context, 'تم تعديل سعر البيض بنجاح');
            }
          } catch (e) {
            if (context.mounted) {
              AppSnackbar.showError(context, 'خطأ في تعديل البيض: $e');
            }
          }
        },
      ),
    );
  }

  void _showAddMarketSheet(BuildContext context) {
    final marketCubit = context.read<PoultryMarketCubit>();
    final adminCubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditMarketSheet(
        onSave: (name, price) async {
          final authUser = context.read<AuthCubit>().currentUser;
          try {
            await sl<PoultryMarketRemoteDataSource>().addProduct(
              name: name,
              price: price,
              updatedBy: authUser?.email ?? 'admin',
            );
            await _loadMarket();
            marketCubit.loadProducts();
            adminCubit.loadDashboard();
            if (context.mounted) {
              AppSnackbar.showSuccess(context, 'تمت إضافة الصنف بنجاح');
            }
          } catch (e) {
            if (context.mounted) {
              AppSnackbar.showError(context, 'خطأ في إضافة الصنف: $e');
            }
          }
        },
      ),
    );
  }

  void _showEditMarketSheet(BuildContext context, PoultryMarketProduct item) {
    final marketCubit = context.read<PoultryMarketCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditMarketSheet(
        existing: item,
        onSave: (name, price) async {
          final authUser = context.read<AuthCubit>().currentUser;
          try {
            await sl<PoultryMarketRemoteDataSource>().updateProduct(
              id: item.id,
              name: name,
              price: price,
              updatedBy: authUser?.email ?? 'admin',
            );
            await _loadMarket();
            marketCubit.loadProducts();
            if (context.mounted) {
              AppSnackbar.showSuccess(context, 'تم تعديل سعر الصنف بنجاح');
            }
          } catch (e) {
            if (context.mounted) {
              AppSnackbar.showError(context, 'خطأ في تعديل الصنف: $e');
            }
          }
        },
      ),
    );
  }
}
