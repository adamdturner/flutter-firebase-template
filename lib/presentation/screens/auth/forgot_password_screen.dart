import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/logic/auth/auth_bloc.dart';
import 'package:flutter_firebase_template/logic/auth/auth_event.dart';
import 'package:flutter_firebase_template/logic/auth/auth_state.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// Screen for password reset functionality.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Handles password reset request.
  void _onResetPasswordPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      context.read<AuthBloc>().add(AuthForgotPasswordRequested(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset email sent to ${state.email}'),
              backgroundColor: AppDesignSystem.success,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppDesignSystem.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Reset Password'),
        backgroundColor: isDark 
            ? AppDesignSystem.surfaceDarkSecondary 
            : AppDesignSystem.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDesignSystem.getResponsivePadding(context)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppDesignSystem.spacing32),
                  _buildHeader(context),
                  const SizedBox(height: AppDesignSystem.spacing32),
                  _buildResetCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the header section with icon and instructions.
  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDesignSystem.spacing24),
          decoration: BoxDecoration(
            color: AppDesignSystem.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            size: AppDesignSystem.iconXLarge,
            color: AppDesignSystem.primary,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spacing24),
        Text(
          'Forgot Your Password?',
          style: AppTextStyles.heading2.copyWith(
            color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDesignSystem.spacing8),
        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: AppTextStyles.body.copyWith(
            color: isDark ? AppDesignSystem.onSurfaceDarkSecondary : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the card containing the email input and reset button.
  Widget _buildResetCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppDesignSystem.primaryDark : AppDesignSystem.primary;
    
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
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
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
                color: primaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: AppDesignSystem.spacing24),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              
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
                  onPressed: isLoading ? null : _onResetPasswordPressed,
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
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: AppDesignSystem.spacing8),
                            Text(
                              'Sending...',
                              style: AppTextStyles.button.copyWith(color: Colors.white),
                            ),
                          ],
                        )
                      : Text(
                          'Send Reset Link',
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: AppDesignSystem.spacing16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Back to Login',
              style: AppTextStyles.button.copyWith(
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

