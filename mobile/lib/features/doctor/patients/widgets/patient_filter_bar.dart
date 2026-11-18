import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum PatientFilter { all, newPatients, followed, inactive, alerts }

class PatientFilterBar extends StatelessWidget {
  final PatientFilter selectedFilter;
  final ValueChanged<PatientFilter> onChanged;

  const PatientFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  static const List<(PatientFilter, String)> _filters = [
    (PatientFilter.all, 'Tous'),
    (PatientFilter.newPatients, 'Nouveaux'),
    (PatientFilter.followed, 'Suivis'),
    (PatientFilter.inactive, 'Inactifs'),
    (PatientFilter.alerts, 'Alertes'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index].$1;
          final label = _filters[index].$2;
          final isSelected = selectedFilter == filter;

          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onChanged(filter),
            showCheckmark: false,
            backgroundColor: theme.colorScheme.surface,
            selectedColor: AppColors.primary,
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : theme.dividerColor.withValues(alpha: 0.5),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          );
        },
      ),
    );
  }
}
