import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.action,
    this.iconColor,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final effectiveIconColor = iconColor ?? 
        (isDark ? Colors.grey.shade400 : Colors.grey.shade600);
    final effectiveIconSize = iconSize ?? AppDesignSystem.iconXLarge * 2;

    return Padding(
      padding: padding ?? EdgeInsets.all(AppDesignSystem.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: effectiveIconSize,
            color: effectiveIconColor,
          ),
          SizedBox(height: AppDesignSystem.spacing24),
          Text(
            title,
            style: AppTextStyles.heading3.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            SizedBox(height: AppDesignSystem.spacing12),
            Text(
              subtitle!,
              style: AppTextStyles.body.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            SizedBox(height: AppDesignSystem.spacing24),
            action!,
          ],
        ],
      ),
    );
  }
}

class EmptyStateWithAction extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String actionText;
  final VoidCallback? onActionPressed;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const EmptyStateWithAction({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.actionText,
    this.onActionPressed,
    this.iconColor,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      iconSize: iconSize,
      padding: padding,
      action: onActionPressed != null
          ? ElevatedButton(
              onPressed: onActionPressed,
              child: Text(actionText),
            )
          : null,
    );
  }
}
