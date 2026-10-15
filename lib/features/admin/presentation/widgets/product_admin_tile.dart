import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../prices/domain/entities/product.dart';

class ProductAdminTile extends StatelessWidget {
  final Product product;
  final double livePrice;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const ProductAdminTile({
    super.key,
    required this.product,
    required this.livePrice,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final finalPrice = product.calculatePrice(livePrice);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: product.isActive
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.border.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.textOnDark),
                  ),
                ),
                _buildCategoryBadge(),
                const SizedBox(width: AppSpacing.xs),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _buildInfoChip('النسبة', product.multiplier.toStringAsFixed(2)),
                const SizedBox(width: AppSpacing.sm),
                _buildInfoChip('الزيادة', '${product.increase.toStringAsFixed(0)} ج'),
                const SizedBox(width: AppSpacing.sm),
                _buildInfoChip('السعر', PriceFormatter.format(finalPrice), isPrice: true),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                  label: Text(AppStrings.edit, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4)),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton.icon(
                  onPressed: onToggle,
                  icon: Icon(
                    product.isActive ? Icons.block_rounded : Icons.check_circle_outline_rounded,
                    size: 16,
                    color: product.isActive ? AppColors.error : AppColors.success,
                  ),
                  label: Text(
                    product.isActive ? AppStrings.disable : AppStrings.enable,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: product.isActive ? AppColors.error : AppColors.success,
                    ),
                  ),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    final isFresh = product.isFresh;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: isFresh
            ? const Color(0xFF2E7D32).withValues(alpha: 0.2)
            : const Color(0xFF1565C0).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFresh ? const Color(0xFF4CAF50) : const Color(0xFF42A5F5),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFresh ? Icons.eco_rounded : Icons.ac_unit_rounded,
            size: 11,
            color: isFresh ? const Color(0xFF81C784) : const Color(0xFF90CAF9),
          ),
          const SizedBox(width: 3),
          Text(
            isFresh ? 'فريش' : 'مجمد',
            style: AppTextStyles.statusBadge.copyWith(
              color: isFresh ? const Color(0xFF81C784) : const Color(0xFF90CAF9),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: product.isActive ? AppColors.successLight : AppColors.errorLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        product.isActive ? AppStrings.active : AppStrings.inactive,
        style: AppTextStyles.statusBadge.copyWith(
          color: product.isActive ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, {bool isPrice = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: isPrice ? AppColors.primary.withValues(alpha: 0.15) : AppColors.adminBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              color: isPrice ? AppColors.primary : AppColors.textOnDark,
            ),
          ),
        ],
      ),
    );
  }
}
