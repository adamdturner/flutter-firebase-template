import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

class ListItemTile extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool dense;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ListItemTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
    this.dense = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Use design system spacing instead of scaling everything
    final defaultPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spacing16,
          vertical: dense ? AppDesignSystem.spacing8 : AppDesignSystem.spacing12,
        );

    return Container(
      color: backgroundColor,
      child: ListTile(
        contentPadding: defaultPadding,
        minVerticalPadding: dense ? AppDesignSystem.spacing8 : AppDesignSystem.spacing12,
        leading: leading != null
            ? SizedBox(
                width: AppDesignSystem.avatarSize,
                height: AppDesignSystem.avatarSize,
                child: leading,
              )
            : null,
        title: Text(
          title,
          style: AppTextStyles.listTitle.copyWith(
            color: foregroundColor ?? theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTextStyles.listSubtitle.copyWith(
                  color: foregroundColor?.withOpacity(0.7) ?? 
                         (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: trailing != null
            ? ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: AppDesignSystem.avatarSize,
                  maxWidth: 120, // Allow more width for text content
                ),
                child: trailing,
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
      ),
    );
  }
}
