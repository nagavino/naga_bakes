import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared_widgets/app_card.dart';
import '../../../../shared_widgets/app_empty_state.dart';
import '../../../../shared_widgets/app_error_view.dart';
import '../../../../shared_widgets/app_loading_indicator.dart';
import '../providers/reports_provider.dart';
import '../widgets/product_sales_tile.dart';
import '../widgets/report_range_tabs.dart';
import '../widgets/report_summary_card.dart';
import '../widgets/sales_visual_chart.dart';
import '../widgets/top_selling_items_card.dart';

@RoutePage()
class ReportsScreen extends ConsumerWidget {
  final bool isEmbedded;
  const ReportsScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
    final selectedRange = ref.watch(selectedReportRangeProvider);
    final reportAsync = ref.watch(salesReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.reports.toUpperCase(),
          style: textStyles.headline.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: !isEmbedded,
        leading: isEmbedded
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: AppSizes.iconMd),
                onPressed: () => context.router.maybePop(),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Reports',
            onPressed: () {
              ref.invalidate(salesReportProvider);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: ReportRangeTabs(
              selectedRange: selectedRange,
              onRangeChanged: (range) {
                ref.read(selectedReportRangeProvider.notifier).state = range;
              },
            ),
          ),
          Expanded(
            child: reportAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (err, stack) => AppErrorView(
                onRetry: () => ref.refresh(salesReportProvider),
              ),
              data: (report) {
                if (report.totalBillsCount == 0) {
                  return const AppEmptyState(
                    icon: AppAssets.reportsIcon,
                    title: 'No sales recorded for this period',
                    subtitle: 'Completed sales will automatically appear here.',
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Metric Summary Cards
                      ReportSummaryCard(
                        title: AppStrings.totalSales,
                        value: CurrencyFormatter.format(report.totalSalesAmount),
                        icon: Icons.currency_rupee_rounded,
                        color: colors.success,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: ReportSummaryCard(
                              title: AppStrings.totalBills,
                              value: '${report.totalBillsCount}',
                              icon: AppAssets.billIcon,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: ReportSummaryCard(
                              title: AppStrings.itemsSold,
                              value: '${report.totalItemsSoldCount}',
                              icon: AppAssets.manageIcon,
                              color: colors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Visual Chart
                      SalesVisualChart(
                        breakdown: report.productBreakdown,
                        trend: report.salesTrend,
                        labels: report.salesTrendLabels,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Top Selling Items Card
                      TopSellingItemsCard(breakdown: report.productBreakdown),
                      const SizedBox(height: AppSpacing.lg),

                      // Product Breakdown List Card
                      AppCard(
                        padding: const EdgeInsets.all(18),
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
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: colors.success.withValues(alpha: 0.1),
                                          borderRadius: AppRadius.borderMd,
                                        ),
                                        child: Icon(Icons.receipt_long_rounded, color: colors.success, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          AppStrings.productBreakdown.toUpperCase(),
                                          style: textStyles.title.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: colors.textPrimary,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colors.primary.withValues(alpha: 0.12),
                                    borderRadius: AppRadius.borderPill,
                                  ),
                                  child: Text(
                                    '${report.productBreakdown.length} Products',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: colors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: report.productBreakdown.length,
                              separatorBuilder: (context, index) => Divider(
                                color: colors.divider.withValues(alpha: 0.08),
                                height: 24,
                              ),
                              itemBuilder: (context, index) {
                                return ProductSalesTile(
                                  summary: report.productBreakdown[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
