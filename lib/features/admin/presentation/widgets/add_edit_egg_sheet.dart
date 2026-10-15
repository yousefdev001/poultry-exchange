import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../eggs/domain/entities/egg_product.dart';

class AddEditEggSheet extends StatefulWidget {
  final EggProduct? existing;
  final void Function(String name, double price) onSave;

  const AddEditEggSheet({super.key, this.existing, required this.onSave});

  @override
  State<AddEditEggSheet> createState() => _AddEditEggSheetState();
}

class _AddEditEggSheetState extends State<AddEditEggSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
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
      widget.onSave(name, price);
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
                _isEditing ? 'تعديل سعر البيض' : 'إضافة صنف بيض جديد',
                style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'اسم الصنف (مثلاً: كرتونة بيض أحمر)',
                controller: _nameController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.egg_outlined),
                isDark: true,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'يرجى إدخال اسم الصنف';
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
                      label: _isEditing ? 'حفظ التعديل' : 'إضافة الصنف',
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
