import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../products/presentation/providers/product_list_provider.dart';
import '../../../products/presentation/screens/manage_items_screen.dart';
import '../../../reports/presentation/providers/reports_provider.dart';
import '../../../reports/presentation/screens/reports_screen.dart';
import '../../../reports/domain/entities/report_entity.dart';
import '../providers/settings_provider.dart';
import 'settings_screen.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final Set<int> _loadedTabs = {0};
  ReportRange _dashboardReportRange = ReportRange.today;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final settingsState = ref.watch(settingsProvider);
    final settings = settingsState.valueOrNull;

    Widget shopLogoWidget;
    final logoPath = settings?.shopLogoPath;
    if (logoPath != null && File(logoPath).existsSync()) {
      shopLogoWidget = Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderMd,
          border: Border.all(color: colors.primary.withValues(alpha: 0.5), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.borderMd,
          child: Image.file(
            File(logoPath),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      shopLogoWidget = Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.15),
          borderRadius: AppRadius.borderMd,
          border: Border.all(color: colors.primary.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Icon(
          AppAssets.defaultLogoIcon,
          size: 26,
          color: colors.primary,
        ),
      );
    }

    final tabs = [
      _buildDashboard(colors, textStyles, shopLogoWidget),
      _loadedTabs.contains(1) ? const ManageItemsScreen(isEmbedded: true) : const SizedBox.shrink(),
      _loadedTabs.contains(2) ? const ReportsScreen(isEmbedded: true) : const SizedBox.shrink(),
      _loadedTabs.contains(3) ? const SettingsScreen(isEmbedded: true) : const SizedBox.shrink(),
    ];

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: colors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: AppSpacing.md,
              title: Row(
                children: [
                  shopLogoWidget,
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        settings?.shopName ?? AppStrings.appName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'POS BILLING',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  iconSize: 22,
                  style: IconButton.styleFrom(
                    backgroundColor: colors.keypadKeyBackground,
                  ),
                  icon: Icon(
                    colors.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: colors.themeToggleIconColor,
                  ),
                  onPressed: () {
                    ref.read(themeModeProvider.notifier).state =
                        colors.isDarkMode ? ThemeMode.light : ThemeMode.dark;
                  },
                ),
                const SizedBox(width: 6),
                IconButton(
                  iconSize: 22,
                  style: IconButton.styleFrom(
                    backgroundColor: colors.keypadKeyBackground,
                  ),
                  icon: Icon(
                    AppAssets.settingsIcon,
                    color: colors.textPrimary,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3; // Switch to settings tab
                      _loadedTabs.add(3);
                    });
                  },
                ),
                const SizedBox(width: AppSpacing.md),
              ],
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.cardBackground,
          border: Border(
            top: BorderSide(
              color: colors.cardBorder,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: colors.bottomNavShadowAlpha),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home', colors),
                _buildNavItem(1, Icons.grid_view_rounded, 'Products', colors),
                _buildNavItem(2, Icons.analytics_rounded, 'Analytics', colors),
                _buildNavItem(3, Icons.settings_rounded, 'Settings', colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, AppColors colors) {
    final isSelected = _currentIndex == index;
    final activeColor = index == 0
        ? colors.primary
        : index == 1
            ? colors.primary
            : index == 2
                ? colors.secondary
                : colors.textSecondary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _loadedTabs.add(index);
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: AppRadius.borderPill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : colors.textSecondary.withValues(alpha: 0.7),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(AppColors colors, AppTextStyles textStyles, Widget shopLogoWidget) {
    ref.watch(settingsProvider);
    final productsCount = ref.watch(productListProvider).valueOrNull?.length ?? 0;
    final salesReport = ref.watch(salesReportProvider).valueOrNull;
    final todayBillsCount = salesReport?.totalBillsCount ?? 0;
    final todaySalesAmount = salesReport?.totalSalesAmount ?? 0.0;

    Widget buildStatCard({
      required String title,
      required String value,
      required String badgeText,
      required IconData icon,
      required Color color,
    }) {
      return Container(
        width: 155,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: colors.cardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyles.caption.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                Icon(icon, size: 16, color: color),
              ],
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: AppRadius.borderPill,
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildGridActionCard({
      required String title,
      required String subtitle,
      required IconData icon,
      required Color accentColor,
      required VoidCallback onTap,
    }) {
      final cardBgColor = Color.alphaBlend(
        accentColor.withValues(alpha: colors.cardActionOverlayAlpha),
        colors.cardBackground,
      );

      return Container(
        height: 130,
        margin: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: AppRadius.borderXl,
          border: Border.all(
            color: accentColor.withValues(alpha: colors.cardActionBorderAlpha),
            width: 1.5,
          ),
          boxShadow: AppShadows.cardShadow(context),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.borderXl,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.borderXl,
            splashColor: accentColor.withValues(alpha: 0.15),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: AppRadius.borderMd,
                      boxShadow: AppShadows.buttonShadow(context, accentColor),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),

            // 2. "TODAY'S PERFORMANCE" Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TODAY'S PERFORMANCE",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: colors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.success.withValues(alpha: 0.15),
                      borderRadius: AppRadius.borderPill,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: colors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: colors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 3. Horizontal Stat Cards Scroll View
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: AppSpacing.md),
              child: Row(
                children: [
                  buildStatCard(
                    title: 'Total Sales',
                    value: CurrencyFormatter.format(todaySalesAmount),
                    badgeText: 'Live Today',
                    icon: Icons.account_balance_wallet_rounded,
                    color: colors.success,
                  ),
                  const SizedBox(width: 12),
                  buildStatCard(
                    title: 'Bills Issued',
                    value: '$todayBillsCount',
                    badgeText: 'Bills',
                    icon: AppAssets.billIcon,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 12),
                  buildStatCard(
                    title: 'Catalog Items',
                    value: '$productsCount',
                    badgeText: 'Products',
                    icon: AppAssets.manageIcon,
                    color: colors.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 4. 2x2 Feature Action Grid (Matching Image 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final cardWidth = width > 900
                      ? (width / 4)
                      : (width > 600 ? (width / 2) : (width / 2));
                  
                  return Wrap(
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: buildGridActionCard(
                          title: AppStrings.billNow,
                          subtitle: 'Start New Bill\nQuick POS Checkout',
                          icon: AppAssets.billIcon,
                          accentColor: colors.success,
                          onTap: () => context.router.push(const BillNowRoute()),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: buildGridActionCard(
                          title: AppStrings.manageItems,
                          subtitle: '$productsCount Items\nAdd & Edit Catalog',
                          icon: AppAssets.manageIcon,
                          accentColor: colors.primary,
                          onTap: () {
                            setState(() {
                              _currentIndex = 1; // Switch to Products Tab
                              _loadedTabs.add(1);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: buildGridActionCard(
                          title: AppStrings.reports,
                          subtitle: 'Daily & Monthly\nSales Analytics',
                          icon: AppAssets.reportsIcon,
                          accentColor: colors.secondary,
                          onTap: () {
                            setState(() {
                              _currentIndex = 2; // Switch to Analytics Tab
                              _loadedTabs.add(2);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: buildGridActionCard(
                          title: AppStrings.settings,
                          subtitle: 'Shop Config &\nReceipt Settings',
                          icon: AppAssets.settingsIcon,
                          accentColor: const Color(0xFF0EA5E9),
                          onTap: () {
                            setState(() {
                              _currentIndex = 3; // Switch to Settings Tab
                              _loadedTabs.add(3);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Product Sales breakdown card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(
                    color: colors.cardBorder,
                    width: 1.2,
                  ),
                  boxShadow: AppShadows.cardShadow(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PRODUCT SALES BREAKDOWN',
                          style: textStyles.caption.copyWith(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: colors.textSecondary,
                          ),
                        ),
                        Icon(
                          Icons.bar_chart_rounded,
                          size: 18,
                          color: colors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Range selector
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildRangeChip(ReportRange.today, 'Today', colors),
                          const SizedBox(width: 8),
                          _buildRangeChip(ReportRange.thisMonth, 'This Month', colors),
                          const SizedBox(width: 8),
                          _buildRangeChip(ReportRange.allTime, 'All Time', colors),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // List of sold products
                    ref.watch(salesReportFamilyProvider(_dashboardReportRange)).when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (err, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'Failed to load products list',
                            style: textStyles.caption.copyWith(color: colors.danger),
                          ),
                        ),
                      ),
                      data: (report) {
                        final list = report.productBreakdown;
                        if (list.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 36),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.analytics_outlined,
                                    size: 40,
                                    color: colors.textSecondary.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No products sold in this period',
                                    style: textStyles.caption.copyWith(
                                      color: colors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final totalRevenue = report.totalSalesAmount;

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = list[index];
                            final percentage = totalRevenue > 0 ? (item.totalRevenue / totalRevenue) : 0.0;

                            Widget productPhoto;
                            if (item.imagePath != null && File(item.imagePath!).existsSync()) {
                              productPhoto = ClipRRect(
                                borderRadius: AppRadius.borderSm,
                                child: Image.file(
                                  File(item.imagePath!),
                                  width: 38,
                                  height: 38,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              productPhoto = Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.08),
                                  borderRadius: AppRadius.borderSm,
                                ),
                                child: Icon(
                                  AppAssets.defaultProductIcon,
                                  color: colors.primary,
                                  size: 18,
                                ),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    productPhoto,
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: textStyles.body.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.5,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                            decoration: BoxDecoration(
                                              color: colors.success.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '${item.totalQtySold} sold',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                color: colors.success,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          CurrencyFormatter.format(item.totalRevenue),
                                          style: textStyles.body.copyWith(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${(percentage * 100).toStringAsFixed(1)}%',
                                          style: textStyles.caption.copyWith(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: percentage,
                                    backgroundColor: colors.divider.withValues(alpha: 0.12),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.primary.withValues(alpha: 0.5),
                                    ),
                                    minHeight: 3.5,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ), 
    );
  }

  Widget _buildRangeChip(ReportRange range, String label, AppColors colors) {
    final isSelected = _dashboardReportRange == range;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          setState(() {
            _dashboardReportRange = range;
          });
        }
      },
      selectedColor: colors.primary.withValues(alpha: 0.15),
      backgroundColor: colors.cardBackground,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isSelected ? colors.primary : colors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderPill,
        side: BorderSide(
          color: isSelected ? colors.primary.withValues(alpha: 0.3) : colors.cardBorder,
          width: 1,
        ),
      ),
      showCheckmark: false,
    );
  }
}
