import '../../../../core/utils/result.dart';
import '../entities/report_entity.dart';
import '../repositories/reports_repository.dart';

class GetSalesReports {
  final ReportsRepository repository;
  const GetSalesReports(this.repository);

  Future<Result<ReportEntity>> call(ReportRange range) {
    return repository.getSalesReport(range);
  }
}
