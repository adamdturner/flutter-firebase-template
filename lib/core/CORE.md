# Core System

## Purpose
The `core/` directory contains the app's design system, theme management, and shared utilities that provide consistent styling and behavior across the entire application.

## Key Files
- **design_system.dart**: Centralized design tokens (colors, spacing, typography)
- **theme.dart**: Material theme configuration using design system
- **theme_manager.dart**: Theme preference management (light/dark mode)
- **font_scale_manager.dart**: Font scaling preference management
- **utils/**: Shared utility functions

## Key Requirements
- All styling must use design system constants
- Never use hardcoded colors, spacing, or typography values
- Use semantic naming for design tokens
- Theme switching must be smooth and consistent
- Responsive design built into the system

## Design System Structure

### Colors
- Semantic color names: `AppDesignSystem.primary`, `AppDesignSystem.surface`
- Theme-aware colors that adapt to light/dark mode
- Consistent color palette across app

### Spacing
- Predefined spacing scale: 4, 8, 12, 16, 20, 24, 32, 40, 48
- Access via `AppDesignSystem.spacing16`, `AppDesignSystem.spacing24`

### Typography
- Predefined text styles: `AppTextStyles.heading1`, `AppTextStyles.body`
- Consistent font sizes and weights
- Proper text hierarchy

### Components
- Button heights, icon sizes, border radius
- Touch target sizes
- Component-specific styling constants

## Example

```dart
// Using design system for consistent styling
Container(
  padding: EdgeInsets.all(AppDesignSystem.spacing16),
  decoration: BoxDecoration(
    color: AppDesignSystem.surface,
    borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Section Title',
        style: AppTextStyles.heading2.copyWith(
          color: AppDesignSystem.primary,
        ),
      ),
      SizedBox(height: AppDesignSystem.spacing12),
      Text(
        'Body content goes here',
        style: AppTextStyles.body,
      ),
    ],
  ),
)

// Theme switching
final themeManager = context.read<ThemeManager>();
themeManager.setThemeMode(ThemeMode.dark);
```

See `STYLING_GUIDE.md` for comprehensive styling documentation.
