import 'package:flutter/material.dart';

import 'package:flutter_firebase_template/core/design_system.dart';

/// Wraps a table (or any content) in a bordered, rounded card for consistent layout.
class AppTableCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const AppTableCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: padding ?? EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: isDark
            ? AppDesignSystem.surfaceDarkSecondary
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
