# App Styling Guide

## Overview
This guide outlines the styling architecture for the app, providing a centralized design system for consistent UI across all screens.

## Architecture

### 1. **Design System (`design_system.dart`)**
- **Centralized Constants**: All colors, spacing, typography, and component sizes in one place
- **Semantic Naming**: Colors and styles have meaningful names (e.g., `AppDesignSystem.primary`, `AppTextStyles.heading1`)
- **Responsive Helpers**: Built-in breakpoint detection and responsive sizing
- **Consistent Spacing**: Predefined spacing values (4, 8, 12, 16, 20, 24, 32, 40, 48)

### 2. **Improved Scale Factor Usage**
**Before (Problematic):**
```dart
// Scaling everything leads to inconsistent hierarchy
fontSize: 16 * DeviceUtils.scaleFactor,
padding: EdgeInsets.all(12 * DeviceUtils.scaleFactor),
```

**After (Better):**
```dart
// Only scale specific elements, use design system for others
fontSize: AppTextStyles.body.fontSize,
padding: EdgeInsets.all(AppDesignSystem.spacing16),
iconSize: AppDesignSystem.iconMedium, // Only icons scale
```

### 3. **Enhanced Theme System**
- **Design System Integration**: Themes now use centralized design tokens
- **Consistent Component Styling**: All buttons, inputs, and navigation use design system values
- **Better Dark Mode**: Proper dark theme with semantic color usage

## Key Benefits

### ✅ **Consistency**
- Single source of truth for all styling decisions
- Consistent spacing, colors, and typography across the app
- Easy to maintain and update

### ✅ **Scalability**
- Easy to add new components following the same patterns
- Simple to implement design changes across the entire app
- Responsive design built-in

### ✅ **Developer Experience**
- Clear naming conventions make code self-documenting
- Reduced cognitive load when styling components
- Less repetitive code

## Usage Examples

### Using the Design System
```dart
// Colors
Container(
  color: AppDesignSystem.surface,
  child: Text(
    'Hello',
    style: AppTextStyles.heading1.copyWith(
      color: AppDesignSystem.primary,
    ),
  ),
)

// Spacing
Padding(
  padding: EdgeInsets.all(AppDesignSystem.spacing16),
  child: Column(
    children: [
      // content
    ],
  ),
)

// Responsive Design
Container(
  padding: EdgeInsets.all(
    AppDesignSystem.getResponsivePadding(context),
  ),
  child: Text(
    'Responsive text',
    style: AppTextStyles.body.copyWith(
      fontSize: AppDesignSystem.getResponsiveFontSize(context, 16),
    ),
  ),
)
```

### Using Predefined Text Styles
```dart
// Instead of custom styling
Text(
  'Title',
  style: AppTextStyles.heading2,
)

// Instead of
Text(
  'Title',
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  ),
)
```

## Best Practices

### ✅ **Do**
- Use design system constants for all styling
- Use semantic color names (`AppDesignSystem.primary` not `Color(0xFF1F4BFA)`)
- Use responsive helpers for different screen sizes
- Create reusable components that follow the design system

### ❌ **Don't**
- Use hardcoded values (colors, spacing, font sizes)
- Scale everything with `scaleFactor` (only scale icons and specific elements)
- Create custom styling when design system provides it
- Mix different styling approaches in the same component

## Scale Factor Recommendations

### ✅ **Good Uses of Scale Factor**
- Icon sizes: `AppDesignSystem.iconMedium` (scales with device)
- Avatar sizes: `AppDesignSystem.avatarSize` (scales with device)
- Touch targets: Minimum 44pt scaled appropriately

### ❌ **Avoid Scaling**
- Text sizes: Use `AppTextStyles` instead
- Spacing: Use `AppDesignSystem.spacing*` constants
- Border radius: Use `AppDesignSystem.radius*` constants
- Component heights: Use `AppDesignSystem.*Height` constants

## Files Structure

- `lib/core/design_system.dart` - Centralized design system
- `lib/core/theme.dart` - Theme configuration
- `lib/presentation/widgets/` - Reusable widget components
- `lib/core/STYLING_GUIDE.md` - This documentation

## Extending the Design System

When adding new features:

1. Check if existing design tokens cover your needs
2. Add new tokens to `design_system.dart` if needed
3. Create reusable widgets in `presentation/widgets/`
4. Follow existing naming conventions
5. Update this guide if adding significant new patterns
