import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/live_price.dart';

class LivePriceCard extends StatelessWidget {
  final LivePrice livePrice;

  const LivePriceCard({super.key, required this.livePrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF1A1208), Color(0xFF3D2A06)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.primary,
                    size: AppSpacing.iconMd,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.livePriceTitle,
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  PriceFormatter.formatNumber(livePrice.price),
                  style: AppTextStyles.priceHero,
                ),
                const SizedBox(width: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    AppStrings.currency,
                    style: AppTextStyles.priceCurrency,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Last Updated
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.textHint,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  '${AppStrings.lastUpdated}: ${DateFormatter.formatLastUpdated(livePrice.updatedAt)}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

