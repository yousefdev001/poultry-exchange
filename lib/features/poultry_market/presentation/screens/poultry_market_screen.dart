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
import '../cubit/poultry_market_cubit.dart';
import '../cubit/poultry_market_state.dart';

class PoultryMarketScreen extends StatefulWidget {
  const PoultryMarketScreen({super.key});

  @override
  State<PoultryMarketScreen> createState() => _PoultryMarketScreenState();
}

class _PoultryMarketScreenState extends State<PoultryMarketScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PoultryMarketCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('أسعار اللحم الحي'),
        centerTitle: true,
      ),
      body: WatermarkBackground(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<PoultryMarketCubit>().loadProducts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date Banner
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.5)),
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 6,
                          offset: Offset(0, 2)),
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
                        child: const Icon(Icons.calendar_month_rounded,
                            color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('تاريخ اليوم',
                                style: AppTextStyles.caption
                                    .copyWith(color: AppColors.textHint)),
                            const SizedBox(height: 2),
                            Text(
                              DateFormatter.formatTodayFull(),
                              style: AppTextStyles.titleMedium
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                BlocBuilder<PoultryMarketCubit, PoultryMarketState>(
                  builder: (context, state) {
                    if (state is PoultryMarketLoading ||
                        state is PoultryMarketInitial) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: LoadingView(),
                      );
                    }
                    if (state is PoultryMarketError) {
                      return ErrorView(
                        message: state.message,
                        onRetry: () =>
                            context.read<PoultryMarketCubit>().loadProducts(),
                      );
                    }
                    if (state is PoultryMarketLoaded) {
                      if (state.products.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(AppSpacing.xxl),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.cardRadius),
                            border: Border.all(
                                color: AppColors.border.withValues(alpha: 0.4)),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.storefront_outlined,
                                    size: 48, color: AppColors.textHint),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'لا توجد أسعار في أسعار اللحم الحي حالياً',
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(color: AppColors.textHint),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.products.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final item = state.products[index];
                          return Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.cardRadius),
                              border: Border.all(
                                  color:
                                      AppColors.border.withValues(alpha: 0.5)),
                              boxShadow: const [
                                BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 4,
                                    offset: Offset(0, 2)),
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
                                  child: const Center(
                                    child: Icon(Icons.storefront_rounded,
                                        color: AppColors.primary, size: 24),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: AppTextStyles.titleMedium
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    PriceFormatter.format(item.price),
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: AppColors.primary,
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
