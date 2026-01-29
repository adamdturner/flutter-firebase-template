import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

/// Wraps a list of child widgets in a bordered, rounded container with optional dividers.
class ListSectionCard extends StatelessWidget {
  final List<Widget> children;
  final bool showDividers;
  final EdgeInsetsGeometry? padding;

  const ListSectionCard({
    super.key,
    required this.children,
    this.showDividers = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectivePadding = padding ?? EdgeInsets.zero;
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppDesignSystem.surfaceDarkSecondary
            : AppDesignSystem.lightSurfaceElevated,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(context, effectivePadding),
      ),
    );
  }

  /// Builds column content: children with optional dividers between them.
  List<Widget> _buildChildren(BuildContext context, EdgeInsetsGeometry padding) {
    if (children.isEmpty) return [];
    final content = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (showDividers && i > 0) content.add(const Divider(height: 1));
      content.add(children[i]);
    }
    return [
      Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      ),
    ];
  }
}
