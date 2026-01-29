import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/common/custom_app_bar_widget.dart';
import 'package:flutter_firebase_template/presentation/widgets/common/generic_logo_widget.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';
import 'package:flutter_firebase_template/logic/database_switch/env_cubit.dart';
import 'package:flutter_firebase_template/envdb.dart';

import 'package:flutter_firebase_template/logic/auth/auth_bloc.dart';
import 'package:flutter_firebase_template/logic/auth/auth_event.dart';
import 'package:flutter_firebase_template/logic/auth/auth_state.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Flutter Firebase Template',
        showBackButton: false,
      ),
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return const _LoginForm();
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      context.read<AuthBloc>().add(AuthSignInRequested(email: email, password: password));
    }
  }

  void _onForgotPasswordPressed(BuildContext context) {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showErrorSnackBar(context, 'Please enter your email address first');
      return;
    }
    _showForgotPasswordDialog(context, email);
  }

  void _showForgotPasswordDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.lock_reset_rounded,
                color: AppDesignSystem.primary,
                size: AppDesignSystem.iconMedium,
              ),
              const SizedBox(width: AppDesignSystem.spacing12),
              Text(
                'Reset Password',
                style: AppTextStyles.heading3.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We will send a password reset link to:',
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? AppDesignSystem.onSurfaceDarkSecondary 
                      : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: AppDesignSystem.spacing12),
              Container(
                padding: const EdgeInsets.all(AppDesignSystem.spacing12),
                decoration: BoxDecoration(
                  color: AppDesignSystem.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  border: Border.all(
                    color: AppDesignSystem.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: AppDesignSystem.primary,
                      size: AppDesignSystem.iconSmall,
                    ),
                    const SizedBox(width: AppDesignSystem.spacing8),
                    Expanded(
                      child: Text(
                        email,
                        style: AppTextStyles.body.copyWith(
                          color: AppDesignSystem.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDesignSystem.spacing16),
              Text(
                'Check your email and follow the instructions to reset your password.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? AppDesignSystem.onSurfaceDarkSecondary 
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).brightness == Brightness.dark 
                    ? AppDesignSystem.onSurfaceDarkSecondary 
                    : Colors.grey.shade600,
              ),
              child: Text(
                'Cancel',
                style: AppTextStyles.button.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? AppDesignSystem.onSurfaceDarkSecondary 
                      : Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthForgotPasswordRequested(email: email));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesignSystem.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                ),
              ),
              child: Text(
                'Send Reset Link',
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          _showErrorSnackBar(context, state.error);
        } else if (state is AuthAuthenticated) {
          _navigateToCentralHub(context); // this is handled in main.dart
        } else if (state is AuthPasswordResetSent) {
          _showSuccessSnackBar(context, 'Password reset email sent to ${state.email}');
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppDesignSystem.getResponsivePadding(context)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDesignSystem.spacing32),
              _buildHeader(context),
              const SizedBox(height: AppDesignSystem.spacing48),
              _buildLoginCard(context),
              const SizedBox(height: AppDesignSystem.spacing32),
              _buildSignUpSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        // Demo Mode Indicator and Return to Production button
        BlocBuilder<EnvCubit, Env>(
          builder: (context, env) {
            if (env == Env.sandbox) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: AppDesignSystem.spacing12),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDesignSystem.spacing12,
                      horizontal: AppDesignSystem.spacing16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: AppDesignSystem.iconMedium,
                        ),
                        const SizedBox(width: AppDesignSystem.spacing8),
                        Text(
                          'DEMO MODE',
                          style: AppTextStyles.heading3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDesignSystem.spacing16),
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await context.read<EnvCubit>().setEnv(Env.prod);
                      },
                      icon: const Icon(Icons.swap_horiz, size: 20),
                      label: const Text('Return to production env'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange.shade700,
                        side: BorderSide(color: Colors.orange.shade400),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDesignSystem.spacing12,
                          horizontal: AppDesignSystem.spacing16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const LogoWidget(),
        const SizedBox(height: AppDesignSystem.spacing24),
        Text(
          'Sign in to your account',
          style: AppTextStyles.heading2.copyWith(
            color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDesignSystem.spacing8),
        Text(
          'Welcome back! Please enter your details to continue.',
          style: AppTextStyles.body.copyWith(
            color: isDark ? AppDesignSystem.onSurfaceDarkSecondary : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing24),
      decoration: BoxDecoration(
        color: isDark ? AppDesignSystem.surfaceDarkSecondary : AppDesignSystem.surface,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        boxShadow: isDark ? AppDesignSystem.shadowMediumDark : AppDesignSystem.shadowMedium,
        border: isDark ? Border.all(color: AppDesignSystem.onSurfaceDarkTertiary.withOpacity(0.3)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmailField(controller: _emailController),
          const SizedBox(height: AppDesignSystem.spacing16),
          _PasswordField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: AppDesignSystem.spacing12),
          _ForgotPasswordButton(onPressed: () => _onForgotPasswordPressed(context)),
          const SizedBox(height: AppDesignSystem.spacing24),
          _LoginButton(onPressed: () => _onLoginPressed(context)),
        ],
      ),
    );
  }

  Widget _buildSignUpSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing20),
      decoration: BoxDecoration(
        color: isDark ? AppDesignSystem.surfaceDarkSecondary : AppDesignSystem.surface,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
        border: Border.all(
          color: isDark ? AppDesignSystem.onSurfaceDarkTertiary : Colors.grey.shade200,
        ),
        boxShadow: isDark ? AppDesignSystem.shadowSmallDark : AppDesignSystem.shadowSmall,
      ),
      child: Column(
        children: [
          Text(
            "Don't have an account?",
            style: AppTextStyles.body.copyWith(
              color: isDark ? AppDesignSystem.onSurfaceDarkSecondary : AppDesignSystem.onSurface,
            ),
          ),
          const SizedBox(height: AppDesignSystem.spacing8),
          _SignUpButton(),
          const SizedBox(height: AppDesignSystem.spacing12),
          _AboutUsButton(),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: AppDesignSystem.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
      ),
    );
  }

  void _navigateToCentralHub(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/central_hub',
      (route) => false,
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email address';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email address',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: AppDesignSystem.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
          borderSide: BorderSide(color: AppDesignSystem.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
          borderSide: BorderSide(color: AppDesignSystem.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
          borderSide: BorderSide(color: AppDesignSystem.error, width: 2),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const _PasswordField({
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: AppDesignSystem.primary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppDesignSystem.primary,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
          borderSide: BorderSide(color: AppDesignSystem.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
          borderSide: BorderSide(color: AppDesignSystem.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
          borderSide: BorderSide(color: AppDesignSystem.error, width: 2),
        ),
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ForgotPasswordButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: Text(
          'Forgot Password?',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppDesignSystem.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final primaryColor = isDark ? AppDesignSystem.primaryDark : AppDesignSystem.primary;
        
        return Container(
          height: AppDesignSystem.buttonHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
            gradient: LinearGradient(
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: isDark ? AppDesignSystem.shadowSmallDark : AppDesignSystem.shadowSmall,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              ),
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: AppDesignSystem.iconSmall,
                        height: AppDesignSystem.iconSmall,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDesignSystem.spacing8),
                      Text(
                        'Signing in...',
                        style: AppTextStyles.button.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: AppDesignSystem.iconSmall,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(width: AppDesignSystem.spacing8),
                      Text(
                        'Sign In',
                        style: AppTextStyles.button.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? AppDesignSystem.primaryDark : AppDesignSystem.primary;
    
    return Container(
      height: AppDesignSystem.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        border: Border.all(color: primaryColor, width: 2),
        boxShadow: isDark ? AppDesignSystem.shadowSmallDark : AppDesignSystem.shadowSmall,
      ),
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_rounded,
              size: AppDesignSystem.iconSmall,
              color: primaryColor,
            ),
            const SizedBox(width: AppDesignSystem.spacing8),
            Text(
              'Create Account',
              style: AppTextStyles.button.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutUsButton extends StatelessWidget {
  const _AboutUsButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/about_us');
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Text(
        'About Us',
        style: AppTextStyles.bodySmall.copyWith(
          color: isDark ? AppDesignSystem.onSurfaceDarkSecondary : Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}