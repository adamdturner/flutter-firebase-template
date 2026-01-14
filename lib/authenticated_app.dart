import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme_manager.dart';
import 'core/font_scale_manager.dart';
import 'core/design_system.dart';
import 'core/utils/device_utils.dart';
import 'app/authenticated_providers.dart';
import 'presentation/screens/central_hub/central_hub_screen.dart';
import 'routes/app_router.dart';

/// The authenticated portion of the app.
///
/// This widget is displayed when the user is logged in. It wraps the
/// authenticated MaterialApp with [AuthenticatedProviders] which provides
/// environment-aware repositories and authenticated-only blocs.
///
/// Note: [AuthBloc] is NOT provided here - it comes from [AppProviders]
/// at the app root level, ensuring a single auth instance.
class AuthenticatedApp extends StatelessWidget {
  final String uid;

  const AuthenticatedApp({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return AuthenticatedProviders(
      uid: uid,
      child: _AuthenticatedMaterialApp(),
    );
  }
}

/// The authenticated MaterialApp shell.
///
/// Consumes theme/font managers and renders the authenticated route tree.
class _AuthenticatedMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeManager, FontScaleManager>(
      builder: (context, themeManager, fontScaleManager, child) {
        final theme = themeManager.getTheme(context);
        final isDark = theme.brightness == Brightness.dark;

        _updateSystemUI(isDark);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Firebase Template',
          theme: theme,
          home: const CentralHubScreen(),
          onGenerateRoute: AppRouter.authenticatedRoutes,
          builder: (context, child) {
            DeviceUtils.init(context);
            return child!;
          },
        );
      },
    );
  }

  /// Updates system UI colors based on theme.
  void _updateSystemUI(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor:
            isDark ? AppDesignSystem.darkSurface : AppDesignSystem.lightSurface,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
