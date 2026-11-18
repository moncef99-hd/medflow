import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PatientSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String value;
  final TextEditingController controller;

  const PatientSearchBar({
    super.key,
    required this.onChanged,
    required this.onClear,
    required this.value,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.45)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Rechercher un patient...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
          ),
          suffixIcon: value.isNotEmpty
              ? IconButton(
                  tooltip: 'Effacer la recherche',
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 17,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
