import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../prices/domain/entities/product.dart';

class AddEditProductSheet extends StatefulWidget {
  final Product? existingProduct;
  final String initialCategory;
  final void Function(String name, double multiplier, double increase, String category) onSave;

  const AddEditProductSheet({
    super.key,
    this.existingProduct,
    this.initialCategory = 'frozen',
    required this.onSave,
  });

  @override
  State<AddEditProductSheet> createState() => _AddEditProductSheetState();
}

class _AddEditProductSheetState extends State<AddEditProductSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _multiplierController;
  late final TextEditingController _increaseController;
  late String _selectedCategory;

  bool get _isEditing => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.existingProduct?.category ?? widget.initialCategory;
    _nameController = TextEditingController(text: widget.existingProduct?.name ?? '');
    _multiplierController = TextEditingController(
      text: widget.existingProduct != null ? widget.existingProduct!.multiplier.toStringAsFixed(2) : '',
    );
    _increaseController = TextEditingController(
      text: widget.existingProduct != null ? widget.existingProduct!.increase.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _multiplierController.dispose();
    _increaseController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final multiplier = double.parse(_multiplierController.text.trim());
      final increase = double.parse(_increaseController.text.trim());
      widget.onSave(name, multiplier, increase, _selectedCategory);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C1E0A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.base),

              Text(
                _isEditing ? AppStrings.editProduct : AppStrings.addProductTitle,
                style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category Switcher (مجمد / فريش)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.adminBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _selectedCategory = 'frozen'),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedCategory == 'frozen'
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
                                color: _selectedCategory == 'frozen'
                                    ? Colors.black
                                    : AppColors.textHint,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'دجاج مجمد',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedCategory == 'frozen'
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
                        onTap: () => setState(() => _selectedCategory = 'fresh'),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedCategory == 'fresh'
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
                                color: _selectedCategory == 'fresh'
                                    ? Colors.black
                                    : AppColors.textHint,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'دجاج فريش',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedCategory == 'fresh'
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

              AppTextField(
                label: AppStrings.productName,
                controller: _nameController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.inventory_2_outlined),
                isDark: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return AppStrings.productNameRequired;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.base),

              AppTextField(
                label: AppStrings.multiplier,
                controller: _multiplierController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.calculate_outlined),
                isDark: true,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return AppStrings.multiplierRequired;
                  final num = double.tryParse(value.trim());
                  if (num == null) return AppStrings.multiplierInvalid;
                  if (num <= 0) return AppStrings.multiplierMustBePositive;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.base),

              AppTextField(
                label: AppStrings.increase,
                controller: _increaseController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.add_circle_outline_rounded),
                isDark: true,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                onEditingComplete: _save,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return AppStrings.increaseRequired;
                  final num = double.tryParse(value.trim());
                  if (num == null) return AppStrings.increaseInvalid;
                  if (num < 0) return AppStrings.increaseNegative;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: AppStrings.cancel,
                      type: AppButtonType.outlined,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: _isEditing ? AppStrings.saveEdits : AppStrings.saveProduct,
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
