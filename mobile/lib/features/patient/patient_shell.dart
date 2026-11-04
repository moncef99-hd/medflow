import 'package:flutter/material.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import 'home/home_screen.dart';

class PatientShell extends StatefulWidget {
  const PatientShell({super.key});

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  int _tab = 0;

  late final List<Widget> _pages = [
    HomeScreen(onSearchTap: () => setState(() => _tab = 1)),
    const _TabPlaceholder('Recherche'), // Haddad: search screen
    const _TabPlaceholder('Mes rendez-vous'), // Hiba: appointments screen
    const _TabPlaceholder('File d\'attente'), // Hiba: queue screen
    const _TabPlaceholder('Profil'), // settings screen (block 2)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _pages),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  final String title;
  const _TabPlaceholder(this.title);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(child: Text('$title : bientôt disponible')),
    );
  }
}