import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'soft_card.dart';

/// Quick-access tile with a tinted circular icon and optional badge.
class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final int? badge;
  final bool compact;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.color = AppColors.primary,
    this.onTap,
    this.badge,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final circleSize = compact ? 36.0 : 40.0;
    final iconSize = compact ? 18.0 : 21.0;

    return SoftCard(
      padding: EdgeInsets.symmetric(
        vertical: compact ? 9 : 14,
        horizontal: compact ? 5 : 8,
      ),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: iconSize),
              ),
              if (badge != null && badge! > 0)
                Positioned(
                  top: -5,
                  right: -7,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 19),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(AppColors.pillRadius),
                    ),
                    child: Text(
                      '$badge',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: compact ? 6 : 9),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
