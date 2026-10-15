import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/responsive/platform_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../routing/route_names.dart';
import '../../../prices/presentation/cubit/prices_cubit.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@elshams.com');
  final _passwordController = TextEditingController(text: 'admin123456');
  bool _isSettingUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  Future<void> _setupFirstTimeAdmin() async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'تهيئة حساب الأدمن والبيانات',
      message: 'سيتم إنشاء حساب الأدمن الافتراضي (admin@elshams.com) وتجهيز قاعدة البيانات بأسعار الأصناف العشرة وسعر الحي (100 جنيه). هل تريد المتابعة؟',
      confirmLabel: 'بدء التهيئة',
      icon: Icons.admin_panel_settings_rounded,
    );

    if (!confirmed || !mounted) return;

    setState(() => _isSettingUp = true);

    try {
      final email = _emailController.text.trim().isEmpty
          ? 'admin@elshams.com'
          : _emailController.text.trim();
      final password = _passwordController.text.isEmpty
          ? 'admin123456'
          : _passwordController.text;

      // 1. Create or signIn in Auth
      UserCredential credential;
      try {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          rethrow;
        }
      }

      final uid = credential.user!.uid;

      // 2. Set Firestore user role as admin
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .set({
        'email': email,
        'role': 'admin',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 3. Seed live price if missing
      final liveDoc = await FirebaseFirestore.instance
          .collection(FirebaseConstants.settingsCollection)
          .doc(FirebaseConstants.livePriceDoc)
          .get();

      if (!liveDoc.exists) {
        await FirebaseFirestore.instance
            .collection(FirebaseConstants.settingsCollection)
            .doc(FirebaseConstants.livePriceDoc)
            .set({
          'livePrice': 100.0,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': email,
        });
      }

      // 4. Seed products if missing
      final prodSnap = await FirebaseFirestore.instance
          .collection(FirebaseConstants.productsCollection)
          .get();

      if (prodSnap.docs.length < 5) {
        final products = [
          {'name': 'فراخ كاملة', 'multiplier': 1.60, 'increase': 25.0, 'order': 0},
          {'name': 'صدور بالعظم', 'multiplier': 1.55, 'increase': 25.0, 'order': 1},
          {'name': 'ورك عادة', 'multiplier': 1.25, 'increase': 20.0, 'order': 2},
          {'name': 'ورك مقصف', 'multiplier': 1.45, 'increase': 25.0, 'order': 3},
          {'name': 'دبوس', 'multiplier': 1.30, 'increase': 20.0, 'order': 4},
          {'name': 'شيش بالجلد', 'multiplier': 1.65, 'increase': 30.0, 'order': 5},
          {'name': 'شيش كامل بدون جلد', 'multiplier': 1.80, 'increase': 30.0, 'order': 6},
          {'name': 'فيليه', 'multiplier': 2.95, 'increase': 25.0, 'order': 7},
          {'name': 'شاورما مسحب', 'multiplier': 2.10, 'increase': 25.0, 'order': 8},
          {'name': 'صدور فيليه بالجلد', 'multiplier': 2.70, 'increase': 25.0, 'order': 9},
        ];

        final batch = FirebaseFirestore.instance.batch();
        for (final p in products) {
          final ref = FirebaseFirestore.instance
              .collection(FirebaseConstants.productsCollection)
              .doc();
          batch.set(ref, {
            ...p,
            'isActive': true,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'createdBy': email,
            'updatedBy': email,
          });
        }
        await batch.commit();
      }

      if (mounted) {
        AppSnackbar.showSuccess(context, 'تمت تهيئة حساب الأدمن وقاعدة البيانات بنجاح!');
        // Refresh prices immediately
        context.read<PricesCubit>().loadPrices();
        await context.read<AuthCubit>().login(email: email, password: password);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'تعذرت التهيئة: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isSettingUp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (PlatformUtils.isDesktop) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go(RouteNames.desktopHome);
            }
          } else {
            context.go(RouteNames.adminDashboard);
          }
        }
        if (state is AuthError) {
          AppSnackbar.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1208),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.primary),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go(PlatformUtils.isDesktop ? RouteNames.desktopHome : RouteNames.home);
              }
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.base),
                // Logo
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppAssets.logo,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 90,
                        height: 90,
                        color: AppColors.primary,
                        child: const Icon(Icons.admin_panel_settings, size: 44, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.adminLogin,
                  style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: AppStrings.email,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        textInputAction: TextInputAction.next,
                        isDark: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.emailRequired;
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                            return AppStrings.emailInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.base),
                      AppTextField(
                        label: AppStrings.password,
                        controller: _passwordController,
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        textInputAction: TextInputAction.done,
                        onEditingComplete: _login,
                        isDark: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.passwordRequired;
                          }
                          if (value.length < 6) {
                            return AppStrings.passwordTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return AppButton(
                            label: AppStrings.loginButton,
                            onPressed: _login,
                            isLoading: state is AuthLoading,
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // First-time setup button
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.adminSurface,
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'لأول مرة فقط أو لإنشاء الحساب وقاعدة البيانات:',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _isSettingUp ? null : _setupFirstTimeAdmin,
                                icon: _isSettingUp
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : const Icon(Icons.auto_fix_high_rounded, size: 18),
                                label: Text(
                                  _isSettingUp ? 'جارٍ التجهيز...' : 'تهيئة حساب الأدمن والبيانات الأساسية',
                                  style: AppTextStyles.buttonMedium.copyWith(color: AppColors.primary),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primary),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
