import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'shared/widgets/app_avatar.dart';
import 'shared/widgets/app_bottom_nav.dart';
import 'shared/widgets/doctor_card.dart';
import 'shared/widgets/gradient_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (_, mode, __) => MaterialApp(
        title: 'MedFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: const ThemePreview(),
      ),
    );
  }
}

class ThemePreview extends StatefulWidget {
  const ThemePreview({super.key});

  @override
  State<ThemePreview> createState() => _ThemePreviewState();
}

class _ThemePreviewState extends State<ThemePreview> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6_rounded),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Bonjour 👋',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              AppAvatar(name: 'Mohamed Haddad'),
              SizedBox(width: 12),
              AppAvatar(name: 'Hiba Kaabi', size: 40),
            ],
          ),
          const SizedBox(height: 16),
          const DoctorCard(
            name: 'Dr. Sami Ben Ali',
            specialty: 'Cardiologue',
            location: 'Tunis, Lac 2',
            rating: 4.8,
            nextSlot: 'Aujourd\'hui 16:30',
          ),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(hintText: 'Rechercher')),
          const SizedBox(height: 16),
          GradientButton(
            label: 'Prendre rendez-vous',
            icon: Icons.calendar_month_rounded,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          const GradientButton(label: 'Désactivé', onPressed: null),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }
}