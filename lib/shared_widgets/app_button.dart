import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_gradients.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_shadows.dart';

enum AppButtonVariant { primary, secondary, success, danger, warning }

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final double height;
  final double fontSize;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.height = 48.0,
    this.fontSize = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    Gradient gradient;
    Color buttonColor;
    switch (variant) {
      case AppButtonVariant.primary:
        gradient = AppGradients.primary(context);
        buttonColor = colors.primary;
        break;
      case AppButtonVariant.secondary:
        gradient = AppGradients.secondary(context);
        buttonColor = colors.secondary;
        break;
      case AppButtonVariant.success:
        gradient = AppGradients.success(context);
        buttonColor = colors.success;
        break;
      case AppButtonVariant.danger:
        gradient = AppGradients.danger(context);
        buttonColor = colors.danger;
        break;
      case AppButtonVariant.warning:
        gradient = AppGradients.amber(context);
        buttonColor = colors.warning;
        break;
    }

    final isDisabled = onPressed == null || isLoading;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: isDisabled ? null : gradient,
        color: isDisabled ? colors.border : null,
        borderRadius: AppRadius.borderMd,
        boxShadow: isDisabled ? [] : AppShadows.buttonShadow(context, buttonColor),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderMd,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: AppRadius.borderMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: fontSize + 4,
                    height: fontSize + 4,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                ] else if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: fontSize + 5),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
