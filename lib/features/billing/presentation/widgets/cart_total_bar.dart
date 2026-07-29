import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared_widgets/app_button.dart';

class CartTotalBar extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onClear;
  final VoidCallback onPayNow;

  const CartTotalBar({
    super.key,
    required this.totalAmount,
    required this.onClear,
    required this.onPayNow,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
    final hasItems = totalAmount > 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        boxShadow: AppShadows.cardShadow(context),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.totalAmount,
                  style: textStyles.title.copyWith(color: colors.textSecondary),
                ),
                Text(
                  CurrencyFormatter.format(totalAmount),
                  style: textStyles.display.copyWith(
                    color: colors.success,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                // Clear Cart Button (Red, trash icon)
                Expanded(
                  flex: 2,
                  child: AppButton(
                    label: AppStrings.clearCart,
                    icon: AppAssets.deleteIcon,
                    variant: AppButtonVariant.danger,
                    onPressed: hasItems ? onClear : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Pay Now Button (Green, large, arrow icon)
                Expanded(
                  flex: 3,
                  child: AppButton(
                    label: AppStrings.payNow,
                    icon: Icons.arrow_forward_rounded,
                    variant: AppButtonVariant.success,
                    onPressed: hasItems ? onPayNow : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
