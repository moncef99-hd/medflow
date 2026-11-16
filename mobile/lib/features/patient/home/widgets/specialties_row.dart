import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/quick_action_tile.dart';

class SpecialtiesRow extends StatelessWidget {
  final ValueChanged<String> onTap;

  const SpecialtiesRow({super.key, required this.onTap});

  static const _items = <(IconData, String, Color)>[
    (Icons.favorite_rounded, 'Cardiologue', Color(0xFFEF6B83)),
    (Icons.face_retouching_natural_rounded, 'Dermatologue', Color(0xFF9875E8)),
    (Icons.child_care_rounded, 'Pédiatre', Color(0xFFF0A44B)),
    (Icons.medical_services_rounded, 'Généraliste', AppColors.primary),
    (Icons.visibility_rounded, 'Ophtalmo', Color(0xFF28A9B8)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(vertical: 7),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final item = _items[index];

          return SizedBox(
            width: 92,
            child: QuickActionTile(
              icon: item.$1,
              label: item.$2,
              color: item.$3,
              compact: true,
              onTap: () => onTap(item.$2),
            ),
          );
        },
      ),
    );
  }
}
