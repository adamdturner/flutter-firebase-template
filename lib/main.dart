import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/theme_manager.dart';
import 'core/font_scale_manager.dart';
import 'core/utils/device_utils.dart';
import 'app/app_providers.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/auth/auth_state.dart';
import 'logic/database_switch/env_cubit.dart';
import 'authenticated_app.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/loading_screen.dart';
import 'routes/app_router.dart';

/// Application entry point.
///
/// Initializes Firebase and loads environment preferences before starting the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load saved environment preference
  final envCubit = await EnvCubit.load();

  // Enable edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(TemplateApp(envCubit: envCubit));
}

/// Root application widget that handles authentication state.
class TemplateApp extends StatelessWidget {
  final EnvCubit envCubit;

  const TemplateApp({super.key, required this.envCubit});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      envCubit: envCubit,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            // User is authenticated - show the authenticated app
            return AuthenticatedApp(uid: state.user.uid);
          } else if (state is AuthUnauthenticated || state is AuthFailure) {
            // User is not authenticated - show login screen
            return _buildUnauthenticatedApp(context);
          } else {
            // Loading or initial state
            return _buildLoadingApp(context);
          }
        },
      ),
    );
  }

  /// Builds the unauthenticated app with login screen.
  Widget _buildUnauthenticatedApp(BuildContext context) {
    return Consumer2<ThemeManager, FontScaleManager>(
      builder: (context, themeManager, fontScaleManager, child) {
        final theme = themeManager.getTheme(context);
        final isDark = theme.brightness == Brightness.dark;

        _updateSystemUI(isDark);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Firebase Template',
          theme: theme,
          home: const LoginScreen(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          builder: (context, child) {
            DeviceUtils.init(context);
            return child!;
          },
        );
      },
    );
  }

  /// Builds the loading app shown during authentication check.
  Widget _buildLoadingApp(BuildContext context) {
    return Consumer2<ThemeManager, FontScaleManager>(
      builder: (context, themeManager, fontScaleManager, child) {
        final theme = themeManager.getTheme(context);
        final isDark = theme.brightness == Brightness.dark;

        _updateSystemUI(isDark);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Firebase Template',
          theme: theme,
          home: const LoadingScreen(),
          onGenerateRoute: AppRouter.onGenerateRoute,
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
            isDark ? const Color(0xFF121212) : Colors.white,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
