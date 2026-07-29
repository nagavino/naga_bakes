import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/report_entity.dart';

class ProductSalesTile extends StatelessWidget {
  final ProductSaleSummary summary;

  const ProductSalesTile({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);

    Widget itemPhoto;
    if (summary.imagePath != null && File(summary.imagePath!).existsSync()) {
      itemPhoto = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(summary.imagePath!),
          width: 46,
          height: 46,
          fit: BoxFit.cover,
        ),
      );
    } else {
      itemPhoto = Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          AppAssets.defaultProductIcon,
          color: colors.primary.withValues(alpha: 0.8),
          size: 22,
        ),
      );
    }

    return Row(
      children: [
        itemPhoto,
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                summary.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${summary.totalQtySold} sold',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          CurrencyFormatter.format(summary.totalRevenue),
          style: textStyles.body.copyWith(
            color: colors.textPrimary,
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
