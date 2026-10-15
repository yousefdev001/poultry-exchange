import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_strings.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    // Always show Arabic - never show raw English Firebase errors
    final arabicMessage = _toArabic(message);
    final isNetwork = message.contains('network') ||
        message.contains('unavailable') ||
        message.contains('transient') ||
        message.contains('internet') ||
        arabicMessage.contains('إنترنت');

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: isNetwork
                  ? AppColors.warningLight
                  : AppColors.errorLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNetwork
                  ? Icons.wifi_off_rounded
                  : Icons.cloud_off_rounded,
              size: 52,
              color: isNetwork ? AppColors.warning : AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            isNetwork ? AppStrings.noInternet : AppStrings.errorTitle,
            style: AppTextStyles.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isNetwork ? AppStrings.offlineMessage : arabicMessage,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(AppStrings.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _toArabic(String msg) {
    // Map common English Firebase/Firestore errors to Arabic
    if (msg.contains('unavailable') || msg.contains('transient') || msg.contains('backoff')) {
      return 'تعذّر الاتصال بالخادم. يرجى التحقق من الإنترنت والمحاولة مجدداً';
    }
    if (msg.contains('permission') || msg.contains('PERMISSION_DENIED')) {
      return 'لا تملك صلاحية الوصول';
    }
    if (msg.contains('not-found') || msg.contains('NOT_FOUND')) {
      return 'البيانات غير موجودة';
    }
    if (msg.contains('network') || msg.contains('internet') || msg.contains('connection')) {
      return 'يرجى التحقق من اتصال الإنترنت';
    }
    if (msg.contains('timeout')) {
      return 'انتهت مهلة الاتصال. يرجى المحاولة مجدداً';
    }
    // If already Arabic, return as is
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(msg)) return msg;
    // Default
    return 'تعذّر تحميل البيانات. يرجى المحاولة لاحقاً';
  }
}

class EmptyView extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyView({
    super.key,
    required this.message,
    this.icon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: const BoxDecoration(
              color: AppColors.priceBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
