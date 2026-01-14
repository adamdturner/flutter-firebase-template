import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

// Legacy constants for backward compatibility
const Color appBarBackgroundColor = AppDesignSystem.surface;
const Color cameraButtonColor = AppDesignSystem.primary;
const Color cameraButtonHoverColor = AppDesignSystem.primaryHover;

ThemeData appTheme() {
  final TextTheme textTheme = AppDesignSystem.textTheme.copyWith(
    bodyMedium: AppDesignSystem.textTheme.bodyMedium?.copyWith(
      color: AppDesignSystem.onSurface,
    ),
    labelLarge: AppDesignSystem.textTheme.labelLarge?.copyWith(
      color: AppDesignSystem.onSurface,
    ),
    labelSmall: AppDesignSystem.textTheme.labelSmall?.copyWith(
      color: AppDesignSystem.onSurface,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppDesignSystem.primary,
      brightness: Brightness.light,
      primary: AppDesignSystem.primary,
      onPrimary: Colors.white,
      surface: AppDesignSystem.surface,
      onSurface: AppDesignSystem.onSurface,
      tertiary: AppDesignSystem.tertiary,
    ),
    textTheme: textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppDesignSystem.primary,
        minimumSize: Size(double.infinity, AppDesignSystem.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
        textStyle: AppTextStyles.button,
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppDesignSystem.primary,
        textStyle: AppTextStyles.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        borderSide: BorderSide(color: AppDesignSystem.primary, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing16,
        vertical: AppDesignSystem.spacing12,
      ),
      labelStyle: AppTextStyles.body.copyWith(color: Colors.grey.shade600),
      hintStyle: AppTextStyles.body.copyWith(color: Colors.grey.shade400),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppDesignSystem.surface,
      foregroundColor: AppDesignSystem.onSurface,
      elevation: 0,
      titleTextStyle: AppTextStyles.heading3,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppDesignSystem.surface,
      indicatorColor: AppDesignSystem.primary.withOpacity(0.24),
      elevation: 8,
      shadowColor: const Color.fromARGB(31, 189, 189, 189),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppDesignSystem.primary,
          );
        }
        return AppTextStyles.caption.copyWith(
          color: Colors.grey.shade600,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: AppDesignSystem.primary,
            size: AppDesignSystem.iconMedium,
          );
        }
        return IconThemeData(
          color: Colors.grey.shade600,
          size: AppDesignSystem.iconMedium,
        );
      }),
      height: 80,
    ),
    scaffoldBackgroundColor: AppDesignSystem.surface,
  );
}

ThemeData darkTheme() {
  final TextTheme textTheme = AppDesignSystem.textTheme.copyWith(
    bodyMedium: AppDesignSystem.textTheme.bodyMedium?.copyWith(
      color: AppDesignSystem.onSurfaceDark,
    ),
    bodySmall: AppDesignSystem.textTheme.bodySmall?.copyWith(
      color: AppDesignSystem.onSurfaceDarkSecondary,
    ),
    labelLarge: AppDesignSystem.textTheme.labelLarge?.copyWith(
      color: AppDesignSystem.onSurfaceDark,
    ),
    labelSmall: AppDesignSystem.textTheme.labelSmall?.copyWith(
      color: AppDesignSystem.onSurfaceDarkSecondary,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppDesignSystem.primaryDark,
      brightness: Brightness.dark,
      primary: AppDesignSystem.primaryDark,
      onPrimary: Colors.white,
      surface: AppDesignSystem.surfaceDark,
      onSurface: AppDesignSystem.onSurfaceDark,
      surfaceContainerHighest: AppDesignSystem.surfaceDarkSecondary,
      surfaceContainerHigh: AppDesignSystem.surfaceDarkTertiary,
      surfaceContainer: AppDesignSystem.surfaceDarkElevated,
      tertiary: AppDesignSystem.tertiary,
      // Enhanced dark theme colors
      secondary: AppDesignSystem.onSurfaceDarkSecondary,
      onSecondary: AppDesignSystem.surfaceDark,
      error: AppDesignSystem.error,
      onError: Colors.white,
      outline: AppDesignSystem.onSurfaceDarkTertiary,
      outlineVariant: AppDesignSystem.surfaceDarkSecondary,
    ),
    textTheme: textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppDesignSystem.primaryDark,
        minimumSize: Size(double.infinity, AppDesignSystem.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
        textStyle: AppTextStyles.button,
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppDesignSystem.primaryDark,
        textStyle: AppTextStyles.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppDesignSystem.surfaceDarkSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        borderSide: BorderSide(color: AppDesignSystem.onSurfaceDarkTertiary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        borderSide: BorderSide(color: AppDesignSystem.onSurfaceDarkTertiary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        borderSide: BorderSide(color: AppDesignSystem.primaryDark, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing16,
        vertical: AppDesignSystem.spacing12,
      ),
      labelStyle: AppTextStyles.body.copyWith(color: AppDesignSystem.onSurfaceDarkSecondary),
      hintStyle: AppTextStyles.body.copyWith(color: AppDesignSystem.onSurfaceDarkTertiary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppDesignSystem.surfaceDarkSecondary,
      foregroundColor: AppDesignSystem.onSurfaceDark,
      elevation: 0,
      titleTextStyle: AppTextStyles.heading3,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppDesignSystem.surfaceDarkSecondary,
      indicatorColor: AppDesignSystem.primaryDark.withOpacity(0.2),
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.3),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppDesignSystem.primaryDark,
          );
        }
        return AppTextStyles.caption.copyWith(
          color: AppDesignSystem.onSurfaceDarkSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: AppDesignSystem.primaryDark,
            size: AppDesignSystem.iconMedium,
          );
        }
        return IconThemeData(
          color: AppDesignSystem.onSurfaceDarkSecondary,
          size: AppDesignSystem.iconMedium,
        );
      }),
      height: 80,
    ),
    scaffoldBackgroundColor: AppDesignSystem.surfaceDark,
    // Enhanced dark theme components
    cardTheme: CardThemeData(
      color: AppDesignSystem.surfaceDarkSecondary,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppDesignSystem.onSurfaceDarkTertiary,
      thickness: 0.5,
      space: 1,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: AppDesignSystem.surfaceDarkSecondary,
      selectedTileColor: AppDesignSystem.surfaceDarkTertiary,
      textColor: AppDesignSystem.onSurfaceDark,
      iconColor: AppDesignSystem.onSurfaceDarkSecondary,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing16,
        vertical: AppDesignSystem.spacing8,
      ),
    ),
  );
}