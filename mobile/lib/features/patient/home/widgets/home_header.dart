import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../shared/widgets/app_avatar.dart';

class HomeHeader extends StatelessWidget {
  final String fullName;
  const HomeHeader({super.key, required this.fullName});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final firstName = fullName.split(' ').first;

    return Row(
      children: [
        AppAvatar(name: fullName, size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour, $firstName 👋',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Text(
                'Comment allez-vous aujourd\'hui ?',
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.brightness_6_rounded),
          onPressed: toggleTheme,
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
          onPressed: () {},
        ),
      ],
    );
  }
}