import 'package:flutter/material.dart';

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

  static const Color _blue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Rechercher un patient...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
            fontSize: 13,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 5, right: 8),
            child: Icon(Icons.search_rounded, color: _blue, size: 23),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 52),
          suffixIcon: value.isNotEmpty
              ? IconButton(
                  tooltip: 'Effacer la recherche',
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 19,
                    color: Color(0xFF64748B),
                  ),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
