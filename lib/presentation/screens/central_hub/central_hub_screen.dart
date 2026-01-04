import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';
import 'package:flutter_firebase_template/logic/auth/auth_bloc.dart';
import 'package:flutter_firebase_template/logic/auth/auth_event.dart';
import 'package:flutter_firebase_template/logic/user/user_bloc.dart';
import 'package:flutter_firebase_template/logic/user/user_state.dart';

// Main landing page after login
class CentralHubScreen extends StatelessWidget {
  const CentralHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        showBackButton: false,
        actions: [
          // Account button
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.pushNamed(context, '/account'),
            tooltip: 'Account',
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppDesignSystem.surfaceDarkSecondary
          : AppDesignSystem.surface,
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return _buildMainContent(context, state.user);
        }
        
        if (state is UserFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppDesignSystem.error,
                ),
                SizedBox(height: AppDesignSystem.spacing16),
                Text(
                  'Failed to load user data',
                  style: AppTextStyles.heading3,
                ),
                SizedBox(height: AppDesignSystem.spacing8),
                Text(
                  state.message,
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return const Center(
          child: AppLoadingWidget(
            message: 'Loading...',
            isFullScreen: false,
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, dynamic user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Text(
            'Welcome back,',
            style: AppTextStyles.heading2.copyWith(
              color: isDark 
                  ? AppDesignSystem.onSurfaceDarkSecondary 
                  : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: AppDesignSystem.spacing4),
          Text(
            user.displayName ?? 'User',
            style: AppTextStyles.heading1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: AppDesignSystem.spacing32),
          
          // Quick actions section
          Text(
            'Quick Actions',
            style: AppTextStyles.heading3,
          ),
          SizedBox(height: AppDesignSystem.spacing16),
          
          _buildQuickActionsGrid(context),
          
          SizedBox(height: AppDesignSystem.spacing32),
          
          // Placeholder content section
          Text(
            'Getting Started',
            style: AppTextStyles.heading3,
          ),
          SizedBox(height: AppDesignSystem.spacing16),
          
          _buildInfoCard(
            context,
            icon: Icons.rocket_launch_outlined,
            title: 'Welcome to the App',
            description: 'This is your main dashboard. Customize this screen to show your app\'s main features and content.',
            isDark: isDark,
          ),
          
          SizedBox(height: AppDesignSystem.spacing16),
          
          _buildInfoCard(
            context,
            icon: Icons.lightbulb_outline,
            title: 'Quick Tip',
            description: 'Navigate to your account page using the button in the top right to manage your profile and settings.',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppDesignSystem.spacing16,
      crossAxisSpacing: AppDesignSystem.spacing16,
      childAspectRatio: 1.5,
      children: [
        _buildQuickActionCard(
          context: context,
          icon: Icons.person_outline,
          label: 'Profile',
          onTap: () => Navigator.pushNamed(context, '/profile'),
        ),
        _buildQuickActionCard(
          context: context,
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
        _buildQuickActionCard(
          context: context,
          icon: Icons.star_outline,
          label: 'Feature 1',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feature 1 - Not implemented')),
            );
          },
        ),
        _buildQuickActionCard(
          context: context,
          icon: Icons.favorite_outline,
          label: 'Feature 2',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feature 2 - Not implemented')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppDesignSystem.iconLarge,
              color: AppDesignSystem.primary,
            ),
            SizedBox(height: AppDesignSystem.spacing8),
            Text(
              label,
              style: AppTextStyles.button,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDesignSystem.spacing12),
            decoration: BoxDecoration(
              color: AppDesignSystem.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
            ),
            child: Icon(
              icon,
              color: AppDesignSystem.primary,
              size: AppDesignSystem.iconMedium,
            ),
          ),
          SizedBox(width: AppDesignSystem.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.listTitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppDesignSystem.spacing4),
                Text(
                  description,
                  style: AppTextStyles.body.copyWith(
                    color: isDark 
                        ? AppDesignSystem.onSurfaceDarkSecondary 
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.button.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
              child: Text(
                'Sign Out',
                style: AppTextStyles.button.copyWith(
                  color: AppDesignSystem.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}