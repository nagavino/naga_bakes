import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_sizes.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = AppSizes.minTouchTarget,
    this.iconSize = AppSizes.iconMd,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bg = backgroundColor ?? colors.primary;
    final fg = iconColor ?? Colors.white;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderMd,
        boxShadow: onPressed != null ? AppShadows.buttonShadow(context, bg) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.borderMd,
          onTap: onPressed,
          child: Center(
            child: Icon(icon, size: iconSize, color: fg),
          ),
        ),
      ),
    );
  }
}
