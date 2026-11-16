import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/soft_card.dart';
import '../../../../shared/widgets/status_chip.dart';

class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({super.key});

  Widget _infoItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final border = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    return SoftCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.event_available_rounded,
                  color: AppColors.primary,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Prochain rendez-vous',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              const StatusChip(
                label: 'Confirmé',
                color: AppColors.success,
                icon: Icons.check_circle_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const AppAvatar(
                name: 'Dr. Sami Ben Ali',
                imageUrl:
                    'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=300&h=300&fit=crop&crop=face',
                size: 56,
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Sami Ben Ali',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Cardiologue',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 15, color: muted),
            ],
          ),
          const SizedBox(height: 17),
          Divider(color: border, height: 1),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoItem(Icons.calendar_today_rounded, 'Jeu 5 Nov'),
              _infoItem(Icons.access_time_rounded, '10:30'),
              _infoItem(Icons.people_outline_rounded, 'File : 3e'),
            ],
          ),
        ],
      ),
    );
  }
}
