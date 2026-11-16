
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_drawer.dart';
import 'appointments/screens/doctor_appointments_screen.dart';

class DoctorShell extends StatelessWidget {
  const DoctorShell({super.key});

  static const List<DrawerItem> _items = [
    DrawerItem(
      Icons.calendar_month_outlined,
      Icons.calendar_month_rounded,
      'Gestion des rendez-vous',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: theme.colorScheme.surface,
          statusBarIconBrightness:
              isLight ? Brightness.dark : Brightness.light,
          statusBarBrightness:
              isLight ? Brightness.light : Brightness.dark,
        ),
        title: const Text(
          'MedFlow Pro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      drawer: AppDrawer(
        selectedIndex: 0,
        items: _items,
        spaceLabel: 'Espace médecin',
        onSelect: (index) {
          // The appointment-management page is currently the only
          // implemented Doctor navigation destination.
        },
      ),

      body: const SafeArea(
        child: DoctorAppointmentsScreen(),
      ),
    );
  }
}
