import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes/app_routes.dart';
import '../../core/session/user_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';
import '../../shared/widgets/app_avatar.dart';
import 'appointments/screens/doctor_appointments_screen.dart';
import 'dashboard/screens/dashboard_screen.dart';
import 'patients/screens/patients_screen.dart';
import 'planning/screens/doctor_planning_screen.dart';

class DoctorShell extends StatefulWidget {
  const DoctorShell({super.key});

  @override
  State<DoctorShell> createState() => _DoctorShellState();
}

class _DoctorShellState extends State<DoctorShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    DoctorAppointmentsScreen(),
    PatientsScreen(),
    DoctorPlanningScreen(),
  ];

  void _selectDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Vous devrez vous reconnecter pour continuer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      UserSession.clear();
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: theme.colorScheme.surface,
          statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
          statusBarBrightness: isLight ? Brightness.light : Brightness.dark,
        ),
        titleSpacing: 4,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'MedFlow Pro',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  'ESPACE MÉDECIN',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      drawer: _DoctorDrawer(
        selectedIndex: _selectedIndex,
        onSelect: _selectDestination,
        onLogout: _logout,
      ),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _screens),
      ),
    );
  }
}

class _DoctorDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;

  const _DoctorDrawer({
    required this.selectedIndex,
    required this.onSelect,
    required this.onLogout,
  });

  Widget _destinationTile({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String title,
    required bool isLight,
  }) {
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: isSelected
            ? (isLight
                  ? AppColors.softBlue
                  : AppColors.primary.withValues(alpha: 0.18))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () {
            Navigator.pop(context);
            onSelect(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.10)
                        : (isLight ? AppColors.lightBg : AppColors.darkBg),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.primary
                        : (isLight
                              ? AppColors.lightMuted
                              : AppColors.darkMuted),
                    size: 21,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primary,
                    size: 13,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
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
            builder: (context, name, child) {
              final displayName = name.trim().isEmpty ? 'Médecin' : name.trim();

              return Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  22,
                  media.padding.top + 28,
                  22,
                  26,
                ),
                decoration: const BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
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
                            color: Colors.black.withValues(alpha: 0.16),
                            blurRadius: 20,
                            offset: const Offset(0, 7),
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
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.glassWhite,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: AppColors.mint,
                            size: 15,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'ESPACE PROFESSIONNEL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
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
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 12),
                  child: Text(
                    'ESPACE MÉDECIN',
                    style: TextStyle(
                      color: muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _destinationTile(
                  context: context,
                  index: 0,
                  icon: Icons.dashboard_rounded,
                  title: 'Tableau de bord',
                  isLight: isLight,
                ),
                _destinationTile(
                  context: context,
                  index: 1,
                  icon: Icons.calendar_month_rounded,
                  title: 'Gestion des rendez-vous',
                  isLight: isLight,
                ),
                _destinationTile(
                  context: context,
                  index: 2,
                  icon: Icons.people_alt_rounded,
                  title: 'Gestion des patients',
                  isLight: isLight,
                ),
                _destinationTile(
                  context: context,
                  index: 3,
                  icon: Icons.event_available_rounded,
                  title: 'Planning & disponibilités',
                  isLight: isLight,
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, media.padding.bottom + 14),
            child: Column(
              children: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeMode,
                  builder: (context, mode, child) {
                    final isDark = mode == ThemeMode.dark;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 5,
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: onLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
