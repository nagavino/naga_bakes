import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared_widgets/app_card.dart';
import '../../domain/entities/report_entity.dart';

class TopSellingItemsCard extends StatelessWidget {
  final List<ProductSaleSummary> breakdown;

  const TopSellingItemsCard({
    super.key,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);

    if (breakdown.isEmpty) return const SizedBox.shrink();

    // Take top 5 items
    final topItems = breakdown.take(5).toList();
    final maxRevenue = topItems.map((e) => e.totalRevenue).reduce((a, b) => a > b ? a : b);

    return AppCard(
      padding: const EdgeInsets.all(20),
      border: Border.all(
        color: colors.cardBorder,
        width: 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: AppRadius.borderMd,
                    ),
                    child: Icon(Icons.stars_rounded, color: colors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'TOP SELLING ITEMS',
                    style: textStyles.title.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.trending_up_rounded,
                size: 20,
                color: colors.success,
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...topItems.map((item) {
            final ratio = maxRevenue > 0 ? (item.totalRevenue / maxRevenue) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: textStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(item.totalRevenue),
                        style: textStyles.body.copyWith(
                          color: colors.success,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final totalWidth = constraints.maxWidth;
                      final filledWidth = totalWidth * ratio;
                      return Container(
                        height: 8,
                        width: totalWidth,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: colors.divider.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Container(
                          width: filledWidth < 8 ? 8 : filledWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.primary,
                                colors.primary.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
