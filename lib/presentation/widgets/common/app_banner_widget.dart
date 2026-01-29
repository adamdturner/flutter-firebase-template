import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

/// Semantic type for banner styling.
enum AppBannerType { info, success, warning, error }

/// Full-width banner with icon and message; uses design-system semantic colors.
class AppBanner extends StatelessWidget {
  final String message;
  final AppBannerType type;
  final IconData? icon;
  final VoidCallback? onTap;

  const AppBanner({
    super.key,
    required this.message,
    required this.type,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final config = _configFor(type, isDark);
    final child = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing16,
        vertical: AppDesignSystem.spacing12,
      ),
      child: Row(
        children: [
          Icon(
            icon ?? config.defaultIcon,
            size: AppDesignSystem.iconMedium,
            color: config.foregroundColor,
          ),
          SizedBox(width: AppDesignSystem.spacing12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body.copyWith(
                color: config.foregroundColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
    return Material(
      color: config.backgroundColor,
      borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        child: child,
      ),
    );
  }

  _BannerConfig _configFor(AppBannerType type, bool isDark) {
    switch (type) {
      case AppBannerType.info:
        return _BannerConfig(
          backgroundColor: AppDesignSystem.info.withOpacity(0.15),
          foregroundColor: AppDesignSystem.info,
          defaultIcon: Icons.info_outline,
        );
      case AppBannerType.success:
        return _BannerConfig(
          backgroundColor: AppDesignSystem.success.withOpacity(0.15),
          foregroundColor: AppDesignSystem.success,
          defaultIcon: Icons.check_circle_outline,
        );
      case AppBannerType.warning:
        return _BannerConfig(
          backgroundColor: AppDesignSystem.warning.withOpacity(0.15),
          foregroundColor: AppDesignSystem.warning,
          defaultIcon: Icons.warning_amber_outlined,
        );
      case AppBannerType.error:
        return _BannerConfig(
          backgroundColor: AppDesignSystem.error.withOpacity(0.15),
          foregroundColor: AppDesignSystem.error,
          defaultIcon: Icons.error_outline,
        );
    }
  }
}

class _BannerConfig {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData defaultIcon;

  _BannerConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.defaultIcon,
  });
}
