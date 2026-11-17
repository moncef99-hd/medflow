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
    final displayName = name.trim().isEmpty ? 'Utilisateur' : name.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.65),
                    width: 2,
                  ),
                ),
                child: AppAvatar(
                  name: displayName,
                  size: 82,
                  borderColor: Colors.white,
                ),
              ),
              Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary, width: 2),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.mintText,
                  size: 17,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          if (email.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 15,
                  color: Colors.white.withValues(alpha: 0.80),
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.90),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (phone.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 15,
                  color: Colors.white.withValues(alpha: 0.80),
                ),
                const SizedBox(width: 7),
                Text(
                  phone,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.90),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 19),

          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('Modifier mon profil'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.13),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.40)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
