import 'package:flutter/material.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// Dashboard that showcases example screens and capabilities available in the template.
class ExamplesDashboardScreen extends StatelessWidget {
  const ExamplesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Examples',
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

  /// Scrollable body with section header and example cards.
  Widget _buildBody(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildExampleCard(
            context,
            icon: Icons.text_fields,
            title: 'Form Fields',
            description: 'Input types, validation, and submit patterns.',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, '/examples/form_fields'),
          ),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildExampleCard(
            context,
            icon: Icons.info_outline,
            title: 'Info Widgets',
            description: 'Info cards, banners, and status displays.',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, '/examples/info_widgets'),
          ),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildExampleCard(
            context,
            icon: Icons.list,
            title: 'List Example',
            description: 'Lists, tiles, and list-based layouts.',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, '/examples/list'),
          ),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildExampleCard(
            context,
            icon: Icons.qr_code_scanner,
            title: 'QR Example',
            description: 'QR scanning and code display.',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, '/examples/qr'),
          ),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildExampleCard(
            context,
            icon: Icons.show_chart,
            title: 'Graphs',
            description: 'Line, bar, and pie charts.',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, '/examples/graphs'),
          ),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildExampleCard(
            context,
            icon: Icons.table_chart,
            title: 'Table Example',
            description: 'Tables with headers, labels, and mixed data.',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, '/examples/table'),
          ),
        ],
      ),
    );
  }

  /// Section title and intro text.
  Widget _buildSectionHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark
        ? AppDesignSystem.onSurfaceDarkSecondary
        : AppDesignSystem.lightOnSurfaceSecondary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Template Examples',
          style: AppTextStyles.heading2,
        ),
        SizedBox(height: AppDesignSystem.spacing8),
        Text(
          'Explore the widgets and patterns available in this Flutter template.',
          style: AppTextStyles.body.copyWith(color: secondaryColor),
        ),
      ],
    );
  }

  /// Single tappable example card with icon, title, and description.
  Widget _buildExampleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
      child: Container(
        padding: EdgeInsets.all(AppDesignSystem.spacing16),
        decoration: BoxDecoration(
          color: isDark
              ? AppDesignSystem.surfaceDarkSecondary
              : AppDesignSystem.lightSurfaceElevated,
          borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppDesignSystem.spacing12),
              decoration: BoxDecoration(
                color: AppDesignSystem.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
              ),
              child: Icon(
                icon,
                color: AppDesignSystem.primary,
                size: AppDesignSystem.iconMedium,
              ),
            ),
            SizedBox(width: AppDesignSystem.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.listTitle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDesignSystem.spacing4),
                  Text(
                    description,
                    style: AppTextStyles.body.copyWith(
                      color: isDark
                          ? AppDesignSystem.onSurfaceDarkSecondary
                          : AppDesignSystem.lightOnSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark
                  ? AppDesignSystem.onSurfaceDarkSecondary
                  : AppDesignSystem.lightOnSurfaceSecondary,
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a snackbar for example screens not yet implemented.
  void _showComingSoon(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name example — coming soon')),
    );
  }
}
