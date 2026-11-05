
import 'package:flutter/material.dart';

import '../../shared/widgets/app_bottom_nav.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'appointments/screens/appointments_screen.dart';
import 'queue/screens/queue_screen.dart';
import 'family/screens/family_screen.dart';
import 'settings/profile_screen.dart';

class PatientShell extends StatefulWidget {
  const PatientShell({super.key});

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  int _tab = 0;

  late final List<Widget> _pages = [
    HomeScreen(onSearchTap: () => setState(() => _tab = 1)),
    const SearchScreen(),
    const AppointmentsScreen(),
    const QueueScreen(),
    const FamilyScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }
}
