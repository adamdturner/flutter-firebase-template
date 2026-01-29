import 'package:flutter/material.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// Example screen showcasing info cards, banners, status badges, display fields, and empty state.
class InfoWidgetExampleScreen extends StatelessWidget {
  const InfoWidgetExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Info Widgets Example',
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

  /// Scrollable body with sectioned info widgets.
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Info cards'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildInfoCardsSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Status badges'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildStatusBadgesSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Banners'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildBannersSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Display fields'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildDisplayFieldsSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Empty state'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildEmptyStateSection(context),
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

  /// InfoCard variants: display only, with primary button, with secondary button.
  Widget _buildInfoCardsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoCard.displayOnly(
          icon: Icons.lightbulb_outline,
          title: 'Display-only card',
          subtitle: 'No actions',
          description: 'Use this for static content: tips, descriptions, or read-only information.',
        ),
        SizedBox(height: AppDesignSystem.spacing16),
        InfoCard.withPrimaryButton(
          icon: Icons.rocket_launch,
          title: 'Card with primary action',
          subtitle: 'Single CTA',
          description: 'When you need one main action. The button uses the primary style.',
          buttonText: 'Continue',
          buttonIcon: Icons.arrow_forward,
          onButtonPressed: () => _showSnackBar(context, 'Primary action'),
        ),
        SizedBox(height: AppDesignSystem.spacing16),
        InfoCard.withSecondaryButton(
          icon: Icons.settings_outlined,
          title: 'Card with secondary action',
          description: 'A secondary-style button for less prominent actions.',
          buttonText: 'Learn more',
          onButtonPressed: () => _showSnackBar(context, 'Secondary action'),
        ),
      ],
    );
  }

  /// Row of status badges (success, warning, error, info, neutral).
  Widget _buildStatusBadgesSection(BuildContext context) {
    return Wrap(
      spacing: AppDesignSystem.spacing12,
      runSpacing: AppDesignSystem.spacing12,
      children: [
        StatusBadge(text: 'Success', type: StatusType.success),
        StatusBadge(text: 'Warning', type: StatusType.warning),
        StatusBadge(text: 'Error', type: StatusType.error),
        StatusBadge(text: 'Info', type: StatusType.info),
        StatusBadge(text: 'Neutral', type: StatusType.neutral),
      ],
    );
  }

  /// Banners: info, success, warning, error.
  Widget _buildBannersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBanner(
          message: 'Informational message or tip.',
          type: AppBannerType.info,
        ),
        SizedBox(height: AppDesignSystem.spacing12),
        AppBanner(
          message: 'Action completed successfully.',
          type: AppBannerType.success,
        ),
        SizedBox(height: AppDesignSystem.spacing12),
        AppBanner(
          message: 'Please review before continuing.',
          type: AppBannerType.warning,
        ),
        SizedBox(height: AppDesignSystem.spacing12),
        AppBanner(
          message: 'Something went wrong. Try again.',
          type: AppBannerType.error,
        ),
      ],
    );
  }

  /// Label-value display fields (e.g. profile or settings summary).
  Widget _buildDisplayFieldsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: isDark
            ? AppDesignSystem.surfaceDarkSecondary
            : AppDesignSystem.lightSurfaceElevated,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoDisplayField(
            label: 'Name',
            value: 'Jane Doe',
            icon: Icons.person_outline,
          ),
          InfoDisplayField(
            label: 'Email',
            value: 'jane@example.com',
            icon: Icons.email_outlined,
          ),
          InfoDisplayField(
            label: 'Role',
            value: 'Member',
            icon: Icons.badge_outlined,
            trailing: StatusBadge(
              text: 'Active',
              type: StatusType.success,
              showIcon: false,
            ),
          ),
        ],
      ),
    );
  }

  /// Compact empty state example.
  Widget _buildEmptyStateSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppDesignSystem.surfaceDarkTertiary
            : AppDesignSystem.lightSurfaceTertiary,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
      ),
      child: EmptyStateWidget(
        title: 'No items yet',
        subtitle: 'This is an example of the empty state widget.',
        icon: Icons.inbox_outlined,
        iconSize: AppDesignSystem.iconXLarge,
        action: AppNavigationButton.secondary(
          text: 'Add item',
          icon: Icons.add,
          onPressed: () => _showSnackBar(context, 'Add item tapped'),
        ),
      ),
    );
  }

  /// Shows a snackbar for demo actions.
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
