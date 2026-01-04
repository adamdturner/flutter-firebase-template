import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'core/theme_manager.dart';
import 'core/font_scale_manager.dart';
import 'core/utils/device_utils.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/issue_report_repository.dart';
import 'envdb.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/auth/auth_state.dart';
import 'logic/database_switch/env_cubit.dart';
import 'logic/user/user_bloc.dart';
import 'logic/user/user_event.dart';
import 'logic/user/user_state.dart';
import 'logic/issue_report/issue_report_bloc.dart';
import 'logic/navigation/navigation_bloc.dart';
import 'presentation/screens/central_hub/central_hub_screen.dart';
import 'routes/app_router.dart';

/// The authenticated portion of the app.
/// 
/// This widget is displayed when the user is logged in and provides
/// all the authenticated-only providers (repositories, blocs, etc.)
class AuthenticatedApp extends StatelessWidget {
  final String uid;
  final EnvCubit envCubit;
  
  const AuthenticatedApp({
    super.key, 
    required this.uid, 
    required this.envCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EnvCubit>.value(
      value: envCubit,
      child: BlocBuilder<EnvCubit, Env>(
        builder: (context, currentEnv) {
          final envDb = EnvDb(currentEnv);
          
          return MultiProvider(
            providers: [
              // Repository providers - environment-aware
              Provider<AuthRepository>(
                create: (_) => AuthRepository(envDb: envDb),
              ),
              Provider<UserRepository>(
                create: (_) => UserRepository(envDb: envDb),
              ),
              Provider<IssueReportRepository>(
                create: (_) => IssueReportRepository(envDb: envDb),
              ),
            ],
            child: MultiBlocProvider(
              // Force recreation when environment changes
              key: ValueKey(currentEnv.name),
              providers: [
                // Auth bloc for sign out functionality
                BlocProvider<AuthBloc>(
                  create: (context) => AuthBloc(context.read<AuthRepository>()),
                ),
                // User bloc - fetches user data immediately
                BlocProvider<UserBloc>(
                  key: ValueKey('user_bloc_${currentEnv.name}'),
                  create: (context) {
                    final bloc = UserBloc(
                      userRepository: context.read<UserRepository>(),
                    );
                    // Fetch user data immediately when bloc is created
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      bloc.add(FetchUserRequested(currentUser.uid));
                    }
                    return bloc;
                  },
                ),
                // Issue report bloc for reporting issues
                BlocProvider<IssueReportBloc>(
                  create: (context) => IssueReportBloc(
                    issueReportRepository: context.read<IssueReportRepository>(),
                  ),
                ),
                // Navigation bloc for app navigation state
                BlocProvider<NavigationBloc>(
                  create: (_) => NavigationBloc(),
                ),
              ],
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, authState) {
                  // Clear user cache when signing out
                  if (authState is AuthUnauthenticated) {
                    context.read<UserBloc>().add(ClearUserCache());
                  }
                },
                child: BlocListener<UserBloc, UserState>(
                  listener: (context, userState) {
                    // Enforce admin-only demo mode
                    if (userState is UserLoaded) {
                      final currentEnv = context.read<EnvCubit>().state;
                      final isAdmin = userState.user.role == 'admin';
                      
                      // If in demo mode but user is not admin, switch to production
                      if (currentEnv == Env.sandbox && !isAdmin) {
                        context.read<EnvCubit>().setEnv(Env.prod);
                      }
                    }
                  },
                  child: Consumer2<ThemeManager, FontScaleManager>(
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
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Updates system UI colors based on theme.
  void _updateSystemUI(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? const Color(0xFF121212) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}

