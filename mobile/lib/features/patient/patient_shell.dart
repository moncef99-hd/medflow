
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_drawer.dart';
import 'appointments/screens/appointments_screen.dart';
import 'family/screens/family_screen.dart';
import 'history/screens/history_screen.dart';
import 'home/home_screen.dart';
import 'queue/screens/queue_screen.dart';
import 'search/search_screen.dart';
import 'settings/profile_screen.dart';

class PatientShell extends StatefulWidget {
  const PatientShell({super.key});

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  int _tab = 0;

  static const _pageTitles = [
    'Accueil',
    'Recherche',
    'Mes rendez-vous',
    "File d'attente",
    'Ma famille',
    'Historique médical',
    'Profil',
  ];

  static const _items = <DrawerItem>[
    DrawerItem(
      Icons.home_outlined,
      Icons.home_rounded,
      'Accueil',
      pageIndex: 0,
    ),
    DrawerItem(
      Icons.calendar_month_outlined,
      Icons.calendar_month_rounded,
      'Mes rendez-vous',
      pageIndex: 2,
    ),
    DrawerItem(
      Icons.people_outline_rounded,
      Icons.people_rounded,
      "File d'attente",
      pageIndex: 3,
    ),
    DrawerItem(
      Icons.family_restroom_rounded,
      Icons.family_restroom_rounded,
      'Ma famille',
      pageIndex: 4,
    ),
    DrawerItem(
      Icons.medical_information_outlined,
      Icons.medical_information_rounded,
      'Historique médical',
      pageIndex: 5,
    ),
    DrawerItem(
      Icons.person_outline_rounded,
      Icons.person_rounded,
      'Profil',
      pageIndex: 6,
    ),
  ];

  late final List<Widget> _pages = [
    HomeScreen(
      onSearchTap: () => setState(() => _tab = 1),
    ),
    const SearchScreen(),
    const AppointmentsScreen(),
    const QueueScreen(),
    const FamilyScreen(),
    const HistoryScreen(),
    ProfileScreen(
      onHistoryTap: () => setState(() => _tab = 5),
    ),
  ];

  void _goToHome() {
    setState(() => _tab = 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHome = _tab == 0;

    final needsBackArrow =
        _tab == 1 ||
        _tab == 2 ||
        _tab == 3 ||
        _tab == 4 ||
        _tab == 5 ||
        _tab == 6;

    return PopScope(
      canPop: !needsBackArrow,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && needsBackArrow) {
          _goToHome();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: !needsBackArrow,
          toolbarHeight: 64,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          leading: needsBackArrow
              ? IconButton(
                  tooltip: "Retour à l'accueil",
                  onPressed: _goToHome,
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: theme.colorScheme.onSurface,
                )
              : null,
          title: isHome
              ? const SizedBox.shrink()
              : Text(
                  _pageTitles[_tab],
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                tooltip: 'Notifications',
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  size: 25,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        drawer: AppDrawer(
          selectedIndex: _tab,
          items: _items,
          onSelect: (index) => setState(() => _tab = index),
        ),
        body: IndexedStack(
          index: _tab,
          children: _pages,
        ),
      ),
    );
  }
}
