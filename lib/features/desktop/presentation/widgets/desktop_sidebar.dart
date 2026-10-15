import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../screens/desktop_shell_screen.dart';

/// The sidebar navigation for the desktop shell.
/// Switches between user destinations and admin mode.
class DesktopSidebar extends StatelessWidget {
  final DesktopMode currentMode;
  final int selectedUserTab;
  final VoidCallback onModeToggle;
  final ValueChanged<int> onUserTabSelected;
  final VoidCallback onAdminPressed;
  final bool isAdminAuthenticated;

  const DesktopSidebar({
    super.key,
    required this.currentMode,
    required this.selectedUserTab,
    required this.onModeToggle,
    required this.onUserTabSelected,
    required this.onAdminPressed,
    required this.isAdminAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = currentMode == DesktopMode.admin;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: isAdmin ? AppColors.adminBackground : Colors.white,
        border: Border(
          left: BorderSide(
            color: isAdmin
                ? AppColors.adminPrimary.withValues(alpha: 0.3)
                : AppColors.border.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // App Header / Logo
          _buildHeader(isAdmin),

          const SizedBox(height: 8),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              children: _buildNavigationItems(isAdmin),
            ),
          ),

          // Admin Toggle Button (Always visible on desktop)
          _buildModeToggle(isAdmin),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isAdmin) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: isAdmin
            ? AppColors.adminSurface
            : AppColors.primary.withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(
            color: isAdmin
                ? AppColors.adminPrimary.withValues(alpha: 0.2)
                : AppColors.border.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAdmin
                  ? AppColors.adminPrimary.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isAdmin ? Icons.admin_panel_settings_rounded : Icons.storefront_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'دواجن الشمس',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isAdmin ? AppColors.primary : AppColors.primaryDark,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isAdmin ? 'لوحة التحكم' : 'واجهة المستخدم',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 11,
                    color: isAdmin
                        ? AppColors.primary.withValues(alpha: 0.6)
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNavigationItems(bool isAdmin) {
    if (isAdmin) {
      return [
        _SidebarLabel(
          text: 'لوحة التحكم',
          isAdmin: true,
        ),
        const SizedBox(height: 4),
        _buildAdminItem(),
      ];
    }

    return [
      _SidebarLabel(text: 'الأقسام', isAdmin: false),
      const SizedBox(height: 4),
      _SidebarItem(
        icon: Icons.home_rounded,
        label: 'الرئيسية',
        isSelected: selectedUserTab == 0,
        onTap: () => onUserTabSelected(0),
        isAdmin: false,
      ),
      _SidebarItem(
        icon: Icons.inventory_2_rounded,
        label: 'أسعار الدجاج',
        isSelected: selectedUserTab == 1,
        onTap: () => onUserTabSelected(1),
        isAdmin: false,
      ),
      _SidebarItem(
        icon: Icons.storefront_rounded,
        label: 'أسعار اللحم الحي',
        isSelected: selectedUserTab == 2,
        onTap: () => onUserTabSelected(2),
        isAdmin: false,
      ),
      _SidebarItem(
        icon: Icons.cruelty_free_rounded,
        label: 'الكتاكيت',
        isSelected: selectedUserTab == 3,
        onTap: () => onUserTabSelected(3),
        isAdmin: false,
      ),
      _SidebarItem(
        icon: Icons.egg_rounded,
        label: 'البيض',
        isSelected: selectedUserTab == 4,
        onTap: () => onUserTabSelected(4),
        isAdmin: false,
      ),
      _SidebarItem(
        icon: Icons.photo_library_rounded,
        label: 'المعرض',
        isSelected: selectedUserTab == 5,
        onTap: () => onUserTabSelected(5),
        isAdmin: false,
      ),
    ];
  }

  Widget _buildAdminItem() {
    return _SidebarItem(
      icon: Icons.dashboard_rounded,
      label: 'لوحة تحكم الأدمن',
      isSelected: true,
      onTap: onAdminPressed,
      isAdmin: true,
    );
  }

  Widget _buildModeToggle(bool isAdmin) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Divider(
            color: isAdmin
                ? AppColors.adminPrimary.withValues(alpha: 0.2)
                : AppColors.divider,
          ),
          const SizedBox(height: 4),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onModeToggle,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isAdmin
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.adminBackground.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isAdmin
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.border.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAdmin
                          ? Icons.person_rounded
                          : Icons.admin_panel_settings_rounded,
                      size: 18,
                      color: isAdmin ? AppColors.primary : AppColors.primaryDark,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isAdmin ? 'واجهة المستخدم' : 'لوحة التحكم',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              isAdmin ? AppColors.primary : AppColors.primaryDark,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.swap_horiz_rounded,
                      size: 16,
                      color: isAdmin
                          ? AppColors.primary.withValues(alpha: 0.6)
                          : AppColors.textHint,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ctrl + Shift + A',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 10,
              color: isAdmin
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : AppColors.textHint.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section label in the sidebar.
class _SidebarLabel extends StatelessWidget {
  final String text;
  final bool isAdmin;

  const _SidebarLabel({required this.text, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 4, bottom: 2),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isAdmin
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.textHint.withValues(alpha: 0.8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Individual navigation item in the sidebar.
class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isAdmin;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isAdmin,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final isAdmin = widget.isAdmin;

    Color bgColor;
    if (isSelected) {
      bgColor = isAdmin
          ? AppColors.adminPrimary.withValues(alpha: 0.15)
          : AppColors.primary.withValues(alpha: 0.1);
    } else if (_isHovered) {
      bgColor = isAdmin
          ? AppColors.adminSurface
          : AppColors.surfaceVariant.withValues(alpha: 0.7);
    } else {
      bgColor = Colors.transparent;
    }

    final iconColor = isSelected
        ? AppColors.primary
        : (isAdmin
            ? AppColors.primary.withValues(alpha: 0.5)
            : AppColors.textHint);

    final textColor = isSelected
        ? (isAdmin ? AppColors.primary : AppColors.primaryDark)
        : (isAdmin
            ? Colors.white.withValues(alpha: 0.7)
            : AppColors.textSecondary);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(widget.icon, size: 20, color: iconColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
