import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

enum StatusType {
  success,
  warning,
  error,
  info,
  neutral,
}

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;
  final IconData? icon;
  final bool showIcon;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const StatusBadge({
    super.key,
    required this.text,
    required this.type,
    this.icon,
    this.showIcon = true,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final statusConfig = _getStatusConfig(type, isDark);
    
    return Container(
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing12,
        vertical: AppDesignSystem.spacing8,
      ),
      decoration: BoxDecoration(
        color: statusConfig.backgroundColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDesignSystem.radius8,
        ),
        border: Border.all(
          color: statusConfig.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && (icon != null || statusConfig.defaultIcon != null)) ...[
            Icon(
              icon ?? statusConfig.defaultIcon!,
              size: AppDesignSystem.iconSmall,
              color: statusConfig.textColor,
            ),
            SizedBox(width: AppDesignSystem.spacing8),
          ],
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: statusConfig.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(StatusType type, bool isDark) {
    switch (type) {
      case StatusType.success:
        return _StatusConfig(
          backgroundColor: AppDesignSystem.success.withOpacity(0.1),
          borderColor: AppDesignSystem.success,
          textColor: AppDesignSystem.success,
          defaultIcon: Icons.check_circle_outline,
        );
      case StatusType.warning:
        return _StatusConfig(
          backgroundColor: AppDesignSystem.warning.withOpacity(0.1),
          borderColor: AppDesignSystem.warning,
          textColor: AppDesignSystem.warning,
          defaultIcon: Icons.warning_outlined,
        );
      case StatusType.error:
        return _StatusConfig(
          backgroundColor: AppDesignSystem.error.withOpacity(0.1),
          borderColor: AppDesignSystem.error,
          textColor: AppDesignSystem.error,
          defaultIcon: Icons.error_outline,
        );
      case StatusType.info:
        return _StatusConfig(
          backgroundColor: AppDesignSystem.info.withOpacity(0.1),
          borderColor: AppDesignSystem.info,
          textColor: AppDesignSystem.info,
          defaultIcon: Icons.info_outline,
        );
      case StatusType.neutral:
        return _StatusConfig(
          backgroundColor: isDark 
              ? Colors.grey.shade800 
              : Colors.grey.shade100,
          borderColor: isDark 
              ? Colors.grey.shade600 
              : Colors.grey.shade400,
          textColor: isDark 
              ? Colors.grey.shade300 
              : Colors.grey.shade700,
          defaultIcon: Icons.circle_outlined,
        );
    }
  }
}

class _StatusConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final IconData? defaultIcon;

  _StatusConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.defaultIcon,
  });
}
