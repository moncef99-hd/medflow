import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/dashboard_models.dart';

class StatCard extends StatelessWidget {
  final DashboardStat stat;

  const StatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBorder.withValues(alpha: 0.75),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: stat.backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(stat.icon, color: stat.color, size: 22),
              ),
              const Spacer(),
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.success,
                size: 19,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            stat.value,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            stat.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lightMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
