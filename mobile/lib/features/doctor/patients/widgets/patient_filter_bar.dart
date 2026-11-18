import 'package:flutter/material.dart';

enum PatientFilter { all, newPatients, followed, inactive, alerts }

class PatientFilterBar extends StatelessWidget {
  final PatientFilter selectedFilter;
  final ValueChanged<PatientFilter> onChanged;

  const PatientFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  static const Color _blue = Color(0xFF2563EB);

  static const List<(PatientFilter, String, IconData, Color)> _filters = [
    (PatientFilter.all, 'Tous', Icons.people_alt_outlined, Color(0xFF2563EB)),
    (
      PatientFilter.newPatients,
      'Nouveaux',
      Icons.person_add_alt_1_rounded,
      Color(0xFF8B5CF6),
    ),
    (
      PatientFilter.followed,
      'Suivis',
      Icons.check_circle_outline_rounded,
      Color(0xFF10B981),
    ),
    (
      PatientFilter.inactive,
      'Inactifs',
      Icons.schedule_rounded,
      Color(0xFFF59E0B),
    ),
    (
      PatientFilter.alerts,
      'Alertes',
      Icons.warning_amber_rounded,
      Color(0xFFEF4444),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final filter = _filters[index].$1;
          final label = _filters[index].$2;
          final icon = _filters[index].$3;
          final color = _filters[index].$4;
          final isSelected = selectedFilter == filter;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onChanged(filter),
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? _blue
                        : theme.dividerColor.withValues(alpha: 0.35),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _blue.withValues(alpha: 0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 15,
                      color: isSelected ? Colors.white : color,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
