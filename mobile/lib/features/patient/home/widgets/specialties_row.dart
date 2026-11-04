import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SpecialtiesRow extends StatelessWidget {
  final VoidCallback onTap;
  const SpecialtiesRow({super.key, required this.onTap});

  static const _items = <(IconData, String)>[
    (Icons.favorite_rounded, 'Cardiologue'),
    (Icons.face_retouching_natural_rounded, 'Dermatologue'),
    (Icons.child_care_rounded, 'Pédiatre'),
    (Icons.medical_services_rounded, 'Généraliste'),
    (Icons.visibility_rounded, 'Ophtalmo'),
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? AppColors.lightSurface : AppColors.darkSurface;
    final border = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final item = _items[i];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              width: 88,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.$1, color: AppColors.primary, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    item.$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}