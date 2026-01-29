import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_firebase_template/core/design_system.dart';

/// Wraps [BarChart] with design-system colors; [values] map to bar heights.
class AppBarChartWidget extends StatelessWidget {
  final List<double> values;
  final List<String>? labels;
  final double? height;
  final Color? barColor;
  final bool showTitles;

  const AppBarChartWidget({
    super.key,
    required this.values,
    this.labels,
    this.height,
    this.barColor,
    this.showTitles = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = barColor ?? AppDesignSystem.primary;
    final maxY = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    final maxVal = maxY * 1.2;

    final groups = List.generate(
      values.length,
      (i) => BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: values[i],
            color: color,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
        showingTooltipIndicators: [],
      ),
    );

    final data = BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxVal,
      minY: 0,
      barGroups: groups,
      titlesData: FlTitlesData(
        show: showTitles,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: showTitles && labels != null,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              final i = value.toInt();
              if (i >= 0 && i < (labels?.length ?? 0)) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(labels![i], style: AppTextStyles.caption),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: false),
    );

    final child = BarChart(data);
    if (height != null) {
      return SizedBox(height: height, child: child);
    }
    return child;
  }
}
