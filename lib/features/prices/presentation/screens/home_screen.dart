import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/watermark_background.dart';
import '../../../../routing/route_names.dart';
import '../cubit/prices_cubit.dart';
import '../cubit/prices_state.dart';
import '../widgets/live_price_card.dart';
import '../widgets/product_card.dart';
import '../widgets/offline_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'frozen';

  @override
  void initState() {
    super.initState();
    context.read<PricesCubit>().loadPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: WatermarkBackground(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<PricesCubit>().refreshPrices(),
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: BlocBuilder<PricesCubit, PricesState>(
                  builder: (context, state) {
                    if (state is PricesLoading || state is PricesInitial) {
                      return const PricesLoadingSkeleton();
                    }
                    if (state is PricesError) {
                      return ErrorView(
                        message: state.message,
                        onRetry: () => context.read<PricesCubit>().loadPrices(),
                      );
                    }
                    if (state is PricesLoaded) {
                      return _buildContent(state);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.surface,
      floating: true,
      snap: true,
      elevation: 0,
      toolbarHeight: 70,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Row(
            children: [
              _SecretAdminTap(
                child: ClipOval(
                  child: Image.asset(
                    AppAssets.logo,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.primary,
                      child: const Icon(Icons.store, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أسعار الدجاج',
                      style: AppTextStyles.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormatter.formatTodayFull(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(PricesLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.base),

        // Offline Banner
        if (state.isOffline)
          OfflineBanner(lastUpdated: state.livePrice.updatedAt),

        // بطاقة تاريخ اليوم البارزة (اليوم، الشهر، السنة)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.priceBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تاريخ اليوم',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormatter.formatTodayFull(),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Live Price Card
        LivePriceCard(livePrice: state.livePrice),

        const SizedBox(height: AppSpacing.xl),

        // Section Title & Category Selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'أسعار الدجاج',
                    style: AppTextStyles.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // أزرار التبديل التفاعلية بين الدجاج المجمد والدجاج الفريش
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // تبويب الدجاج المجمد
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (_selectedCategory != 'frozen') {
                            setState(() => _selectedCategory = 'frozen');
                          }
                        },
                        borderRadius: BorderRadius.circular(9),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedCategory == 'frozen'
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: _selectedCategory == 'frozen'
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.ac_unit_rounded,
                                size: 18,
                                color: _selectedCategory == 'frozen'
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'الدجاج المجمد',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: _selectedCategory == 'frozen'
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: _selectedCategory == 'frozen'
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // تبويب الدجاج الفريش
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (_selectedCategory != 'fresh') {
                            setState(() => _selectedCategory = 'fresh');
                          }
                        },
                        borderRadius: BorderRadius.circular(9),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedCategory == 'fresh'
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: _selectedCategory == 'fresh'
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.eco_rounded,
                                size: 18,
                                color: _selectedCategory == 'fresh'
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'الدجاج الفريش',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: _selectedCategory == 'fresh'
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: _selectedCategory == 'fresh'
                                      ? Colors.white
                                      : AppColors.textSecondary,
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
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Products List filtered by category
        Builder(
          builder: (context) {
            final filteredProducts = state.products
                .where((p) => _selectedCategory == 'fresh' ? p.isFresh : p.isFrozen)
                .toList();

            if (filteredProducts.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        _selectedCategory == 'fresh'
                            ? Icons.eco_outlined
                            : Icons.inventory_2_outlined,
                        size: 48,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _selectedCategory == 'fresh'
                            ? 'لا توجد أصناف دجاج فريش مضافة حاليًا'
                            : 'لا توجد أصناف دجاج مجمد مضافة حاليًا',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.base),
                      ElevatedButton.icon(
                        onPressed: () => context.read<PricesCubit>().loadPrices(),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('تحديث قائمة الأصناف'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: filteredProducts[index],
                  livePrice: state.livePrice.price,
                );
              },
            );
          },
        ),

        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

// ============================================================
// Secret 7-tap widget للوصول للوحة الإدارة
// ============================================================
class _SecretAdminTap extends StatefulWidget {
  final Widget child;
  const _SecretAdminTap({required this.child});

  @override
  State<_SecretAdminTap> createState() => _SecretAdminTapState();
}

class _SecretAdminTapState extends State<_SecretAdminTap> {
  int _tapCount = 0;
  DateTime? _firstTapTime;

  void _onTap() {
    final now = DateTime.now();
    if (_firstTapTime == null ||
        now.difference(_firstTapTime!) > const Duration(seconds: 4)) {
      _tapCount = 1;
      _firstTapTime = now;
    } else {
      _tapCount++;
    }

    if (_tapCount >= 7) {
      _tapCount = 0;
      _firstTapTime = null;
      context.push(RouteNames.adminLogin).then((_) {
        if (mounted) {
          context.read<PricesCubit>().loadPrices();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: widget.child,
    );
  }
}
