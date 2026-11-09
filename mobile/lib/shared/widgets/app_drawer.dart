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
  const DrawerItem(this.icon, this.selectedIcon, this.label);
}

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final List<DrawerItem> items;
  final ValueChanged<int> onSelect;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onSelect,
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
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final media = MediaQuery.of(context);

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, media.padding.top + 24, 20, 20),
            decoration: const BoxDecoration(gradient: AppColors.gradient),
            child: ValueListenableBuilder<String>(
              valueListenable: UserSession.name,
              builder: (_, name, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: AppAvatar(name: name, size: 56),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'Espace patient',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              children: [
                for (var i = 0; i < items.length; i++)
                  _DrawerTile(
                    item: items[i],
                    selected: i == selectedIndex,
                    muted: muted,
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(i);
                    },
                  ),
              ],
            ),
          ),

          // Footer: theme switch + logout
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, media.padding.bottom + 8),
            child: Column(
              children: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeMode,
                  builder: (_, mode, __) => ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Icon(Icons.dark_mode_outlined, color: muted),
                    title: const Text('Mode sombre',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Switch(
                      value: mode == ThemeMode.dark,
                      onChanged: (_) => toggleTheme(),
                    ),
                  ),
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  leading:
                      const Icon(Icons.logout_rounded, color: AppColors.danger),
                  title: const Text('Se déconnecter',
                      style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
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
  final VoidCallback onTap;

  const _DrawerTile({
    required this.item,
    required this.selected,
    required this.muted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  selected ? item.selectedIcon : item.icon,
                  color: selected ? AppColors.primary : muted,
                ),
                const SizedBox(width: 14),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? AppColors.primary : null,
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