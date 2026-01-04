import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

/// A reusable navigation button widget for consistent styling across the app
/// 
/// This widget provides a standardized button design for navigation actions
/// with consistent padding, sizing, and styling.
class AppNavigationButton extends StatelessWidget {
  /// The text to display on the button
  final String text;
  
  /// Optional subtitle text to display below the main text
  final String? subtitle;
  
  /// The callback function to execute when the button is pressed
  final VoidCallback onPressed;
  
  /// Whether this is a destructive action (e.g., logout, delete)
  /// When true, the button will have a red background
  final bool isDestructive;
  
  /// Whether the button should be disabled
  final bool isDisabled;
  
  /// Optional icon to display before the text
  final IconData? icon;
  
  /// Custom background color (overrides isDestructive)
  final Color? backgroundColor;
  
  /// Custom text color (overrides isDestructive)
  final Color? textColor;
  
  /// Whether to show a loading indicator instead of text
  final bool isLoading;
  
  /// Custom width (defaults to full width within constraints)
  final double? width;

  const AppNavigationButton({
    super.key,
    required this.text,
    this.subtitle,
    required this.onPressed,
    this.isDestructive = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.width,
  });

  /// Creates a destructive button (e.g., logout, delete)
  const AppNavigationButton.destructive({
    super.key,
    required this.text,
    this.subtitle,
    required this.onPressed,
    this.isDisabled = false,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : isDestructive = true,
       backgroundColor = null,
       textColor = null;

  /// Creates a primary action button
  const AppNavigationButton.primary({
    super.key,
    required this.text,
    this.subtitle,
    required this.onPressed,
    this.isDisabled = false,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : isDestructive = false,
       backgroundColor = AppDesignSystem.primary,
       textColor = AppDesignSystem.surface;

  /// Creates a secondary action button
  const AppNavigationButton.secondary({
    super.key,
    required this.text,
    this.subtitle,
    required this.onPressed,
    this.isDisabled = false,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : isDestructive = false,
       backgroundColor = null,
       textColor = null;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = _getBackgroundColor();
    final effectiveTextColor = _getTextColor();
    
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width ?? double.infinity, AppDesignSystem.buttonHeight),
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          disabledBackgroundColor: AppDesignSystem.onSurface.withOpacity(0.12),
          disabledForegroundColor: AppDesignSystem.onSurface.withOpacity(0.38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
          ),
          elevation: 2.0,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? (isDestructive ? AppDesignSystem.surface : AppDesignSystem.onSurface),
          ),
        ),
      );
    }

    final textWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: AppTextStyles.button,
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          SizedBox(height: AppDesignSystem.spacing4),
          Text(
            subtitle!,
            style: AppTextStyles.caption.copyWith(
              color: (textColor ?? (isDestructive ? AppDesignSystem.surface : AppDesignSystem.onSurface))
                  .withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppDesignSystem.iconSmall,
          ),
          SizedBox(width: AppDesignSystem.spacing8),
          textWidget,
        ],
      );
    }

    return textWidget;
  }

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    if (isDestructive) return AppDesignSystem.error;
    return AppDesignSystem.primary;
  }

  Color _getTextColor() {
    if (textColor != null) return textColor!;
    if (isDestructive) return AppDesignSystem.surface;
    if (isDestructive == false && backgroundColor == null) return AppDesignSystem.surface; // Default blue buttons get white text
    if (backgroundColor == AppDesignSystem.primary) return AppDesignSystem.surface;
    return AppDesignSystem.onSurface;
  }
}

/// A container widget that provides consistent padding for navigation buttons
/// 
/// This widget wraps navigation buttons with standard horizontal padding
/// to ensure consistent spacing across different screens.
class AppNavigationButtonContainer extends StatelessWidget {
  /// The child widget (typically AppNavigationButton widgets)
  final Widget child;
  
  /// Custom horizontal padding (defaults to design system spacing)
  final double? horizontalPadding;

  const AppNavigationButtonContainer({
    super.key,
    required this.child,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? AppDesignSystem.spacing32,
      ),
      child: child,
    );
  }
}

/// A column widget specifically designed for navigation button lists
/// 
/// This widget provides consistent spacing between navigation buttons
/// and proper padding for the entire button group.
class AppNavigationButtonList extends StatelessWidget {
  /// List of navigation buttons to display
  final List<AppNavigationButton> buttons;
  
  /// Custom spacing between buttons (defaults to design system spacing)
  final double? spacing;
  
  /// Custom horizontal padding for the container (defaults to design system spacing)
  final double? horizontalPadding;
  
  /// Whether to center the buttons vertically
  final bool centerVertically;

  const AppNavigationButtonList({
    super.key,
    required this.buttons,
    this.spacing,
    this.horizontalPadding,
    this.centerVertically = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppNavigationButtonContainer(
      horizontalPadding: horizontalPadding,
      child: Column(
        mainAxisAlignment: centerVertically 
            ? MainAxisAlignment.center 
            : MainAxisAlignment.start,
        children: buttons
            .map((button) => Padding(
                  padding: EdgeInsets.only(
                    bottom: spacing ?? AppDesignSystem.spacing20,
                  ),
                  child: button,
                ))
            .toList(),
      ),
    );
  }
}
