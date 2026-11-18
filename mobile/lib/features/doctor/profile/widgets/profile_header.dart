import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_avatar.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String specialty;
  final String? photoPath;
  final VoidCallback onChangePhoto;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.specialty,
    required this.photoPath,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSpecialty = specialty.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AppAvatar(
                name: name,
                imageFilePath: photoPath,
                size: 112,
                borderColor: Colors.white,
              ),
              Positioned(
                right: -2,
                bottom: 0,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onChangePhoto,
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(9),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.primary,
                        size: 19,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            name.trim().isEmpty ? 'Nom du médecin' : name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            hasSpecialty ? specialty : 'Spécialité à renseigner',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (email.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.white70,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 15),
          OutlinedButton.icon(
            onPressed: onChangePhoto,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            icon: const Icon(Icons.edit_rounded, size: 17),
            label: const Text('Modifier la photo'),
          ),
        ],
      ),
    );
  }
}
