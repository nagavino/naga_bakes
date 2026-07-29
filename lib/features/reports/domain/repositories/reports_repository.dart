import '../../../../core/utils/result.dart';
import '../entities/report_entity.dart';

abstract class ReportsRepository {
  Future<Result<ReportEntity>> getSalesReport(ReportRange range);
}
