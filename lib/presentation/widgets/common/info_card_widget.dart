import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// A reusable info card widget with consistent styling that uses theme fonts and colors
/// 
/// This widget provides a standardized card design for displaying information
/// with an optional icon, title, subtitle, description, and button.
class InfoCard extends StatelessWidget {
  /// The icon to display in the card header
  final IconData? icon;
  
  /// Optional custom icon widget (takes precedence over icon if provided)
  final Widget? customIcon;
  
  /// The title text displayed prominently
  final String title;
  
  /// Optional subtitle text displayed below the title
  final String? subtitle;
  
  /// The main description/body text
  final String? description;
  
  /// Optional button widget (typically AppNavigationButton)
  final Widget? button;
  
  /// Custom icon color (defaults to theme primary color)
  final Color? iconColor;
  
  /// Custom icon background color with opacity
  final Color? iconBackgroundColor;
  
  /// Custom padding for the card content
  final EdgeInsetsGeometry? padding;
  
  /// Custom margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Custom card elevation
  final double? elevation;
  
  /// Whether to show the icon section
  final bool showIcon;
  
  /// Custom card color
  final Color? cardColor;
  
  /// Custom title text style
  final TextStyle? titleStyle;
  
  /// Custom subtitle text style
  final TextStyle? subtitleStyle;
  
  /// Custom description text style
  final TextStyle? descriptionStyle;

  const InfoCard({
    super.key,
    this.icon,
    this.customIcon,
    required this.title,
    this.subtitle,
    this.description,
    this.button,
    this.iconColor,
    this.iconBackgroundColor,
    this.padding,
    this.margin,
    this.elevation,
    this.showIcon = true,
    this.cardColor,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
  });

  /// Creates an InfoCard with a primary-style button
  factory InfoCard.withPrimaryButton({
    Key? key,
    IconData? icon,
    Widget? customIcon,
    required String title,
    String? subtitle,
    String? description,
    required String buttonText,
    IconData? buttonIcon,
    required VoidCallback onButtonPressed,
    Color? iconColor,
    Color? iconBackgroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    bool showIcon = true,
    Color? cardColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? descriptionStyle,
  }) {
    return InfoCard(
      key: key,
      icon: icon,
      customIcon: customIcon,
      title: title,
      subtitle: subtitle,
      description: description,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      padding: padding,
      margin: margin,
      elevation: elevation,
      showIcon: showIcon,
      cardColor: cardColor,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      descriptionStyle: descriptionStyle,
      button: SizedBox(
        width: double.infinity,
        child: AppNavigationButton.primary(
          text: buttonText,
          icon: buttonIcon,
          onPressed: onButtonPressed,
        ),
      ),
    );
  }

  /// Creates an InfoCard with a secondary-style button
  factory InfoCard.withSecondaryButton({
    Key? key,
    IconData? icon,
    Widget? customIcon,
    required String title,
    String? subtitle,
    String? description,
    required String buttonText,
    IconData? buttonIcon,
    required VoidCallback onButtonPressed,
    Color? iconColor,
    Color? iconBackgroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    bool showIcon = true,
    Color? cardColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? descriptionStyle,
  }) {
    return InfoCard(
      key: key,
      icon: icon,
      customIcon: customIcon,
      title: title,
      subtitle: subtitle,
      description: description,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      padding: padding,
      margin: margin,
      elevation: elevation,
      showIcon: showIcon,
      cardColor: cardColor,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      descriptionStyle: descriptionStyle,
      button: SizedBox(
        width: double.infinity,
        child: AppNavigationButton.secondary(
          text: buttonText,
          icon: buttonIcon,
          onPressed: onButtonPressed,
        ),
      ),
    );
  }

  /// Creates an InfoCard without any button (display only)
  factory InfoCard.displayOnly({
    Key? key,
    IconData? icon,
    Widget? customIcon,
    required String title,
    String? subtitle,
    String? description,
    Color? iconColor,
    Color? iconBackgroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    bool showIcon = true,
    Color? cardColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? descriptionStyle,
  }) {
    return InfoCard(
      key: key,
      icon: icon,
      customIcon: customIcon,
      title: title,
      subtitle: subtitle,
      description: description,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      padding: padding,
      margin: margin,
      elevation: elevation,
      showIcon: showIcon,
      cardColor: cardColor,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      descriptionStyle: descriptionStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Use theme colors with fallbacks
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;
    final effectiveIconBackgroundColor = iconBackgroundColor ?? effectiveIconColor.withOpacity(0.1);
    final effectiveCardColor = cardColor ?? theme.cardColor;
    final effectiveElevation = elevation ?? 4.0;
    
    return Container(
      margin: margin,
      child: Card(
        elevation: effectiveElevation,
        color: effectiveCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppDesignSystem.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                children: [
                  if (showIcon && (customIcon != null || icon != null)) ...[
                    if (customIcon != null)
                      customIcon!
                    else ...[
                      Container(
                        width: AppDesignSystem.iconXLarge,
                        height: AppDesignSystem.iconXLarge,
                        decoration: BoxDecoration(
                          color: effectiveIconBackgroundColor,
                          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                        ),
                        child: Icon(
                          icon!,
                          color: effectiveIconColor,
                          size: AppDesignSystem.iconMedium,
                        ),
                      ),
                    ],
                    const SizedBox(width: AppDesignSystem.spacing16),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: (titleStyle ?? AppTextStyles.heading3).copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppDesignSystem.spacing4),
                          Text(
                            subtitle!,
                            style: (subtitleStyle ?? AppTextStyles.body).copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              
              // Description
              if (description != null) ...[
                const SizedBox(height: AppDesignSystem.spacing16),
                Text(
                  description!,
                  style: (descriptionStyle ?? AppTextStyles.bodyLarge).copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
              
              // Button
              if (button != null) ...[
                const SizedBox(height: AppDesignSystem.spacing20),
                button!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
