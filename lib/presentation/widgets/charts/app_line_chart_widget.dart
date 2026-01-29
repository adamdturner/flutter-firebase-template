import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_firebase_template/core/design_system.dart';

/// Wraps [LineChart] with design-system primary color and minimal titles/grid.
class AppLineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final double? height;
  final Color? lineColor;
  final bool showGrid;
  final bool showTitles;

  const AppLineChartWidget({
    super.key,
    required this.spots,
    this.height,
    this.lineColor,
    this.showGrid = true,
    this.showTitles = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = lineColor ?? AppDesignSystem.primary;
    final minX = spots.isEmpty ? 0.0 : spots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
    final maxX = spots.isEmpty ? 1.0 : spots.map((s) => s.x).reduce((a, b) => a > b ? a : b);
    final minY = spots.isEmpty ? 0.0 : spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.isEmpty ? 1.0 : spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padY = (maxY - minY) * 0.1;
    final padX = (maxX - minX) * 0.1;

    final data = LineChartData(
      minX: minX - (padX > 0 ? padX : 0.5),
      maxX: maxX + (padX > 0 ? padX : 0.5),
      minY: (minY - padY).clamp(minY - 1, minY),
      maxY: maxY + padY,
      gridData: FlGridData(show: showGrid),
      titlesData: FlTitlesData(show: showTitles),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: color,
          barWidth: 2.5,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: true, color: color.withOpacity(0.15)),
        ),
      ],
    );

    final child = LineChart(data);
    if (height != null) {
      return SizedBox(height: height, child: child);
    }
    return child;
  }
}
