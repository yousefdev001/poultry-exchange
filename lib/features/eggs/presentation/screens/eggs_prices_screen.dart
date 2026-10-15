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
import '../cubit/eggs_cubit.dart';
import '../cubit/eggs_state.dart';

class EggsPricesScreen extends StatefulWidget {
  const EggsPricesScreen({super.key});

  @override
  State<EggsPricesScreen> createState() => _EggsPricesScreenState();
}

class _EggsPricesScreenState extends State<EggsPricesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EggsCubit>().loadEggs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('أسعار البيض'),
        centerTitle: true,
      ),
      body: WatermarkBackground(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<EggsCubit>().loadEggs(),
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

              const SizedBox(height: AppSpacing.lg),

              BlocBuilder<EggsCubit, EggsState>(
                builder: (context, state) {
                  if (state is EggsLoading || state is EggsInitial) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: LoadingView(),
                    );
                  }
                  if (state is EggsError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () => context.read<EggsCubit>().loadEggs(),
                    );
                  }
                  if (state is EggsLoaded) {
                    if (state.eggs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: EmptyView(
                          message: 'لا توجد أسعار بيض معلنة حالياً',
                          icon: Icons.circle_outlined,
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.eggs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final item = state.eggs[index];
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
                                child: const Center(
                                  child: Text('🥚', style: TextStyle(fontSize: 22)),
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
