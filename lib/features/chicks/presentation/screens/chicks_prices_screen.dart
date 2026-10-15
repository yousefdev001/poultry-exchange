import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/watermark_background.dart';
import '../cubit/chicks_cubit.dart';
import '../cubit/chicks_state.dart';

class ChicksPricesScreen extends StatefulWidget {
  const ChicksPricesScreen({super.key});

  @override
  State<ChicksPricesScreen> createState() => _ChicksPricesScreenState();
}

class _ChicksPricesScreenState extends State<ChicksPricesScreen> {
  String _selectedCategory = 'fattening';

  @override
  void initState() {
    super.initState();
    context.read<ChicksCubit>().loadChicks();
  }

  Widget _buildCategoryTab({
    required String slug,
    required String label,
    required String emoji,
  }) {
    final isSelected = _selectedCategory == slug;
    return Expanded(
      child: InkWell(
        onTap: () {
          if (_selectedCategory != slug) {
            setState(() => _selectedCategory = slug);
          }
        },
        borderRadius: BorderRadius.circular(9),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
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
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('أسعار الكتاكيت'),
        centerTitle: true,
      ),
      body: WatermarkBackground(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<ChicksCubit>().loadChicks(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.priceBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('تاريخ اليوم', style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
                            const SizedBox(height: 2),
                            Text(
                              DateFormatter.formatTodayFull(),
                              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Category Switcher: كتكوت تسمين / كتكوت ساسو وبلدي / كتكوت بط ورومي
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
                      _buildCategoryTab(
                        slug: 'fattening',
                        label: 'كتكوت تسمين',
                        emoji: '🐣',
                      ),
                      _buildCategoryTab(
                        slug: 'sasso_baladi',
                        label: 'ساسو وبلدي',
                        emoji: '🐓',
                      ),
                      _buildCategoryTab(
                        slug: 'duck_turkey',
                        label: 'بط ورومي',
                        emoji: '🦆',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                BlocBuilder<ChicksCubit, ChicksState>(
                  builder: (context, state) {
                    if (state is ChicksLoading || state is ChicksInitial) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: LoadingView(),
                      );
                    }
                    if (state is ChicksError) {
                      return ErrorView(
                        message: state.message,
                        onRetry: () => context.read<ChicksCubit>().loadChicks(),
                      );
                    }
                    if (state is ChicksLoaded) {
                      if (state.chicks.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: EmptyView(
                            message: 'لا توجد أسعار كتاكيت معلنة حالياً',
                            icon: Icons.egg_outlined,
                          ),
                        );
                      }

                      final filteredChicks = state.chicks.where((item) {
                        if (_selectedCategory == 'sasso_baladi') return item.isSassoBaladi;
                        if (_selectedCategory == 'duck_turkey') return item.isDuckTurkey;
                        return item.isFattening;
                      }).toList();

                      if (filteredChicks.isEmpty) {
                        final categoryTitle = _selectedCategory == 'sasso_baladi'
                            ? 'كتكوت ساسو وبلدي'
                            : (_selectedCategory == 'duck_turkey' ? 'كتكوت بط ورومي' : 'كتكوت تسمين');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: EmptyView(
                            message: 'لا توجد أسعار لـ $categoryTitle معلنة حالياً',
                            icon: Icons.cruelty_free_outlined,
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredChicks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final item = filteredChicks[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                              boxShadow: const [
                                BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 1)),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.priceBackground,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.isDuckTurkey
                                          ? '🦆'
                                          : (item.isSassoBaladi ? '🐓' : '🐣'),
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.priceBackground,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    PriceFormatter.format(item.price),
                                    style: AppTextStyles.priceCard.copyWith(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
