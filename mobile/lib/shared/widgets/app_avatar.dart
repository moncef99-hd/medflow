import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;

  const AppAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 48,
  });

  String get _initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.gradient,
        image: hasImage
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: hasImage
          ? null
          : Text(
              _initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.34,
              ),
            ),
    );
  }
}