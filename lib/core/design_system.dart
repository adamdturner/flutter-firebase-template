import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_firebase_template/core/utils/device_utils.dart';

/// Centralized design system for consistent styling across the app
class AppDesignSystem {
  // ─────────────────────────────────────────────────────────────
  // LIGHT THEME COLORS
  // ─────────────────────────────────────────────────────────────
  
  // Primary Brand Colors (Light Theme)
  /// Main slate blue brand color used for primary buttons and interactive elements in light mode
  static const Color lightPrimary = Color.fromARGB(255, 91, 124, 153);
  
  /// Light blue-grey color used for hover states and secondary accents in light mode
  static const Color lightPrimaryHover = Color.fromARGB(255, 184, 202, 219);
  
  /// Tertiary brand color (green) used for success states and accents in light mode
  static const Color lightTertiary = Color.fromARGB(255, 34, 197, 94);
  
  // Surface Colors (Light Theme)
  /// Main background color for the entire app in light mode - warm off-white with subtle beige tone
  static const Color lightSurface = Color.fromARGB(255, 252, 252, 250);
  
  /// Secondary surface color for elevated elements like cards in light mode - warm light grey
  static const Color lightSurfaceSecondary = Color.fromARGB(255, 245, 245, 240);
  
  /// Tertiary surface color for subtle backgrounds and containers in light mode - warm grey
  static const Color lightSurfaceTertiary = Color.fromARGB(255, 238, 238, 230);
  
  /// Elevated surface color for highest elevation elements in light mode
  static const Color lightSurfaceElevated = Color.fromARGB(255, 255, 255, 255);
  
  // Text Colors (Light Theme)
  /// Primary text color for main content in light mode - black
  static const Color lightOnSurface = Color.fromARGB(255, 0, 0, 0);
  
  /// Secondary text color for less emphasized content in light mode - dark gray
  static const Color lightOnSurfaceSecondary = Color.fromARGB(255, 107, 114, 128);
  
  /// Tertiary text color for subtle hints and disabled states in light mode - medium gray
  static const Color lightOnSurfaceTertiary = Color.fromARGB(255, 156, 163, 175);
  
  // Semantic Colors (Light Theme)
  /// Success state color for positive actions and confirmations in light mode - green
  static const Color lightSuccess = Color.fromARGB(255, 34, 197, 94);
  
  /// Warning state color for cautionary messages in light mode - amber
  static const Color lightWarning = Color.fromARGB(255, 245, 158, 11);
  
  /// Error state color for destructive actions and errors in light mode - red
  static const Color lightError = Color.fromARGB(255, 239, 68, 68);
  
  /// Info state color for informational messages in light mode - blue
  static const Color lightInfo = Color.fromARGB(255, 59, 130, 246);
  
  // ─────────────────────────────────────────────────────────────
  // DARK THEME COLORS
  // ─────────────────────────────────────────────────────────────
  
  // Primary Brand Colors (Dark Theme)
  /// Main slate blue brand color used for primary buttons and interactive elements in dark mode - brighter than light mode
  static const Color darkPrimary = Color.fromARGB(255, 127, 165, 193);
  
  /// Light blue-grey color used for hover states and secondary accents in dark mode
  static const Color darkPrimaryHover = Color.fromARGB(255, 184, 202, 219);
  
  /// Tertiary brand color (green) used for success states and accents in dark mode
  static const Color darkTertiary = Color.fromARGB(255, 34, 197, 94);
  
  // Surface Colors (Dark Theme)
  /// Main background color for the entire app in dark mode - rich dark gray (not pure black for better readability)
  static const Color darkSurface = Color.fromARGB(255, 18, 18, 20);
  
  /// Secondary surface color for elevated elements like list tiles and navigation bars in dark mode
  static const Color darkSurfaceSecondary = Color.fromARGB(255, 28, 28, 32);
  
  /// Tertiary surface color for cards and containers in dark mode
  static const Color darkSurfaceTertiary = Color.fromARGB(255, 38, 38, 44);
  
  /// Elevated surface color for highest elevation elements in dark mode
  static const Color darkSurfaceElevated = Color.fromARGB(255, 48, 48, 56);
  
  // Text Colors (Dark Theme)
  /// Primary text color for main content in dark mode - crisp white
  static const Color darkOnSurface = Color.fromARGB(255, 248, 250, 252);
  
  /// Secondary text color for less emphasized content in dark mode - muted gray
  static const Color darkOnSurfaceSecondary = Color.fromARGB(255, 156, 163, 175);
  
  /// Tertiary text color for subtle hints and disabled states in dark mode - subtle gray
  static const Color darkOnSurfaceTertiary = Color.fromARGB(255, 107, 114, 128);
  
  // Semantic Colors (Dark Theme)
  /// Success state color for positive actions and confirmations in dark mode - green
  static const Color darkSuccess = Color.fromARGB(255, 34, 197, 94);
  
  /// Warning state color for cautionary messages in dark mode - amber
  static const Color darkWarning = Color.fromARGB(255, 245, 158, 11);
  
  /// Error state color for destructive actions and errors in dark mode - red
  static const Color darkError = Color.fromARGB(255, 239, 68, 68);
  
  /// Info state color for informational messages in dark mode - blue
  static const Color darkInfo = Color.fromARGB(255, 59, 130, 246);
  
  // ─────────────────────────────────────────────────────────────
  // LEGACY COLOR ALIASES (for backwards compatibility - deprecated)
  // These are kept temporarily to avoid breaking existing code
  // Please use the new lightX or darkX naming convention above
  // ─────────────────────────────────────────────────────────────
  
  @Deprecated('Use lightPrimary instead')
  static const Color primary = lightPrimary;
  
  @Deprecated('Use lightPrimaryHover instead')
  static const Color primaryHover = lightPrimaryHover;
  
  @Deprecated('Use darkPrimary instead')
  static const Color primaryDark = darkPrimary;
  
  @Deprecated('Use lightSurface instead')
  static const Color surface = lightSurface;
  
  @Deprecated('Use darkSurface instead')
  static const Color surfaceDark = darkSurface;
  
  @Deprecated('Use darkSurfaceSecondary instead')
  static const Color surfaceDarkSecondary = darkSurfaceSecondary;
  
  @Deprecated('Use darkSurfaceTertiary instead')
  static const Color surfaceDarkTertiary = darkSurfaceTertiary;
  
  @Deprecated('Use darkSurfaceElevated instead')
  static const Color surfaceDarkElevated = darkSurfaceElevated;
  
  @Deprecated('Use lightOnSurface instead')
  static const Color onSurface = lightOnSurface;
  
  @Deprecated('Use darkOnSurface instead')
  static const Color onSurfaceDark = darkOnSurface;
  
  @Deprecated('Use darkOnSurfaceSecondary instead')
  static const Color onSurfaceDarkSecondary = darkOnSurfaceSecondary;
  
  @Deprecated('Use darkOnSurfaceTertiary instead')
  static const Color onSurfaceDarkTertiary = darkOnSurfaceTertiary;
  
  @Deprecated('Use lightTertiary or darkTertiary instead')
  static const Color tertiary = lightTertiary;
  
  @Deprecated('Use lightSuccess or darkSuccess instead')
  static const Color success = lightSuccess;
  
  @Deprecated('Use lightWarning or darkWarning instead')
  static const Color warning = lightWarning;
  
  @Deprecated('Use lightError or darkError instead')
  static const Color error = lightError;
  
  @Deprecated('Use lightInfo or darkInfo instead')
  static const Color info = lightInfo;

  // ─────────────────────────────────────────────────────────────
  // Typography
  // ─────────────────────────────────────────────────────────────
  static TextTheme get textTheme => _buildTextTheme(DeviceUtils.scaleFactor);
  
  static TextTheme _buildTextTheme(double scaleFactor) => GoogleFonts.interTextTheme().copyWith(
    // Headlines
    headlineLarge: GoogleFonts.inter(
      fontSize: 32 * scaleFactor,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28 * scaleFactor,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 24 * scaleFactor,
      fontWeight: FontWeight.w600,
    ),
    
    // Titles
    titleLarge: GoogleFonts.inter(
      fontSize: 22 * scaleFactor,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16 * scaleFactor,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.w500,
    ),
    
    // Body text
    bodyLarge: GoogleFonts.inter(
      fontSize: 16 * scaleFactor,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12 * scaleFactor,
      fontWeight: FontWeight.w400,
    ),
    
    // Labels
    labelLarge: GoogleFonts.inter(
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12 * scaleFactor,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11 * scaleFactor,
      fontWeight: FontWeight.w500,
    ),
  );

  // ─────────────────────────────────────────────────────────────
  // Spacing
  // ─────────────────────────────────────────────────────────────
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;

  // ─────────────────────────────────────────────────────────────
  // Border Radius
  // ─────────────────────────────────────────────────────────────
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;
  static const double radiusFull = 999.0;

  // ─────────────────────────────────────────────────────────────
  // Icon Sizes
  // ─────────────────────────────────────────────────────────────
  static double get iconSmall => 16.0 * DeviceUtils.scaleFactor;
  static double get iconMedium => 24.0 * DeviceUtils.scaleFactor;
  static double get iconLarge => 32.0 * DeviceUtils.scaleFactor;
  static double get iconXLarge => 48.0 * DeviceUtils.scaleFactor;

  // ─────────────────────────────────────────────────────────────
  // Component Sizes
  // ─────────────────────────────────────────────────────────────
  static double get buttonHeight => 48.0;
  static double get inputHeight => 48.0;
  static double get avatarSize => 40.0;
  static double get avatarSizeLarge => 64.0;
  static double get listTileHeight => 72.0;

  // ─────────────────────────────────────────────────────────────
  // Shadows
  // ─────────────────────────────────────────────────────────────
  static List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // Dark theme shadows with subtle glow effects
  static List<BoxShadow> get shadowSmallDark => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: surfaceDarkElevated.withOpacity(0.1),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowMediumDark => [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: surfaceDarkElevated.withOpacity(0.15),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowLargeDark => [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: surfaceDarkElevated.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // ─────────────────────────────────────────────────────────────
  // Responsive Helpers
  // ─────────────────────────────────────────────────────────────
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < 600;
  
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= 600 && 
      MediaQuery.of(context).size.width < 900;
  
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= 900;

  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return spacing16;
    if (isTablet(context)) return spacing24;
    return spacing32;
  }

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isMobile(context)) return baseSize;
    if (isTablet(context)) return baseSize * 1.1;
    return baseSize * 1.2;
  }
}

/// Predefined text styles for common use cases
class AppTextStyles {
  static TextStyle get heading1 => AppDesignSystem.textTheme.headlineLarge!;
  static TextStyle get heading2 => AppDesignSystem.textTheme.headlineMedium!;
  static TextStyle get heading3 => AppDesignSystem.textTheme.headlineSmall!;
  
  static TextStyle get titleLarge => AppDesignSystem.textTheme.titleLarge!;
  static TextStyle get titleMedium => AppDesignSystem.textTheme.titleMedium!;
  static TextStyle get titleSmall => AppDesignSystem.textTheme.titleSmall!;

  static TextStyle get body => AppDesignSystem.textTheme.bodyMedium!;
  static TextStyle get bodyLarge => AppDesignSystem.textTheme.bodyLarge!;
  static TextStyle get bodySmall => AppDesignSystem.textTheme.bodySmall!;
  
  static TextStyle get caption => AppDesignSystem.textTheme.labelSmall!;
  static TextStyle get button => AppDesignSystem.textTheme.labelLarge!;
  
  // Custom styles
  static TextStyle get listTitle => AppDesignSystem.textTheme.titleMedium!.copyWith(
    fontWeight: FontWeight.w600,
  );
  
  static TextStyle get listSubtitle => AppDesignSystem.textTheme.bodySmall!.copyWith(
    color: Colors.grey.shade600,
  );
  
  // Method to get text styles with current scale factor
  static TextStyle getHeading1() => AppDesignSystem.textTheme.headlineLarge!;
  static TextStyle getHeading2() => AppDesignSystem.textTheme.headlineMedium!;
  static TextStyle getHeading3() => AppDesignSystem.textTheme.headlineSmall!;
  static TextStyle getBody() => AppDesignSystem.textTheme.bodyMedium!;
  static TextStyle getBodyLarge() => AppDesignSystem.textTheme.bodyLarge!;
  static TextStyle getBodySmall() => AppDesignSystem.textTheme.bodySmall!;
  static TextStyle getCaption() => AppDesignSystem.textTheme.labelSmall!;
  static TextStyle getButton() => AppDesignSystem.textTheme.labelLarge!;
  static TextStyle getListTitle() => AppDesignSystem.textTheme.titleMedium!.copyWith(
    fontWeight: FontWeight.w600,
  );
  static TextStyle getListSubtitle() => AppDesignSystem.textTheme.bodySmall!.copyWith(
    color: Colors.grey.shade600,
  );
}
