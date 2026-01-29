import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// Example screen showcasing line, bar, and pie charts using template chart widgets.
class GraphExampleScreen extends StatelessWidget {
  const GraphExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Graphs Example',
        showBackButton: true,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppDesignSystem.surfaceDarkSecondary
          : AppDesignSystem.surface,
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  /// Scrollable body with sectioned chart examples.
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Line chart'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildLineChartSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Bar chart'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildBarChartSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Pie chart'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildPieChartSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Multi-series line'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildMultiLineSection(context),
        ],
      ),
    );
  }

  /// Section title.
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.heading3,
    );
  }

  /// Single line chart (e.g. trend over time).
  Widget _buildLineChartSection(BuildContext context) {
    final spots = [
      const FlSpot(0, 2),
      const FlSpot(1, 3.5),
      const FlSpot(2, 2.5),
      const FlSpot(3, 4),
      const FlSpot(4, 3),
      const FlSpot(5, 5),
    ];
    return _buildChartCard(
      context,
      child: SizedBox(
        height: 200,
        child: AppLineChartWidget(
          spots: spots,
          height: 200,
          lineColor: AppDesignSystem.primary,
          showGrid: true,
        ),
      ),
    );
  }

  /// Bar chart (e.g. category comparison).
  Widget _buildBarChartSection(BuildContext context) {
    return _buildChartCard(
      context,
      child: SizedBox(
        height: 200,
        child: AppBarChartWidget(
          values: const [4, 7, 3, 9, 5],
          labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
          height: 200,
          barColor: AppDesignSystem.primary,
          showTitles: true,
        ),
      ),
    );
  }

  /// Pie chart (e.g. composition / share).
  Widget _buildPieChartSection(BuildContext context) {
    final segments = [
      PieSegment(title: 'A', value: 35, color: AppDesignSystem.primary),
      PieSegment(title: 'B', value: 25, color: AppDesignSystem.success),
      PieSegment(title: 'C', value: 20, color: AppDesignSystem.warning),
      PieSegment(title: 'D', value: 20, color: AppDesignSystem.info),
    ];
    return _buildChartCard(
      context,
      child: Center(
        child: AppPieChartWidget(
          segments: segments,
          size: 200,
          centerSpaceRadius: 40,
          showTitles: true,
        ),
      ),
    );
  }

  /// Placeholder for a second line (multi-series would need a custom widget or extended AppLineChartWidget).
  Widget _buildMultiLineSection(BuildContext context) {
    final spots = [
      const FlSpot(0, 1),
      const FlSpot(1, 2),
      const FlSpot(2, 1.5),
      const FlSpot(3, 3),
      const FlSpot(4, 2),
    ];
    return _buildChartCard(
      context,
      child: SizedBox(
        height: 200,
        child: AppLineChartWidget(
          spots: spots,
          height: 200,
          lineColor: AppDesignSystem.success,
          showGrid: true,
        ),
      ),
    );
  }

  /// Wraps a chart in a bordered card.
  Widget _buildChartCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: isDark
            ? AppDesignSystem.surfaceDarkTertiary
            : AppDesignSystem.lightSurfaceElevated,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: child,
    );
  }
}
