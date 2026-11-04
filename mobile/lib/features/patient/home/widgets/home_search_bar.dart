import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const HomeSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final surface = isLight ? AppColors.lightSurface : AppColors.darkSurface;
    final border = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    return Material(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: muted),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Rechercher un médecin, une spécialité...',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted, fontSize: 14),
                ),
              ),
              const Icon(Icons.tune_rounded, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}