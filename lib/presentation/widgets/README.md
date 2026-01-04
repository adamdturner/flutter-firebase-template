# Widget Library

This directory contains reusable UI components that enforce consistency across the app.

## Widget Organization

```
widgets/
├── common/           # General-purpose widgets
├── forms/            # Form-related widgets
├── lists/            # List-related widgets
└── widgets.dart      # Export file for easy imports
```

## Available Widgets

### Common Widgets

#### StatusBadge
Displays status information with consistent styling and icons.

```dart
StatusBadge(
  text: "Success",
  type: StatusType.success,
  icon: Icons.check_circle,
)

StatusBadge(
  text: "Error occurred",
  type: StatusType.error,
)
```

**Status Types:**
- `StatusType.success` - Green with check icon
- `StatusType.warning` - Orange with warning icon
- `StatusType.error` - Red with error icon
- `StatusType.info` - Blue with info icon
- `StatusType.neutral` - Gray with circle icon

#### AppLoadingWidget
Consistent loading indicators throughout the app.

```dart
// Simple loading
AppLoadingWidget()

// With message
AppLoadingWidget(message: "Loading data...")

// Full screen loading
AppLoadingWidget(
  message: "Processing...",
  isFullScreen: true,
)

// Loading overlay
AppLoadingOverlay(
  isLoading: isProcessing,
  child: MyContent(),
)
```

#### EmptyStateWidget
Displays when lists or content are empty.

```dart
EmptyStateWidget(
  title: "No items found",
  subtitle: "Try adjusting your search criteria",
  icon: Icons.inventory_2_outlined,
  action: ElevatedButton(
    onPressed: () => addItem(),
    child: Text("Add Item"),
  ),
)

// With action helper
EmptyStateWithAction(
  title: "No data yet",
  icon: Icons.data_usage,
  actionText: "Get Started",
  onActionPressed: () => navigateToStart(),
)
```

### Form Widgets

#### AppFormField
Consistent form input styling with validation.

```dart
AppFormField(
  label: "Name",
  hint: "Enter your name",
  controller: nameController,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
  required: true,
)

// With icon
AppFormFieldWithIcon(
  label: "Email",
  controller: emailController,
  icon: Icons.email,
  keyboardType: TextInputType.emailAddress,
)

// Search field
AppSearchField(
  hint: "Search...",
  controller: searchController,
  onChanged: (value) => filterItems(value),
)
```

## Usage Examples

### Replacing Loading States

**Before:**
```dart
if (isLoading) {
  return Center(child: CircularProgressIndicator());
}
```

**After:**
```dart
if (isLoading) {
  return AppLoadingWidget(message: "Loading data...");
}
```

### Replacing Empty States

**Before:**
```dart
if (items.isEmpty) {
  return Center(child: Text('No items found.'));
}
```

**After:**
```dart
if (items.isEmpty) {
  return EmptyStateWidget(
    title: "No items found",
    subtitle: "Start by adding your first item",
    icon: Icons.inventory_2_outlined,
    action: ElevatedButton(
      onPressed: () => addItem(),
      child: Text("Add Item"),
    ),
  );
}
```

### Replacing Status Indicators

**Before:**
```dart
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.green.shade50,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.green),
  ),
  child: Row(
    children: [
      Icon(Icons.verified, color: Colors.green),
      SizedBox(width: 8),
      Text('Verified', style: TextStyle(color: Colors.green)),
    ],
  ),
)
```

**After:**
```dart
StatusBadge(
  text: "Verified",
  type: StatusType.success,
  icon: Icons.verified,
)
```

## Design System Integration

All widgets use the `AppDesignSystem` for:
- Consistent colors and spacing
- Responsive sizing
- Dark/light theme support
- Typography standards

## Importing Widgets

```dart
// Import all widgets
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

// Or import specific widgets
import 'package:flutter_firebase_template/presentation/widgets/common/status_badge_widget.dart';
import 'package:flutter_firebase_template/presentation/widgets/forms/app_form_field_widget.dart';
```

## Migration Guide

1. **Replace hardcoded loading states** with `AppLoadingWidget`
2. **Replace empty state text** with `EmptyStateWidget`
3. **Replace status containers** with `StatusBadge`
4. **Replace form fields** with `AppFormField`

## Benefits

✅ **Consistency** - Same look and feel across all screens  
✅ **Maintainability** - Update styling in one place  
✅ **Developer Experience** - Less repetitive code  
✅ **Accessibility** - Built-in accessibility features  
✅ **Responsive** - Work well on all screen sizes  
✅ **Theme Support** - Automatic dark/light theme support

## Navigation Buttons

### AppNavigationButton
Standardized navigation buttons with consistent styling and behavior.

```dart
// Basic navigation button
AppNavigationButton(
  text: "Go to Settings",
  onPressed: () => Navigator.pushNamed(context, "/settings"),
)

// Destructive action button
AppNavigationButton.destructive(
  text: "Delete Account",
  onPressed: () => deleteAccount(),
)

// Primary action button
AppNavigationButton.primary(
  text: "Save Changes",
  onPressed: () => saveChanges(),
)

// Button with icon
AppNavigationButton(
  text: "Upload File",
  onPressed: () => uploadFile(),
  icon: Icons.upload,
)

// Loading state
AppNavigationButton(
  text: "Processing...",
  onPressed: () {},
  isLoading: true,
)
```

### AppNavigationButtonList
Container for organizing multiple navigation buttons with consistent spacing.

```dart
AppNavigationButtonList(
  buttons: [
    AppNavigationButton(
      text: "Profile",
      onPressed: () => Navigator.pushNamed(context, "/profile"),
    ),
    AppNavigationButton(
      text: "Settings",
      onPressed: () => Navigator.pushNamed(context, "/settings"),
    ),
    AppNavigationButton.destructive(
      text: "Logout",
      onPressed: () => logout(),
    ),
  ],
)
```  
