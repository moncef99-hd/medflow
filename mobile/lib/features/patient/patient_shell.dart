
import 'package:flutter/material.dart';

import '../../shared/widgets/app_drawer.dart';
import 'appointments/screens/appointments_screen.dart';
import 'family/screens/family_screen.dart';
import 'home/home_screen.dart';
import 'queue/screens/queue_screen.dart';
import 'search/search_screen.dart';
import 'settings/profile_screen.dart';
import 'history/screens/history_screen.dart';

class PatientShell extends StatefulWidget {
  const PatientShell({super.key});

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  int _tab = 0;

  static const _items = <DrawerItem>[
    DrawerItem(
      Icons.home_outlined,
      Icons.home_rounded,
      'Accueil',
    ),
    DrawerItem(
      Icons.search_rounded,
      Icons.search_rounded,
      'Recherche',
    ),
    DrawerItem(
      Icons.calendar_month_outlined,
      Icons.calendar_month_rounded,
      'Mes rendez-vous',
    ),
    DrawerItem(
      Icons.people_outline_rounded,
      Icons.people_rounded,
      'File d\'attente',
    ),
    DrawerItem(
      Icons.family_restroom_rounded,
      Icons.family_restroom_rounded,
      'Ma famille',
    ),
    DrawerItem(
      Icons.medical_information_outlined,
      Icons.medical_information_rounded,
      'Historique médical',
    ),
    DrawerItem(
      Icons.person_outline_rounded,
      Icons.person_rounded,
      'Profil',
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
      onHistoryTap: () {
        setState(() => _tab = 5);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _items[_tab].label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(
        selectedIndex: _tab,
        items: _items,
        onSelect: (i) => setState(() => _tab = i),
      ),
      body: IndexedStack(
        index: _tab,
        children: _pages,
      ),
    );
  }
}
