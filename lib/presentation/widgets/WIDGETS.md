# Reusable Widgets

## Purpose
The `widgets/` directory contains reusable UI components that maintain consistency across the app. These widgets follow the design system and can be used throughout different screens.

## Key Requirements
- Reusable widgets that help maintain consistency across the app
- Must use design system constants for all styling
- Should be highly configurable through parameters
- Follow single responsibility principle - each widget has one clear purpose
- Include sensible default values for optional parameters
- Document widget parameters clearly

## Widget Categories

### Common Widgets (`common/`)
- **app_loading_widget.dart**: Loading indicators and overlays
- **custom_app_bar_widget.dart**: Consistent app bars with actions
- **empty_state_widget.dart**: Empty state messaging
- **status_badge_widget.dart**: Status indicators and badges
- **info_card_widget.dart**: Information display cards

### Form Widgets (`forms/`)
- **app_form_field_widget.dart**: Text input fields with validation

### List Widgets (`lists/`)
- **list_item_tile_widget.dart**: List item display
- **list_widget.dart**: Complete list with loading and empty states

## Example

```dart
// Reusable loading widget
class AppLoadingWidget extends StatelessWidget {
  final String? message;
  final bool isFullScreen;
  final Color? color;
  final bool showMessage;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.isFullScreen = false,
    this.color,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadingColor = color ?? theme.colorScheme.primary;

    final loadingWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: AppDesignSystem.iconLarge,
          height: AppDesignSystem.iconLarge,
          child: CircularProgressIndicator(
            color: loadingColor,
            strokeWidth: 3.0,
          ),
        ),
        if (showMessage && message != null) ...[
          SizedBox(height: AppDesignSystem.spacing16),
          Text(
            message!,
            style: AppTextStyles.body.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (isFullScreen) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(AppDesignSystem.spacing24),
            child: loadingWidget,
          ),
        ),
      );
    }

    return Center(child: loadingWidget);
  }
}

// Usage in screens
AppLoadingWidget(
  message: 'Loading user data...',
  isFullScreen: true,
)
```

## Best Practices
- Export widgets in `widgets.dart` for easy importing
- Keep widgets stateless when possible
- Use const constructors for better performance
- Break down complex widgets into smaller composable pieces
- Follow the design system for all styling
