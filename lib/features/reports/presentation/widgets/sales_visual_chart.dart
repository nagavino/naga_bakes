import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared_widgets/app_card.dart';
import '../../domain/entities/report_entity.dart';

class SalesVisualChart extends StatelessWidget {
  final List<ProductSaleSummary> breakdown;
  final List<double> trend;
  final List<String> labels;

  const SalesVisualChart({
    super.key,
    required this.breakdown,
    this.trend = const [],
    this.labels = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);

    if (trend.isEmpty || trend.every((v) => v == 0)) {
      return _buildEmptyState(colors, textStyles);
    }

    final maxVal = trend.reduce((a, b) => a > b ? a : b);
    final yAxisMax = maxVal == 0 ? 100.0 : (maxVal * 1.2);

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
                    child: Icon(Icons.show_chart_rounded, color: colors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'REVENUE TREND',
                    style: textStyles.title.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.12),
                  borderRadius: AppRadius.borderPill,
                ),
                child: Text(
                  'Live Analytics',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: colors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(
              painter: _SplineChartPainter(
                data: trend,
                labels: labels,
                yAxisMax: yAxisMax,
                colors: colors,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors, AppTextStyles textStyles) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      border: Border.all(color: colors.cardBorder),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.show_chart_rounded, color: colors.textSecondary.withValues(alpha: 0.5), size: 36),
            const SizedBox(height: 8),
            Text(
              'No trend data available for this range',
              style: textStyles.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double yAxisMax;
  final AppColors colors;

  _SplineChartPainter({
    required this.data,
    required this.labels,
    required this.yAxisMax,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double paddingLeft = 45.0;
    const double paddingRight = 10.0;
    const double paddingTop = 15.0;
    const double paddingBottom = 25.0;

    final double chartWidth = size.width - paddingLeft - paddingRight;
    final double chartHeight = size.height - paddingTop - paddingBottom;

    final gridPaint = Paint()
      ..color = colors.divider.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 3; i++) {
      final double yRatio = i / 3.0;
      final double y = paddingTop + chartHeight * (1 - yRatio);
      canvas.drawLine(
         Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );

      final double value = yAxisMax * yRatio;
      String labelText;
      if (value >= 1000) {
        labelText = 'Rs.${(value / 1000).toStringAsFixed(1)}K';
      } else {
        labelText = 'Rs.${value.toStringAsFixed(0)}';
      }

      textPainter.text = TextSpan(
        text: labelText,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: colors.textSecondary.withValues(alpha: 0.6),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(paddingLeft - textPainter.width - 6, y - textPainter.height / 2),
      );
    }

    final List<Offset> points = [];
    final double stepX = data.length > 1 ? (chartWidth / (data.length - 1)) : chartWidth;

    for (int i = 0; i < data.length; i++) {
      final double x = paddingLeft + i * stepX;
      final double ratio = yAxisMax > 0 ? (data[i] / yAxisMax) : 0.0;
      final double y = paddingTop + chartHeight * (1 - ratio);
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      final Path fillPath = Path();
      fillPath.moveTo(points.first.dx, paddingTop + chartHeight);
      fillPath.lineTo(points.first.dx, points.first.dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlX1 = p0.dx + stepX / 2.0;
        final controlY1 = p0.dy;
        final controlX2 = p1.dx - stepX / 2.0;
        final controlY2 = p1.dy;

        fillPath.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
      }

      fillPath.lineTo(points.last.dx, paddingTop + chartHeight);
      fillPath.close();

      final areaGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors.primary.withValues(alpha: 0.25),
          colors.primary.withValues(alpha: 0.00),
        ],
      );

      final Paint fillPaint = Paint()
        ..shader = areaGradient.createShader(
          Rect.fromLTRB(paddingLeft, paddingTop, size.width - paddingRight, paddingTop + chartHeight),
        )
        ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);
    }

    if (points.isNotEmpty) {
      final Path linePath = Path();
      linePath.moveTo(points.first.dx, points.first.dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlX1 = p0.dx + stepX / 2.0;
        final controlY1 = p0.dy;
        final controlX2 = p1.dx - stepX / 2.0;
        final controlY2 = p1.dy;

        linePath.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
      }

      final Paint linePaint = Paint()
        ..shader = LinearGradient(
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.8),
          ],
        ).createShader(
          Rect.fromLTRB(paddingLeft, paddingTop, size.width - paddingRight, paddingTop + chartHeight),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(linePath, linePaint);
    }

    final Paint pointPaintOuter = Paint()
      ..color = colors.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final Paint pointPaintInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint pointPaintStroke = Paint()
      ..color = colors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final point in points) {
      canvas.drawCircle(point, 6.0, pointPaintOuter);
      canvas.drawCircle(point, 3.5, pointPaintInner);
      canvas.drawCircle(point, 3.5, pointPaintStroke);
    }

    for (int i = 0; i < labels.length; i++) {
      if (i >= points.length) break;
      final point = points[i];

      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
          color: colors.textSecondary.withValues(alpha: 0.7),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(point.dx - textPainter.width / 2, size.height - paddingBottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SplineChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.colors != colors;
  }
}
