import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/session/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../shared/widgets/gradient_header.dart';
import 'widgets/edit_profile_sheet.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_tile.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onHistoryTap;

  const ProfileScreen({super.key, required this.onHistoryTap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;

  void _soon(String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$text : bientôt disponible')));
  }

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text(
          'Vous devrez vous reconnecter pour accéder à vos rendez-vous.',
        ),
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
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        children: [
          GradientHeader(
            title: 'Mon profil',
            subtitle: 'Gérez vos informations et vos préférences.',
            trailing: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),

          const SizedBox(height: 20),

          ListenableBuilder(
            listenable: Listenable.merge([
              UserSession.name,
              UserSession.email,
              UserSession.phone,
            ]),
            builder: (_, __) => ProfileHeader(
              name: UserSession.name.value,
              email: UserSession.email.value,
              phone: UserSession.phone.value,
              onEdit: () => showEditProfileSheet(context),
            ),
          ),

          const SizedBox(height: 28),

          SettingsGroup(
            title: 'Mon compte',
            children: [
              SettingsTile(
                icon: Icons.person_outline_rounded,
                title: 'Informations personnelles',
                subtitle: 'Modifier votre nom et téléphone',
                onTap: () => showEditProfileSheet(context),
              ),
              SettingsTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Rappels de rendez-vous et file d’attente',
                onTap: () {
                  setState(() => _notifications = !_notifications);
                },
                trailing: Switch.adaptive(
                  value: _notifications,
                  activeTrackColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() => _notifications = value);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SettingsGroup(
            title: 'Mon espace santé',
            children: [
              SettingsTile(
                icon: Icons.history_rounded,
                title: 'Historique médical',
                subtitle: 'Retrouvez vos anciennes consultations',
                onTap: widget.onHistoryTap,
              ),
            ],
          ),

          const SizedBox(height: 22),

          SettingsGroup(
            title: 'Préférences',
            children: [
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeMode,
                builder: (_, mode, __) => SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Mode sombre',
                  subtitle: mode == ThemeMode.dark ? 'Activé' : 'Désactivé',
                  onTap: toggleTheme,
                  trailing: Switch.adaptive(
                    value: mode == ThemeMode.dark,
                    activeTrackColor: AppColors.primary,
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

          const SizedBox(height: 22),

          SettingsGroup(
            title: 'Besoin d’aide ?',
            children: [
              SettingsTile(
                icon: Icons.help_outline_rounded,
                title: 'Aide et support',
                subtitle: 'Nous sommes là pour vous aider',
                onTap: () => _soon('Aide et support'),
              ),
              SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'À propos de MedFlow',
                subtitle: 'Version 1.0.0',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'MedFlow',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2026 MedFlow',
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SettingsGroup(
            title: 'Session',
            children: [
              SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Déconnexion',
                subtitle: 'Quitter votre espace personnel',
                danger: true,
                onTap: _confirmLogout,
              ),
            ],
          ),

          const SizedBox(height: 28),

          Center(
            child: Column(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: AppColors.headerGradient,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'MedFlow',
                  style: TextStyle(
                    color: muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Votre santé, notre priorité.',
                  style: TextStyle(color: muted, fontSize: 11),
                ),
                const SizedBox(height: 5),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: muted.withValues(alpha: 0.75),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
