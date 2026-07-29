import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/report_entity.dart';

class ReportRangeTabs extends StatelessWidget {
  final ReportRange selectedRange;
  final ValueChanged<ReportRange> onRangeChanged;

  const ReportRangeTabs({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);

    Widget buildTab(ReportRange range, String label, IconData icon) {
      final isSelected = selectedRange == range;
      
      return Expanded(
        child: GestureDetector(
          onTap: () => onRangeChanged(range),
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : Colors.transparent,
              borderRadius: AppRadius.borderPill,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isSelected
                      ? Colors.white
                      : colors.textSecondary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyles.label.copyWith(
                      color: isSelected
                          ? Colors.white
                          : colors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.keypadKeyBackground,
        borderRadius: AppRadius.borderPill,
        border: Border.all(
          color: colors.cardBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          buildTab(ReportRange.today, AppStrings.today, Icons.wb_sunny_rounded),
          buildTab(ReportRange.thisMonth, AppStrings.thisMonth, Icons.calendar_month_rounded),
          buildTab(ReportRange.allTime, AppStrings.allTime, Icons.all_inclusive_rounded),
        ],
      ),
    );
  }
}
