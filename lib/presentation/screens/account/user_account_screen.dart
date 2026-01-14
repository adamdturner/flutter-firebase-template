import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/core/utils/device_utils.dart';

import 'package:flutter_firebase_template/logic/auth/auth_bloc.dart';
import 'package:flutter_firebase_template/logic/auth/auth_event.dart';
import 'package:flutter_firebase_template/logic/auth/auth_state.dart';
import 'package:flutter_firebase_template/logic/database_switch/env_cubit.dart';
import 'package:flutter_firebase_template/envdb.dart';

import 'package:flutter_firebase_template/logic/user/user_bloc.dart';
import 'package:flutter_firebase_template/logic/user/user_event.dart';
import 'package:flutter_firebase_template/logic/user/user_state.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  @override
  void initState() {
    super.initState();
    // Check if user data is already loaded, if not then fetch it
    final userBloc = context.read<UserBloc>();
    final currentState = userBloc.state;
    
    // Only fetch if we don't have user data loaded
    if (currentState is! UserLoaded) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        userBloc.add(FetchUserRequested(authState.user.uid));
      }
    }
  }

  Future<void> _onRefresh() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    final userBloc = context.read<UserBloc>();
    userBloc.add(RefreshUserRequested(authState.user.uid));

    await userBloc.stream.firstWhere(
      (state) => state is UserLoaded || state is UserFailure,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Account',
          showBackButton: true,
          actions: DeviceUtils.getDeviceType() == 'Web'
              ? [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _onRefresh,
                    tooltip: 'Refresh account',
                  ),
                ]
              : null,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppDesignSystem.surfaceDarkSecondary
            : AppDesignSystem.surface,
        body: SafeArea(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<EnvCubit, Env>(
      builder: (context, currentEnv) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final content = _buildScrollableContent(
              context: context,
              state: state,
              currentEnv: currentEnv,
            );

            final isWeb = DeviceUtils.getDeviceType() == 'Web';
            if (isWeb) {
              return content;
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: content,
            );
          },
        );
      },
    );
  }

  Widget _buildScrollableContent({
    required BuildContext context,
    required UserState state,
    required Env currentEnv,
  }) {
    if (state is UserLoaded) {
      final user = state.user;
      final isAdmin = user.role == 'admin';
      final isDemoMode = currentEnv == Env.sandbox;

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(AppDesignSystem.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info card
              _buildUserInfoCard(context, user),
              
              SizedBox(height: AppDesignSystem.spacing24),

              // Personal Section
              _buildSectionHeader(context, 'Personal', Icons.person_outline),
              SizedBox(height: AppDesignSystem.spacing12),
              _buildButtonCard(context, [
                AppNavigationButton(
                  text: "Profile",
                  icon: Icons.person,
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                ),
                AppNavigationButton(
                  text: "Settings",
                  icon: Icons.settings,
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
              ]),

              SizedBox(height: AppDesignSystem.spacing24),

              // Features Section
              _buildSectionHeader(context, 'Features', Icons.apps_outlined),
              SizedBox(height: AppDesignSystem.spacing12),
              _buildButtonCard(context, [
                AppNavigationButton(
                  text: "Feature 1",
                  icon: Icons.star_outline,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature 1 - Not implemented')),
                    );
                  },
                ),
                AppNavigationButton(
                  text: "Feature 2",
                  icon: Icons.favorite_outline,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature 2 - Not implemented')),
                    );
                  },
                ),
                AppNavigationButton(
                  text: "Feature 3",
                  icon: Icons.bookmark_outline,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature 3 - Not implemented')),
                    );
                  },
                ),
              ]),

              // Admin sections (only for admin users)
              if (isAdmin) ...[
                if (!isDemoMode) ...[
                  SizedBox(height: AppDesignSystem.spacing24),
                  _buildSectionHeader(context, 'Admin Tools', Icons.build_outlined),
                  SizedBox(height: AppDesignSystem.spacing12),
                  _buildButtonCard(context, [
                    AppNavigationButton(
                      text: "View Issue Reports",
                      icon: Icons.report_outlined,
                      onPressed: () => Navigator.pushNamed(context, '/admin_issue_reports'),
                    ),
                    AppNavigationButton(
                      text: "Manage Users",
                      icon: Icons.people_outline,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User Management - Not implemented')),
                        );
                      },
                    ),
                    AppNavigationButton(
                      text: "Analytics",
                      icon: Icons.bar_chart_outlined,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Analytics - Not implemented')),
                        );
                      },
                    ),
                  ]),
                ],
                
                SizedBox(height: AppDesignSystem.spacing24),
                _buildSectionHeader(context, 'Admin Controls', Icons.admin_panel_settings),
                SizedBox(height: AppDesignSystem.spacing12),
                _buildButtonCard(context, [
                  if (!isDemoMode)
                    AppNavigationButton(
                      text: "Add Admin",
                      icon: Icons.person_add,
                      onPressed: () => Navigator.pushNamed(context, '/add_admin'),
                    ),
                  BlocBuilder<EnvCubit, Env>(
                    builder: (context, env) {
                      final buttonText = env == Env.sandbox 
                          ? 'Switch to Production Mode'
                          : 'Switch to Demo Mode';
                      return AppNavigationButton(
                        text: buttonText,
                        icon: Icons.swap_horiz,
                        onPressed: () => _showModeSwitchConfirmation(context),
                      );
                    },
                  ),
                ]),
              ],

              SizedBox(height: AppDesignSystem.spacing24),

              // Support Section
              _buildSectionHeader(context, 'Support', Icons.help_outline),
              SizedBox(height: AppDesignSystem.spacing12),
              _buildButtonCard(context, [
                AppNavigationButton(
                  text: "Report Issue",
                  icon: Icons.bug_report_outlined,
                  onPressed: () => Navigator.pushNamed(context, '/report_issue'),
                ),
              ]),

              SizedBox(height: AppDesignSystem.spacing24),

              // Account Section
              _buildSectionHeader(context, 'Account', Icons.account_circle_outlined),
              SizedBox(height: AppDesignSystem.spacing12),
              _buildButtonCard(context, [
                AppNavigationButton.destructive(
                  text: "Sign Out",
                  icon: Icons.logout,
                  onPressed: () => _showLogoutDialog(context),
                ),
              ]),

              SizedBox(height: AppDesignSystem.spacing32),
            ],
          ),
        ),
      );
    }

    if (state is UserFailure) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: _buildErrorState(context, state.message),
          ),
        ],
      );
    }

    // Handle loading and initial states with a scrollable container
    return const CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: true,
          child: AppLoadingWidget(
            message: 'Loading your account...',
            isFullScreen: false,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDesignSystem.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDesignSystem.iconXLarge,
              color: AppDesignSystem.error,
            ),
            SizedBox(height: AppDesignSystem.spacing16),
            Text(
              'Unable to load account',
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDesignSystem.spacing8),
            Text(
              message,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDesignSystem.spacing24),
            AppNavigationButton(
              text: "Try Again",
              icon: Icons.refresh,
              onPressed: () {
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthAuthenticated) {
                  context
                      .read<UserBloc>()
                      .add(FetchUserRequested(authState.user.uid));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, dynamic user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: isDark 
            ? AppDesignSystem.surfaceDarkSecondary 
            : Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        border: Border.all(
          color: isDark 
              ? Colors.grey.shade800 
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppDesignSystem.primary,
            child: Text(
              user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: AppDesignSystem.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName ?? 'User',
                  style: AppTextStyles.heading3,
                ),
                SizedBox(height: AppDesignSystem.spacing4),
                Text(
                  user.email ?? '',
                  style: AppTextStyles.body.copyWith(
                    color: isDark 
                        ? AppDesignSystem.onSurfaceDarkSecondary 
                        : Colors.grey.shade600,
                  ),
                ),
                if (user.role != null) ...[
                  SizedBox(height: AppDesignSystem.spacing8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDesignSystem.spacing8,
                      vertical: AppDesignSystem.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: user.role == 'admin' 
                          ? AppDesignSystem.primary.withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                    ),
                    child: Text(
                      user.role.toString().toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: user.role == 'admin' 
                            ? AppDesignSystem.primary
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        Icon(
          icon,
          size: AppDesignSystem.iconMedium,
          color: isDark 
              ? AppDesignSystem.onSurfaceDark 
              : AppDesignSystem.primary,
        ),
        SizedBox(width: AppDesignSystem.spacing8),
        Text(
          title,
          style: AppTextStyles.listTitle.copyWith(
            color: isDark 
                ? AppDesignSystem.onSurfaceDark 
                : AppDesignSystem.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonCard(BuildContext context, List<Widget> buttons) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Add spacing between buttons
    final spacedButtons = <Widget>[];
    for (int i = 0; i < buttons.length; i++) {
      spacedButtons.add(buttons[i]);
      if (i < buttons.length - 1) {
        spacedButtons.add(SizedBox(height: AppDesignSystem.spacing8));
      }
    }
    
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? AppDesignSystem.surfaceDarkSecondary 
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        border: Border.all(
          color: isDark 
              ? Colors.grey.shade800 
              : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spacing16,
          vertical: AppDesignSystem.spacing8,
        ),
        child: Column(
          children: spacedButtons,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: AppTextStyles.heading3,
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.button.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
            AppNavigationButton.destructive(
              text: "Sign Out",
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
            ),
          ],
        );
      },
    );
  }

  void _showModeSwitchConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final currentEnv = context.read<EnvCubit>().state;
        final isDemo = currentEnv == Env.sandbox;
        final targetEnv = isDemo ? Env.prod : Env.sandbox;
        final targetMode = isDemo ? 'Production' : 'Demo';
        
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Switch to $targetMode Mode',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure? Switching to $targetMode Mode will log you out.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You will need to sign in again after switching to $targetMode mode.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _switchEnvironment(context, targetEnv);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Switch to $targetMode',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _switchEnvironment(BuildContext context, Env targetEnv) async {
    try {
      // First, show a loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Switching environment...',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ),
        );
      }
      
      // Sign out the user first and wait for it to complete
      if (mounted) {
        final authBloc = context.read<AuthBloc>();
        authBloc.add(AuthSignOutRequested());
        
        // Wait for the sign-out to complete by listening to AuthBloc
        await authBloc.stream.firstWhere(
          (state) => state is AuthUnauthenticated,
        );
      }
      
      // Now switch environment - this will only happen after user is signed out
      if (mounted) {
        await context.read<EnvCubit>().setEnv(targetEnv);
      }
      
      // Show success message
      if (mounted) {
        final modeName = targetEnv == Env.sandbox ? 'Demo' : 'Production';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Switched to $modeName Mode. Please sign in again.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error switching environment: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

}
