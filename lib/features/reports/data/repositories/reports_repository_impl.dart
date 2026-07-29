import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/reports_repository.dart';
import '../../../billing/data/datasources/hive_sale_data_source.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final HiveSaleDataSource saleDataSource;

  ReportsRepositoryImpl(this.saleDataSource);

  @override
  Future<Result<ReportEntity>> getSalesReport(ReportRange range) async {
    try {
      final salesModels = await saleDataSource.getSales();
      final now = DateTime.now();

      final filtered = salesModels.where((sale) {
        final date = DateTime.tryParse(sale.timestamp) ?? now;
        switch (range) {
          case ReportRange.today:
            return date.year == now.year && date.month == now.month && date.day == now.day;
          case ReportRange.thisMonth:
            return date.year == now.year && date.month == now.month;
          case ReportRange.allTime:
            return true;
        }
      }).toList();

      double totalSales = 0.0;
      int totalItemsSold = 0;
      final productMap = <String, ProductSaleSummary>{};

      for (final sale in filtered) {
        totalSales += sale.totalAmount;
        for (final item in sale.items) {
          totalItemsSold += item.qty;

          final existing = productMap[item.productId];
          if (existing != null) {
            productMap[item.productId] = ProductSaleSummary(
              productId: item.productId,
              name: item.name,
              imagePath: item.imagePath ?? existing.imagePath,
              totalQtySold: existing.totalQtySold + item.qty,
              totalRevenue: existing.totalRevenue + item.subtotal,
            );
          } else {
            productMap[item.productId] = ProductSaleSummary(
              productId: item.productId,
              name: item.name,
              imagePath: item.imagePath,
              totalQtySold: item.qty,
              totalRevenue: item.subtotal,
            );
          }
        }
      }

      final breakdown = productMap.values.toList();
      breakdown.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));

      // Calculate trend data
      List<double> trend = [];
      List<String> labels = [];

      if (range == ReportRange.today) {
        trend = List.filled(6, 0.0);
        labels = ['8 AM', '11 AM', '2 PM', '5 PM', '8 PM', '11 PM'];
        for (final sale in filtered) {
          final date = DateTime.tryParse(sale.timestamp) ?? now;
          final hour = date.hour;
          if (hour < 9) {
            trend[0] += sale.totalAmount;
          } else if (hour < 12) {
            trend[1] += sale.totalAmount;
          } else if (hour < 15) {
            trend[2] += sale.totalAmount;
          } else if (hour < 18) {
            trend[3] += sale.totalAmount;
          } else if (hour < 21) {
            trend[4] += sale.totalAmount;
          } else {
            trend[5] += sale.totalAmount;
          }
        }
      } else if (range == ReportRange.thisMonth) {
        trend = List.filled(5, 0.0);
        labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5'];
        for (final sale in filtered) {
          final date = DateTime.tryParse(sale.timestamp) ?? now;
          final day = date.day;
          if (day <= 6) {
            trend[0] += sale.totalAmount;
          } else if (day <= 12) {
            trend[1] += sale.totalAmount;
          } else if (day <= 18) {
            trend[2] += sale.totalAmount;
          } else if (day <= 24) {
            trend[3] += sale.totalAmount;
          } else {
            trend[4] += sale.totalAmount;
          }
        }
      } else if (range == ReportRange.allTime) {
        trend = List.filled(6, 0.0);
        final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        
        for (int i = 5; i >= 0; i--) {
          final mDate = DateTime(now.year, now.month - i, 1);
          labels.add(monthNames[mDate.month - 1]);
        }

        for (final sale in filtered) {
          final date = DateTime.tryParse(sale.timestamp) ?? now;
          final monthDiff = (now.year - date.year) * 12 + (now.month - date.month);
          if (monthDiff >= 0 && monthDiff < 6) {
            trend[5 - monthDiff] += sale.totalAmount;
          }
        }
      }

      final report = ReportEntity(
        range: range,
        totalSalesAmount: totalSales,
        totalBillsCount: filtered.length,
        totalItemsSoldCount: totalItemsSold,
        productBreakdown: breakdown,
        salesTrend: trend,
        salesTrendLabels: labels,
      );

      return Success(report);
    } catch (e) {
      return const ErrorResult(StorageFailure('Failed to generate sales report'));
    }
  }
}
