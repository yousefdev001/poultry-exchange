import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../domain/entities/audit_log.dart';

class AuditLogTile extends StatelessWidget {
  final AuditLog log;
  const AuditLogTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildActionIcon(),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  log.actionDisplayName,
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
                ),
              ),
              Text(
                DateFormatter.formatTime(log.performedAt),
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildChangeSummary(),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 12, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(log.performedBy, style: AppTextStyles.caption),
              const Spacer(),
              Text(DateFormatter.formatDate(log.performedAt), style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon() {
    IconData icon;
    Color color;
    switch (log.action) {
      case AuditAction.updateLivePrice:
        icon = Icons.price_change_outlined;
        color = AppColors.primary;
        break;
      case AuditAction.addProduct:
        icon = Icons.add_box_outlined;
        color = AppColors.success;
        break;
      case AuditAction.updateProduct:
        icon = Icons.edit_outlined;
        color = AppColors.secondary;
        break;
      case AuditAction.disableProduct:
        icon = Icons.block_rounded;
        color = AppColors.error;
        break;
      case AuditAction.enableProduct:
        icon = Icons.check_circle_outline;
        color = AppColors.success;
        break;
    }
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }

  Widget _buildChangeSummary() {
    switch (log.action) {
      case AuditAction.updateLivePrice:
        final oldPrice = (log.oldValue['livePrice'] as num?)?.toDouble() ?? 0;
        final newPrice = (log.newValue['livePrice'] as num?)?.toDouble() ?? 0;
        return Row(
          children: [
            Text(PriceFormatter.format(oldPrice), style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.arrow_back_rounded, size: 14, color: AppColors.textHint),
            ),
            Text(PriceFormatter.format(newPrice), style: AppTextStyles.bodySmall.copyWith(color: AppColors.success)),
          ],
        );
      case AuditAction.addProduct:
      case AuditAction.updateProduct:
      case AuditAction.disableProduct:
      case AuditAction.enableProduct:
        final name = log.newValue['name'] as String? ?? log.oldValue['name'] as String? ?? '';
        return Text(name, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textOnDark));
    }
  }
}
