import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Rounded surface card with a subtle shadow and optional tap action.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface =
        color ?? (isLight ? AppColors.lightSurface : AppColors.darkSurface);
    final radius = BorderRadius.circular(AppColors.cardRadius);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: radius,
        border: isLight ? null : Border.all(color: AppColors.darkBorder),
        boxShadow: isLight ? AppColors.cardShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
