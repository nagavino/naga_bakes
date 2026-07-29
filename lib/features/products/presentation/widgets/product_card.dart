import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared_widgets/app_card.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    colors.keypadKeyBackground,
                    colors.background,
                  ]
                : [
                    colors.primary.withValues(alpha: 0.05),
                    colors.primary.withValues(alpha: 0.15),
                  ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -15,
              top: -15,
              child: Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary.withValues(alpha: isDark ? 0.03 : 0.05),
                ),
              ),
            ),
            Icon(
              AppAssets.defaultProductIcon,
              size: 40,
              color: isDark ? colors.primary.withValues(alpha: 0.6) : colors.primary.withValues(alpha: 0.75),
            ),
          ],
        ),
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Image and info area with padding
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageWidget,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.title.copyWith(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.isActive ? 'Active Catalog' : 'Inactive Catalog',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: product.isActive
                        ? colors.textSecondary
                        : colors.danger,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  CurrencyFormatter.format(product.price),
                  style: textStyles.headline.copyWith(
                    fontSize: 16,
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // 2. Action Area
          Divider(
            height: 1,
            color: colors.cardBorder,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onEdit,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppRadius.lg - 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colors.cardBorder,
              ),
              Expanded(
                child: InkWell(
                  onTap: onDelete,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(AppRadius.lg - 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
