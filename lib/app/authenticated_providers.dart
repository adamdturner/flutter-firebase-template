import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/issue_report_repository.dart';
import '../envdb.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_state.dart';
import '../logic/database_switch/env_cubit.dart';
import '../logic/user/user_bloc.dart';
import '../logic/user/user_event.dart';
import '../logic/user/user_state.dart';
import '../logic/issue_report/issue_report_bloc.dart';
import '../logic/navigation/navigation_bloc.dart';
import '../logic/admin/admin_bloc.dart';
import '../logic/image_picker/image_picker_cubit.dart';
import '../data/services/add_admin_service.dart';
import '../data/services/image_upload_service.dart';

/// Composition root for authenticated-only providers.
///
/// These providers are only alive when the user is authenticated and include:
/// - Environment-aware repositories: [AuthRepository], [UserRepository], [IssueReportRepository]
/// - Authenticated blocs: [UserBloc], [IssueReportBloc], [NavigationBloc]
///
/// This scope is recreated when the environment changes (via ValueKey).
class AuthenticatedProviders extends StatelessWidget {
  final String uid;
  final Widget child;

  const AuthenticatedProviders({
    super.key,
    required this.uid,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnvCubit, Env>(
      builder: (context, currentEnv) {
        final envDb = EnvDb(currentEnv);

        return MultiProvider(
          // Force recreation when environment changes
          key: ValueKey('authenticated_providers_${currentEnv.name}'),
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
            // Service providers
            Provider<AddAdminService>(
              create: (_) => AddAdminService(),
            ),
            Provider<ImageUploadService>(
              create: (_) => ImageUploadService(),
            ),
          ],
          child: _AuthenticatedBlocs(
            uid: uid,
            currentEnv: currentEnv,
            child: child,
          ),
        );
      },
    );
  }
}

/// Internal widget that provides authenticated-only blocs.
///
/// Separating this allows proper context access to repositories.
class _AuthenticatedBlocs extends StatelessWidget {
  final String uid;
  final Env currentEnv;
  final Widget child;

  const _AuthenticatedBlocs({
    required this.uid,
    required this.currentEnv,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Force recreation when environment changes
      key: ValueKey('authenticated_blocs_${currentEnv.name}'),
      providers: [
        // User bloc - fetches user data immediately
        BlocProvider<UserBloc>(
          create: (context) {
            final bloc = UserBloc(
              userRepository: context.read<UserRepository>(),
            );
            // Fetch user data immediately when bloc is created
            bloc.add(FetchUserRequested(uid));
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
        // Admin bloc for admin user management
        BlocProvider<AdminBloc>(
          create: (context) => AdminBloc(
            addAdminService: context.read<AddAdminService>(),
          ),
        ),
        // Image picker cubit for image selection and upload
        BlocProvider<ImagePickerCubit>(
          create: (context) => ImagePickerCubit(
            imageUploadService: context.read<ImageUploadService>(),
          ),
        ),
      ],
      child: _AuthenticatedListeners(child: child),
    );
  }
}

/// Internal widget that sets up listeners for authenticated scope.
///
/// Handles:
/// - Clearing user cache on sign-out
/// - Enforcing admin-only demo mode
class _AuthenticatedListeners extends StatelessWidget {
  final Widget child;

  const _AuthenticatedListeners({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // Listen to the top-level AuthBloc from AppProviders
      listener: (context, authState) {
        // Clear user cache when signing out
        if (authState is AuthUnauthenticated) {
          context.read<UserBloc>().add(ClearUserCache());
        }
      },
      child: BlocListener<UserBloc, UserState>(
        listener: (context, userState) {
          // Enforce admin-only demo mode
          _enforceAdminOnlyDemoMode(context, userState);
        },
        child: child,
      ),
    );
  }

  /// Switches from sandbox to prod if the current user is not an admin.
  void _enforceAdminOnlyDemoMode(BuildContext context, UserState userState) {
    if (userState is UserLoaded) {
      final currentEnv = context.read<EnvCubit>().state;
      final isAdmin = userState.user.role == 'admin';

      // If in demo mode but user is not admin, switch to production
      if (currentEnv == Env.sandbox && !isAdmin) {
        context.read<EnvCubit>().setEnv(Env.prod);
      }
    }
  }
}

