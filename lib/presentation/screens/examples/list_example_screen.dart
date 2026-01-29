import 'package:flutter/material.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// Example screen showcasing list layouts: simple tiles, leading icons/avatars, trailing, dense, and card with dividers.
class ListExampleScreen extends StatelessWidget {
  const ListExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'List Example',
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

  /// Scrollable body with sectioned list examples.
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Simple list'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildSimpleListSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'List with leading icons'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildListWithLeadingIconsSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'List with avatars'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildListWithAvatarsSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'List with trailing'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildListWithTrailingSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Dense list'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildDenseListSection(context),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildSectionHeader(context, 'Card with dividers'),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildListCardWithDividersSection(context),
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

  /// Title and subtitle only; no leading or trailing.
  Widget _buildSimpleListSection(BuildContext context) {
    return ListSectionCard(
      padding: EdgeInsets.zero,
      children: [
        ListItemTile(
          title: 'First item',
          subtitle: 'Subtitle text',
          onTap: () => _showSnackBar(context, 'First item'),
        ),
        ListItemTile(
          title: 'Second item',
          subtitle: 'Another subtitle',
          onTap: () => _showSnackBar(context, 'Second item'),
        ),
        ListItemTile(
          title: 'Third item',
          subtitle: 'Tap to see action',
          onTap: () => _showSnackBar(context, 'Third item'),
        ),
      ],
    );
  }

  /// Leading icon, title, subtitle.
  Widget _buildListWithLeadingIconsSection(BuildContext context) {
    final theme = Theme.of(context);
    return ListSectionCard(
      padding: EdgeInsets.zero,
      children: [
        ListItemTile(
          leading: Icon(Icons.folder_outlined, color: theme.colorScheme.primary),
          title: 'Documents',
          subtitle: '12 files',
          onTap: () => _showSnackBar(context, 'Documents'),
        ),
        ListItemTile(
          leading: Icon(Icons.image_outlined, color: theme.colorScheme.primary),
          title: 'Photos',
          subtitle: '156 items',
          onTap: () => _showSnackBar(context, 'Photos'),
        ),
        ListItemTile(
          leading: Icon(Icons.settings_outlined, color: theme.colorScheme.primary),
          title: 'Settings',
          subtitle: 'App preferences',
          onTap: () => _showSnackBar(context, 'Settings'),
        ),
      ],
    );
  }

  /// Leading CircleAvatar, title, subtitle.
  Widget _buildListWithAvatarsSection(BuildContext context) {
    return ListSectionCard(
      padding: EdgeInsets.zero,
      children: [
        ListItemTile(
          leading: CircleAvatar(
            backgroundColor: AppDesignSystem.primary.withOpacity(0.2),
            child: Text('A', style: AppTextStyles.caption),
          ),
          title: 'Alice',
          subtitle: 'alice@example.com',
          onTap: () => _showSnackBar(context, 'Alice'),
        ),
        ListItemTile(
          leading: CircleAvatar(
            backgroundColor: AppDesignSystem.primary.withOpacity(0.2),
            child: Text('B', style: AppTextStyles.caption),
          ),
          title: 'Bob',
          subtitle: 'bob@example.com',
          onTap: () => _showSnackBar(context, 'Bob'),
        ),
        ListItemTile(
          leading: CircleAvatar(
            backgroundColor: AppDesignSystem.primary.withOpacity(0.2),
            child: Text('C', style: AppTextStyles.caption),
          ),
          title: 'Carol',
          subtitle: 'carol@example.com',
          onTap: () => _showSnackBar(context, 'Carol'),
        ),
      ],
    );
  }

  /// Trailing chevron or badge.
  Widget _buildListWithTrailingSection(BuildContext context) {
    return ListSectionCard(
      padding: EdgeInsets.zero,
      children: [
        ListItemTile(
          title: 'Navigate',
          subtitle: 'Tap to go',
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
          onTap: () => _showSnackBar(context, 'Navigate'),
        ),
        ListItemTile(
          title: 'With badge',
          subtitle: 'Status indicator',
          trailing: StatusBadge(text: 'New', type: StatusType.info, showIcon: false),
          onTap: () => _showSnackBar(context, 'With badge'),
        ),
        ListItemTile(
          title: 'Complete',
          subtitle: 'Done',
          trailing: StatusBadge(text: 'Done', type: StatusType.success, showIcon: false),
          onTap: () => _showSnackBar(context, 'Complete'),
        ),
      ],
    );
  }

  /// Dense tiles (reduced vertical padding).
  Widget _buildDenseListSection(BuildContext context) {
    return ListSectionCard(
      padding: EdgeInsets.zero,
      children: [
        ListItemTile(
          dense: true,
          title: 'Dense item 1',
          subtitle: 'Compact row',
          onTap: () => _showSnackBar(context, 'Dense 1'),
        ),
        ListItemTile(
          dense: true,
          title: 'Dense item 2',
          subtitle: 'Less vertical space',
          onTap: () => _showSnackBar(context, 'Dense 2'),
        ),
        ListItemTile(
          dense: true,
          title: 'Dense item 3',
          subtitle: 'Good for long lists',
          onTap: () => _showSnackBar(context, 'Dense 3'),
        ),
      ],
    );
  }

  /// Card with dividers between items.
  Widget _buildListCardWithDividersSection(BuildContext context) {
    return ListSectionCard(
      showDividers: true,
      padding: EdgeInsets.zero,
      children: [
        ListItemTile(
          title: 'Section A',
          subtitle: 'First group',
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
          onTap: () => _showSnackBar(context, 'Section A'),
        ),
        ListItemTile(
          title: 'Section B',
          subtitle: 'Second group',
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
          onTap: () => _showSnackBar(context, 'Section B'),
        ),
        ListItemTile(
          title: 'Section C',
          subtitle: 'Third group',
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
          onTap: () => _showSnackBar(context, 'Section C'),
        ),
      ],
    );
  }

  /// Shows a snackbar for demo actions.
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
