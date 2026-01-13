import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../core/theme_manager.dart';
import '../core/font_scale_manager.dart';
import '../data/repositories/auth_repository.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_event.dart';
import '../logic/database_switch/env_cubit.dart';

/// Composition root for app-wide providers.
///
/// These providers are always alive throughout the app lifecycle and include:
/// - [EnvCubit]: Environment selection (prod/sandbox)
/// - [ThemeManager]: Theme preferences
/// - [FontScaleManager]: Font scaling preferences
/// - [AuthBloc]: Single auth bloc instance for the entire app
class AppProviders extends StatelessWidget {
  final EnvCubit envCubit;
  final Widget child;

  const AppProviders({
    super.key,
    required this.envCubit,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Environment cubit - pre-loaded before app starts
        BlocProvider<EnvCubit>.value(value: envCubit),
        // Theme and font scale managers
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => FontScaleManager()),
      ],
      child: _AuthBlocProvider(child: child),
    );
  }
}

/// Internal widget that provides AuthBloc with access to EnvCubit.
///
/// AuthBloc uses a production AuthRepository since sign-up/sign-in
/// should always write to production Firestore.
class _AuthBlocProvider extends StatelessWidget {
  final Widget child;

  const _AuthBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    // AuthBloc uses production environment for auth operations.
    // Sign-up user data always goes to prod; env-aware reads happen
    // via UserRepository in the authenticated scope.
    final authRepository = AuthRepository();

    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(authRepository)..add(AuthStarted()),
      child: child,
    );
  }
}

