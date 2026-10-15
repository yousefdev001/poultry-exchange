import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/responsive/platform_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/watermark_background.dart';
import '../../../../routing/route_names.dart';

class LandingScreen extends StatelessWidget {
  final void Function(int index)? onNavigateToTab;
  final VoidCallback? onSwitchToAdmin;

  const LandingScreen({super.key, this.onNavigateToTab, this.onSwitchToAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('دواجن الشمس'),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (PlatformUtils.isDesktop && onSwitchToAdmin != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1208),
                  foregroundColor: AppColors.primary,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                  ),
                ),
                icon: const Icon(Icons.admin_panel_settings_rounded, size: 18),
                label: const Text(
                  'لوحة تحكم الإدارة',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                onPressed: onSwitchToAdmin,
              ),
            ),
        ],
      ),
      body: WatermarkBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo Header with 7-tap admin gesture
              Center(
                child: _SecretAdminTap(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppAssets.logo,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 100,
                          height: 100,
                          color: AppColors.primary,
                          child: const Icon(Icons.store,
                              color: Colors.white, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'الشمس لإنتاج مصنعات اللحوم والدواجن',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '«أنت معنا في أمان»',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Overview Card ("نبذة عن الشركة")
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
                  border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.6)),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.info_outline_rounded,
                              color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'نبذة عن الشركة',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'منذ 2008 ونحن نضع الجودة والثقة في مقدمة أولوياتنا.\n'
                      'بدأت مسيرتنا عام 2008 في مجال تعبئة المواد الغذائية وإنتاج وتوريد الدواجن الطازجة والمجمدة، واستطعنا على مدار سنوات العمل أن نبني خبرة قوية وعلاقات طويلة الأمد مع عملائنا في مختلف القطاعات.\n\n'
                      'ومن أبرز منتجات الدواجن التي تعاملنا معها:\n'
                      '• دجاج فروج شهية\n'
                      '• دجاج طعمة وشهية\n'
                      '• دجاج ماس\n'
                      '• دجاج نور\n\n'
                      'ومع تطور أعمالنا، توسع نشاطنا ليشمل إنتاج مصنعات اللحوم والدواجن، مع الالتزام بأعلى معايير الجودة والسلامة الغذائية، وتقديم منتجات تحظى بثقة العديد من العملاء.\n\n'
                      'وتخدم منتجاتنا مجموعة متنوعة من القطاعات، منها:\n'
                      'الفنادق • شركات الكاترينج • المستشفيات • الهيئات الحكومية • النوادي • المطاعم\n\n'
                      'نحرص دائمًا على اختيار أفضل الخامات، والاهتمام بكل مراحل الإنتاج والتصنيع والتعبئة، لنقدم منتجات تجمع بين الجودة، الأمان، والطعم المميز.\n\n'
                      'شعارنا:\n'
                      'الشمس لإنتاج مصنعات اللحوم والدواجن\n'
                      '«أنت معنا في أمان»',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.65,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Sections Header
              Text(
                'أقسام التطبيق والأسعار',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Navigation Cards Grid/List
              _buildSectionCard(
                title: 'أسعار الدجاج',
                subtitle: 'المجمدات والمصنعات الطازجة وفق معادلة السعر الحي',
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFFE8620A),
                tabIndex: 1,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildSectionCard(
                title: 'أسعار اللحم الحي',
                subtitle: 'أسعار الدجاج الحي الكبير والبط وغيره محدثة يومياً',
                icon: Icons.storefront_rounded,
                color: AppColors.primary,
                tabIndex: 2,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildSectionCard(
                title: 'أسعار الكتاكيت',
                subtitle: 'أسعار وأنواع الكتاكيت من كبرى الشركات',
                icon: Icons.cruelty_free_outlined,
                color: const Color(0xFFF57C00),
                tabIndex: 3,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildSectionCard(
                title: 'أسعار البيض',
                subtitle: 'بورصة أسعار كرتونة البيض (أبيض - أحمر - بلدي)',
                icon: Icons.egg_outlined,
                color: const Color(0xFFD4A017),
                tabIndex: 4,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildSectionCard(
                title: 'المعرض',
                subtitle: 'صور وفيديوهات لمنتجاتنا ومراحل الجودة والتعبئة',
                icon: Icons.photo_library_outlined,
                color: const Color(0xFF2E7D32),
                tabIndex: 5,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Luxury Quality Highlights Footer
              _buildLuxuryFooter(),

              const SizedBox(height: AppSpacing.lg),

              // Contact Section
              _buildContactSection(),

              const SizedBox(height: AppSpacing.lg),

              // Developer Copyright
              _buildDeveloperCopyright(),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int tabIndex,
  }) {
    return InkWell(
      onTap: () => onNavigateToTab?.call(tabIndex),
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildLuxuryFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF261908), Color(0xFF191004)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33D4A017), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 1.5, width: 28, color: AppColors.primary),
              const SizedBox(width: 8),
              const Icon(Icons.stars_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                'دواجن الشمس',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.stars_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Container(height: 1.5, width: 28, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildLuxuryTextItem('فريش إنتاج اليوم'),
          const SizedBox(height: 8),
          _buildLuxuryTextItem('عبوات شكاير و كرتون'),
          const SizedBox(height: 8),
          _buildLuxuryTextItem('بدون أي نسب ماء نهائيا'),
          const SizedBox(height: 8),
          _buildLuxuryTextItem('شغل يشرفك في أي وقت وفي كل مكان.'),
        ],
      ),
    );
  }

  Widget _buildLuxuryTextItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_rounded,
            color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'أرقام التواصل والطلبات',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // موبايل وواتساب
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.phone_android_rounded,
                    color: Color(0xFF2E7D32), size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'للاتصال والواتساب',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textHint),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '01016666423',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _makeCall('01016666423'),
                icon: const Icon(Icons.phone_forwarded_rounded,
                    color: AppColors.primary),
                tooltip: 'اتصال',
              ),
              IconButton(
                onPressed: () => _openWhatsApp('01016666423'),
                icon: const Icon(Icons.chat_rounded, color: Color(0xFF25D366)),
                tooltip: 'محادثة واتساب',
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // أرضي
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.priceBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.phone_in_talk_rounded,
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الهاتف الأرضي',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textHint),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '0553956055',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _makeCall('0553956055'),
                icon: const Icon(Icons.phone_forwarded_rounded,
                    color: AppColors.primary),
                tooltip: 'اتصال',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperCopyright() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.code_rounded,
                    size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text(
                'تصميم وتطوير:',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textHint,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Yousef Sallam',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.priceBackground,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => _makeCall('01000585478'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone_rounded,
                          size: 15, color: AppColors.primary),
                      const SizedBox(width: 6),
                      const Text(
                        '01000585478',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 1,
                  height: 14,
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _openWhatsApp('01000585478',
                      'السلام عليكم يا بشمهندس يوسف، تواصل بخصوص التطبيق'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_rounded,
                          size: 15, color: Color(0xFF25D366)),
                      SizedBox(width: 4),
                      Text(
                        'واتساب',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© ${DateTime.now().year} Yousef Sallam. All Rights Reserved.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textHint.withValues(alpha: 0.7),
              fontSize: 11,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  Future<void> _openWhatsApp(String phone, [String? message]) async {
    final clean = phone.startsWith('0') ? '2$phone' : phone;
    final msg = message ??
        "السلام عليكم ورحمة الله، أريد الاستفسار عن أسعار دواجن الشمس";
    final uri =
        Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent(msg)}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}

// 7-tap gesture for Admin login
class _SecretAdminTap extends StatefulWidget {
  final Widget child;
  const _SecretAdminTap({required this.child});

  @override
  State<_SecretAdminTap> createState() => _SecretAdminTapState();
}

class _SecretAdminTapState extends State<_SecretAdminTap> {
  int _tapCount = 0;
  DateTime? _firstTapTime;

  void _onTap() {
    final now = DateTime.now();
    if (_firstTapTime == null ||
        now.difference(_firstTapTime!) > const Duration(seconds: 4)) {
      _tapCount = 1;
      _firstTapTime = now;
    } else {
      _tapCount++;
    }

    if (_tapCount >= 7) {
      _tapCount = 0;
      _firstTapTime = null;
      context.push(RouteNames.adminLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isDesktop) {
      return widget.child;
    }
    return GestureDetector(
      onTap: _onTap,
      child: widget.child,
    );
  }
}
