enum ReportRange { today, thisMonth, allTime }

class ProductSaleSummary {
  final String productId;
  final String name;
  final String? imagePath;
  final int totalQtySold;
  final double totalRevenue;

  const ProductSaleSummary({
    required this.productId,
    required this.name,
    this.imagePath,
    required this.totalQtySold,
    required this.totalRevenue,
  });
}

class ReportEntity {
  final ReportRange range;
  final double totalSalesAmount;
  final int totalBillsCount;
  final int totalItemsSoldCount;
  final List<ProductSaleSummary> productBreakdown;
  final List<double> salesTrend;
  final List<String> salesTrendLabels;

  const ReportEntity({
    required this.range,
    required this.totalSalesAmount,
    required this.totalBillsCount,
    required this.totalItemsSoldCount,
    required this.productBreakdown,
    this.salesTrend = const [],
    this.salesTrendLabels = const [],
  });
}
