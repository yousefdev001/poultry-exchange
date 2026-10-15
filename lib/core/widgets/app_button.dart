// ============================================================
// app_button.dart — زر قابل لإعادة الاستخدام
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, outlined, text, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? AppSpacing.buttonHeight,
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: _buildChild(AppColors.textOnPrimary),
        );

      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: _buildChild(AppColors.textOnPrimary),
        );

      case AppButtonType.outlined:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          child: _buildChild(AppColors.primary),
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          child: _buildChild(AppColors.primary),
        );

      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: _buildChild(AppColors.textOnPrimary),
        );
    }
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    final children = <Widget>[];
    if (prefixIcon != null) {
      children.add(prefixIcon!);
      children.add(const SizedBox(width: AppSpacing.sm));
    }
    children.add(Text(label, style: AppTextStyles.buttonLarge.copyWith(color: color)));
    if (suffixIcon != null) {
      children.add(const SizedBox(width: AppSpacing.sm));
      children.add(suffixIcon!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
