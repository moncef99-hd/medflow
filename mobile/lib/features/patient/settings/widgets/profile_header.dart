import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final VoidCallback onEdit;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final surface = isLight ? AppColors.lightSurface : AppColors.darkSurface;
    final border = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          AppAvatar(name: name, size: 84),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          if (email.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(email, style: TextStyle(color: muted, fontSize: 13)),
            ),
          if (phone.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(phone, style: TextStyle(color: muted, fontSize: 13)),
            ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('Modifier le profil'),
          ),
        ],
      ),
    );
  }
}