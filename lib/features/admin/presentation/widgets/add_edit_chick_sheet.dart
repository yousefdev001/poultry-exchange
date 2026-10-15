import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../chicks/domain/entities/chick_product.dart';

class AddEditChickSheet extends StatefulWidget {
  final ChickProduct? existing;
  final String initialCategory;
  final void Function(String name, double price, String category) onSave;

  const AddEditChickSheet({
    super.key,
    this.existing,
    this.initialCategory = 'fattening',
    required this.onSave,
  });

  @override
  State<AddEditChickSheet> createState() => _AddEditChickSheetState();
}

class _AddEditChickSheetState extends State<AddEditChickSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late String _selectedCategory;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.existing?.category ?? widget.initialCategory;
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _priceController = TextEditingController(
      text: widget.existing != null ? widget.existing!.price.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final price = double.parse(_priceController.text.trim());
      widget.onSave(name, price, _selectedCategory);
      Navigator.of(context).pop();
    }
  }

  Widget _buildCategoryOption({
    required String slug,
    required String label,
    required String emoji,
  }) {
    final isSelected = _selectedCategory == slug;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = slug),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : AppColors.textHint,
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
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                _isEditing ? 'تعديل صنف الكتكوت' : 'إضافة صنف كتكوت جديد',
                style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category Selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.adminBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    _buildCategoryOption(
                      slug: 'fattening',
                      label: 'كتكوت تسمين',
                      emoji: '🐣',
                    ),
                    _buildCategoryOption(
                      slug: 'sasso_baladi',
                      label: 'ساسو وبلدي',
                      emoji: '🐓',
                    ),
                    _buildCategoryOption(
                      slug: 'duck_turkey',
                      label: 'بط ورومي',
                      emoji: '🦆',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'اسم الكتكوت',
                controller: _nameController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.cruelty_free_outlined),
                isDark: true,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'يرجى إدخال اسم الكتكوت';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.base),
              AppTextField(
                label: 'السعر (جنيه)',
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.attach_money_rounded),
                isDark: true,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                onEditingComplete: _save,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'يرجى إدخال السعر';
                  final num = double.tryParse(val.trim());
                  if (num == null || num <= 0) return 'يرجى إدخال سعر صحيح أكبر من صفر';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'إلغاء',
                      type: AppButtonType.outlined,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: _isEditing ? 'حفظ التعديل' : 'إضافة الكتكوت',
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
