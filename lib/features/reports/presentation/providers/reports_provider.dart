import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dependency_injection.dart';
import '../../domain/entities/report_entity.dart';

final selectedReportRangeProvider = StateProvider<ReportRange>((ref) => ReportRange.today);

final salesReportFamilyProvider = FutureProvider.family<ReportEntity, ReportRange>((ref, range) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final res = await repo.getSalesReport(range);
  return res.when(
    success: (report) => report,
    error: (failure) => throw failure,
  );
});

final salesReportProvider = FutureProvider<ReportEntity>((ref) async {
  final range = ref.watch(selectedReportRangeProvider);
  return ref.watch(salesReportFamilyProvider(range).future);
});
