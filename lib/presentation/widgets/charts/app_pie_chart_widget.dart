import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_firebase_template/core/design_system.dart';

/// Segment data for [AppPieChartWidget].
class PieSegment {
  final String title;
  final double value;
  final Color color;

  const PieSegment({required this.title, required this.value, required this.color});
}

/// Wraps [PieChart] with design-system colors; [segments] define slices.
class AppPieChartWidget extends StatelessWidget {
  final List<PieSegment> segments;
  final double size;
  final double centerSpaceRadius;
  final bool showTitles;

  const AppPieChartWidget({
    super.key,
    required this.segments,
    this.size = 160,
    this.centerSpaceRadius = 32,
    this.showTitles = true,
  });

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<double>(0, (s, e) => s + e.value);
    if (total <= 0) {
      return SizedBox(width: size, height: size);
    }

    final sections = segments
        .map((s) => PieChartSectionData(
              value: s.value,
              color: s.color,
              title: showTitles ? s.title : '',
              radius: 24,
              titleStyle: AppTextStyles.caption.copyWith(color: Colors.white),
            ))
        .toList();

    final data = PieChartData(
      sections: sections,
      centerSpaceRadius: centerSpaceRadius,
      sectionsSpace: 2,
      pieTouchData: PieTouchData(enabled: true),
    );

    return SizedBox(
      width: size,
      height: size,
      child: PieChart(data),
    );
  }
}
