import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/session/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import 'widgets/edit_profile_sheet.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;

  void _soon(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$text : bientôt disponible')));
  }

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Vous devrez vous reconnecter pour accéder à vos rendez-vous.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Déconnexion',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    UserSession.clear();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Text(
            'Profil',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: Listenable.merge(
              [UserSession.name, UserSession.email, UserSession.phone],
            ),
            builder: (_, __) => ProfileHeader(
              name: UserSession.name.value,
              email: UserSession.email.value,
              phone: UserSession.phone.value,
              onEdit: () => showEditProfileSheet(context),
            ),
          ),
          const SizedBox(height: 24),
          SettingsGroup(
            title: 'Compte',
            children: [
              SettingsTile(
                icon: Icons.person_outline_rounded,
                title: 'Informations personnelles',
                subtitle: 'Nom et téléphone',
                onTap: () => showEditProfileSheet(context),
              ),
              SettingsTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Rappels de rendez-vous et file d\'attente',
                onTap: () => setState(() => _notifications = !_notifications),
                trailing: Switch(
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SettingsGroup(
            title: 'Préférences',
            children: [
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeMode,
                builder: (_, mode, __) => SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Mode sombre',
                  onTap: toggleTheme,
                  trailing: Switch(
                    value: mode == ThemeMode.dark,
                    onChanged: (_) => toggleTheme(),
                  ),
                ),
              ),
              SettingsTile(
                icon: Icons.language_rounded,
                title: 'Langue',
                subtitle: 'Français',
                onTap: () => _soon('Choix de la langue'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SettingsGroup(
            title: 'Support',
            children: [
              SettingsTile(
                icon: Icons.help_outline_rounded,
                title: 'Aide et support',
                onTap: () => _soon('Aide et support'),
              ),
              SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'À propos de MedFlow',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'MedFlow',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2026 MedFlow',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SettingsGroup(
            title: 'Session',
            children: [
              SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Déconnexion',
                danger: true,
                onTap: _confirmLogout,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text('MedFlow 1.0.0', style: TextStyle(color: muted, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}