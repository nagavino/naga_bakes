import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared_widgets/app_card.dart';
import '../../../products/domain/entities/product_entity.dart';

class ProductStepperCard extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ProductStepperCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
    final isSelected = quantity > 0;

    Widget imageWidget;
    if (product.imagePath != null && File(product.imagePath!).existsSync()) {
      imageWidget = Image.file(
        File(product.imagePath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      imageWidget = Container(
        color: colors.primary.withValues(alpha: 0.1),
        child: Center(
          child: Icon(
            AppAssets.defaultProductIcon,
            size: 48,
            color: colors.primary,
          ),
        ),
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      border: isSelected
          ? Border.all(color: colors.success, width: 3.0)
          : Border.all(color: colors.border, width: 1.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Image Container with Floating Badges
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg - 2)),
                  child: imageWidget,
                ),
                // Floating Price Tag (Top Left)
                Positioned(
                  top: AppSpacing.xs,
                  left: AppSpacing.xs,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: AppRadius.borderPill,
                      boxShadow: AppShadows.buttonShadow(context, colors.primary),
                    ),
                    child: Text(
                      CurrencyFormatter.format(product.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                // Floating Quantity Counter (Top Right)
                if (isSelected)
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.success,
                        borderRadius: AppRadius.borderPill,
                        boxShadow: AppShadows.buttonShadow(context, colors.success),
                      ),
                      child: Text(
                        'x$quantity',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Product Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 6),
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textStyles.title.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Stepper Bar: (-) Quantity (+)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xs, 0, AppSpacing.xs, AppSpacing.xs),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  // Minus Button (Ruby Red when selected)
                  Expanded(
                    child: Material(
                      color: isSelected ? colors.danger : colors.border.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.md - 2)),
                      child: InkWell(
                        onTap: isSelected ? onRemove : null,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.md - 2)),
                        child: Center(
                          child: Icon(
                            AppAssets.removeIcon,
                            color: isSelected ? Colors.white : colors.textSecondary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Quantity Display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      '$quantity',
                      style: textStyles.headline.copyWith(
                        fontSize: 20,
                        color: isSelected ? colors.success : colors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  // Plus Button (Emerald Green)
                  Expanded(
                    child: Material(
                      color: colors.success,
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(AppRadius.md - 2)),
                      child: InkWell(
                        onTap: onAdd,
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(AppRadius.md - 2)),
                        child: const Center(
                          child: Icon(
                            AppAssets.addIcon,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
