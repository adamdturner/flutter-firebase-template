import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/data/models/user_model.dart';
import 'package:flutter_firebase_template/presentation/widgets/common/generic_icon_widget.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';
import '/logic/auth/auth_bloc.dart';
import '/logic/auth/auth_event.dart';
import '/logic/auth/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _onSignupPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First name and last name are required')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final userModel = UserModel(
      uid: '',
      email: email,
      role: 'user',
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
    );

    context.read<AuthBloc>().add(
      AuthSignUpRequested(
        password: password,
        user: userModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'User Sign Up', showBackButton: false),
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppDesignSystem.getResponsivePadding(context)),
        child: Column(
          children: [
            const SizedBox(height: AppDesignSystem.spacing32),
            _buildHeader(context),
            const SizedBox(height: AppDesignSystem.spacing32),
            _buildSignupForm(context),
            const SizedBox(height: AppDesignSystem.spacing32),
            _buildLoginSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        const IconWidget(),
        const SizedBox(height: AppDesignSystem.spacing24),
        Text(
          'Create Your Account',
          style: AppTextStyles.heading2.copyWith(
            color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDesignSystem.spacing8),
        Text(
          'Create your account to get started.',
          style: AppTextStyles.body.copyWith(
            color: isDark ? AppDesignSystem.onSurfaceDarkSecondary : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? AppDesignSystem.primaryDark : AppDesignSystem.primary;
    
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing24),
      decoration: BoxDecoration(
        color: isDark ? AppDesignSystem.surfaceDarkSecondary : AppDesignSystem.surface,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        boxShadow: isDark ? AppDesignSystem.shadowMediumDark : AppDesignSystem.shadowMedium,
        border: isDark ? Border.all(color: AppDesignSystem.onSurfaceDarkTertiary.withOpacity(0.3)) : null,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Required fields
            TextFormField(
              controller: _firstNameController,
              textInputAction: TextInputAction.next,
              validator: (value) => value?.trim().isEmpty == true ? 'First name is required' : null,
              decoration: InputDecoration(
                labelText: 'First Name',
                hintText: 'Enter your first name',
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
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
            ),
            const SizedBox(height: AppDesignSystem.spacing16),
            TextFormField(
              controller: _lastNameController,
              textInputAction: TextInputAction.next,
              validator: (value) => value?.trim().isEmpty == true ? 'Last name is required' : null,
              decoration: InputDecoration(
                labelText: 'Last Name',
                hintText: 'Enter your last name',
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
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
            ),
            const SizedBox(height: AppDesignSystem.spacing16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value?.trim().isEmpty == true) return 'Email is required';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                  return 'Please enter a valid email';
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
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  borderSide: BorderSide(color: AppDesignSystem.error, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  borderSide: BorderSide(color: AppDesignSystem.error, width: 2),
                ),
              ),
            ),
            const SizedBox(height: AppDesignSystem.spacing16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value?.trim().isEmpty == true) return 'Password is required';
                if (value!.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
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
            ),
            const SizedBox(height: AppDesignSystem.spacing16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value?.trim().isEmpty == true) return 'Please confirm your password';
                if (value != _passwordController.text) return 'Passwords do not match';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm your password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
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
            ),
            const SizedBox(height: AppDesignSystem.spacing16),
            
            // Optional fields
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number (optional)',
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
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
            ),
            const SizedBox(height: AppDesignSystem.spacing32),
            
            // Signup button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const AppLoadingWidget(
                    message: 'Creating account...',
                    isFullScreen: false,
                  );
                }
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
                    onPressed: () => _onSignupPressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? AppDesignSystem.primaryDark : AppDesignSystem.primary;
    
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
            "Already have an account?",
            style: AppTextStyles.body.copyWith(
              color: isDark ? AppDesignSystem.onSurfaceDarkSecondary : AppDesignSystem.onSurface,
            ),
          ),
          const SizedBox(height: AppDesignSystem.spacing8),
          Container(
            height: AppDesignSystem.buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              border: Border.all(color: primaryColor, width: 2),
              boxShadow: isDark ? AppDesignSystem.shadowSmallDark : AppDesignSystem.shadowSmall,
            ),
            child: OutlinedButton(
              onPressed: () {
                // Try to pop first, but if we can't (deep link scenario), 
                // fall back to replacing the route
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, '/login');
                }
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
                    Icons.login_rounded,
                    size: AppDesignSystem.iconSmall,
                    color: primaryColor,
                  ),
                  const SizedBox(width: AppDesignSystem.spacing8),
                  Text(
                    'Return to Login',
                    style: AppTextStyles.button.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }  
}
