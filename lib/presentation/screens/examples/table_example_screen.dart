import 'package:flutter/material.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// Example screen showcasing tables with headers, row labels, mixed data, and styles.
class TableExampleScreen extends StatelessWidget {
  const TableExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Table Example',
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

  /// Scrollable body with sectioned table examples.
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Header table'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildHeaderTableSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Row labels (key–value)'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildRowLabelsTableSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Mixed content (with badges)'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildMixedContentTableSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Dense table'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildDenseTableSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'No borders'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildNoBordersTableSection(context),
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

  /// Table with column headers only.
  Widget _buildHeaderTableSection(BuildContext context) {
    return AppTableCard(
      child: AppDataTable(
        headers: const ['Name', 'Score', 'Grade'],
        rows: [
          [Text('Alice', style: AppTextStyles.body), Text('92', style: AppTextStyles.body), Text('A', style: AppTextStyles.body)],
          [Text('Bob', style: AppTextStyles.body), Text('88', style: AppTextStyles.body), Text('B+', style: AppTextStyles.body)],
          [Text('Carol', style: AppTextStyles.body), Text('95', style: AppTextStyles.body), Text('A', style: AppTextStyles.body)],
        ],
        showBorders: true,
      ),
    );
  }

  /// Table with first column as row labels (e.g. settings key–value).
  Widget _buildRowLabelsTableSection(BuildContext context) {
    return AppTableCard(
      child: AppDataTable(
        headers: const ['Setting', 'Value'],
        firstColumnIsLabel: true,
        rows: [
          [Text('Theme', style: AppTextStyles.body), Text('Dark', style: AppTextStyles.body)],
          [Text('Language', style: AppTextStyles.body), Text('English', style: AppTextStyles.body)],
          [Text('Notifications', style: AppTextStyles.body), Text('On', style: AppTextStyles.body)],
        ],
        showBorders: true,
      ),
    );
  }

  /// Table with status badges and mixed widget types.
  Widget _buildMixedContentTableSection(BuildContext context) {
    return AppTableCard(
      child: AppDataTable(
        headers: const ['Task', 'Status', 'Priority'],
        rows: [
          [Text('Deploy', style: AppTextStyles.body), StatusBadge(text: 'Done', type: StatusType.success, showIcon: false), Text('High', style: AppTextStyles.body)],
          [Text('Review', style: AppTextStyles.body), StatusBadge(text: 'In progress', type: StatusType.info, showIcon: false), Text('Medium', style: AppTextStyles.body)],
          [Text('Fix bug', style: AppTextStyles.body), StatusBadge(text: 'Pending', type: StatusType.warning, showIcon: false), Text('High', style: AppTextStyles.body)],
        ],
        showBorders: true,
      ),
    );
  }

  /// Dense table (reduced padding).
  Widget _buildDenseTableSection(BuildContext context) {
    return AppTableCard(
      child: AppDataTable(
        headers: const ['Day', 'Revenue', 'Orders'],
        dense: true,
        rows: [
          [Text('Mon', style: AppTextStyles.body), Text('\$120', style: AppTextStyles.body), Text('14', style: AppTextStyles.body)],
          [Text('Tue', style: AppTextStyles.body), Text('\$98', style: AppTextStyles.body), Text('11', style: AppTextStyles.body)],
          [Text('Wed', style: AppTextStyles.body), Text('\$145', style: AppTextStyles.body), Text('18', style: AppTextStyles.body)],
        ],
        showBorders: true,
      ),
    );
  }

  /// Table without cell borders (cleaner look).
  Widget _buildNoBordersTableSection(BuildContext context) {
    return AppTableCard(
      child: AppDataTable(
        headers: const ['Item', 'Qty', 'Price'],
        rows: [
          [Text('Widget A', style: AppTextStyles.body), Text('2', style: AppTextStyles.body), Text('\$10.00', style: AppTextStyles.body)],
          [Text('Widget B', style: AppTextStyles.body), Text('1', style: AppTextStyles.body), Text('\$25.00', style: AppTextStyles.body)],
        ],
        showBorders: false,
      ),
    );
  }
}
