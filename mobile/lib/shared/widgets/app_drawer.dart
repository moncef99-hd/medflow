import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/session/user_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';
import 'app_avatar.dart';

class DrawerItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int? pageIndex;

  const DrawerItem(this.icon, this.selectedIcon, this.label, {this.pageIndex});
}

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final List<DrawerItem> items;
  final ValueChanged<int> onSelect;
  final String spaceLabel;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onSelect,
    this.spaceLabel = 'Espace patient',
  });

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Vous devrez vous reconnecter pour continuer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      UserSession.clear();
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final surface = isLight ? Colors.white : AppColors.darkSurface;
    final media = MediaQuery.of(context);

    return Drawer(
      backgroundColor: surface,
      child: Column(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: UserSession.name,
            builder: (_, name, __) {
              final displayName = name.trim().isEmpty ? 'Patient' : name.trim();

              return Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  20,
                  media.padding.top + 28,
                  20,
                  28,
                ),
                decoration: const BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppColors.headerRadius),
                    bottomRight: Radius.circular(AppColors.headerRadius),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.14),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: AppAvatar(
                        name: displayName,
                        size: 82,
                        borderColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.17),
                        borderRadius: BorderRadius.circular(
                          AppColors.pillRadius,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            spaceLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 12),
                  child: Text(
                    'MENU PRINCIPAL',
                    style: TextStyle(
                      color: muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                for (var i = 0; i < items.length; i++)
                  _DrawerTile(
                    item: items[i],
                    selected: (items[i].pageIndex ?? i) == selectedIndex,
                    muted: muted,
                    isLight: isLight,
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(items[i].pageIndex ?? i);
                    },
                  ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, media.padding.bottom + 12),
            child: Column(
              children: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeMode,
                  builder: (_, mode, __) {
                    final isDark = mode == ThemeMode.dark;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isLight ? AppColors.lightBg : AppColors.darkBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: AppColors.primary,
                            size: 21,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Mode sombre',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Switch.adaptive(
                            value: isDark,
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppColors.primary,
                            onChanged: (_) => toggleTheme(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.danger,
                    size: 21,
                  ),
                  title: const Text(
                    'Se déconnecter',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final DrawerItem item;
  final bool selected;
  final Color muted;
  final bool isLight;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.item,
    required this.selected,
    required this.muted,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected
              ? (isLight
                    ? AppColors.softBlue
                    : AppColors.primary.withValues(alpha: 0.20))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    selected ? item.selectedIcon : item.icon,
                    size: 21,
                    color: selected ? AppColors.primary : muted,
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: selected
                            ? AppColors.primary
                            : theme.colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (selected)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: AppColors.primary,
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
