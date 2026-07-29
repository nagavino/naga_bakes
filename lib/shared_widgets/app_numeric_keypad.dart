import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AppNumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPress;
  final VoidCallback onDelete;
  final VoidCallback onClear;

  const AppNumericKeypad({
    super.key,
    required this.onKeyPress,
    required this.onDelete,
    required this.onClear,
  });

  Widget _buildKey({
    required BuildContext context,
    required Widget child,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    final colors = AppColors.of(context);
    final bgColor = backgroundColor ?? colors.keypadKeyBackground;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.keypadKeyBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: colors.primary.withValues(alpha: 0.12),
          highlightColor: colors.primary.withValues(alpha: 0.04),
          child: Center(child: child),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      'C', '0', 'DEL',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final keyStr = keys[index];

        if (keyStr == 'C') {
          return _buildKey(
            context: context,
            backgroundColor: colors.danger.withValues(alpha: 0.07),
            onTap: onClear,
            child: Icon(
              Icons.clear_rounded,
              color: colors.danger,
              size: 24,
            ),
          );
        }

        if (keyStr == 'DEL') {
          return _buildKey(
            context: context,
            backgroundColor: colors.warning.withValues(alpha: 0.07),
            onTap: onDelete,
            child: Icon(
              Icons.backspace_outlined,
              color: colors.warning,
              size: 22,
            ),
          );
        }

        return _buildKey(
          context: context,
          onTap: () => onKeyPress(keyStr),
          child: Text(
            keyStr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        );
      },
    );
  }
}
