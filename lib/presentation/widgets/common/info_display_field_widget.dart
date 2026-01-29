import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

/// A single label-value row for displaying read-only info (e.g. profile details).
class InfoDisplayField extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Widget? trailing;

  const InfoDisplayField({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDesignSystem.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppDesignSystem.iconSmall,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            SizedBox(width: AppDesignSystem.spacing12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: AppDesignSystem.spacing4),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: AppDesignSystem.spacing8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
