import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final Color? borderColor;
  final bool showInitialsFallback;

  const AppAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 48,
    this.borderColor,
    this.showInitialsFallback = true,
  });

  String get _initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Widget _fallback() {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: AppColors.gradient,
        shape: BoxShape.circle,
      ),
      child: showInitialsFallback
          ? Text(
              _initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.34,
              ),
            )
          : Icon(Icons.person_rounded, color: Colors.white, size: size * 0.55),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: borderColor ?? AppColors.softPeriwinkle,
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
                imageUrl!,
                width: size - 4,
                height: size - 4,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return _fallback();
                },
              )
            : _fallback(),
      ),
    );
  }
}
