import 'package:flutter/material.dart';

import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// Example screen showcasing text fields, validation, dropdown, switch, checkbox, and submit.
class FormFieldsExampleScreen extends StatefulWidget {
  const FormFieldsExampleScreen({super.key});

  @override
  State<FormFieldsExampleScreen> createState() => _FormFieldsExampleScreenState();
}

class _FormFieldsExampleScreenState extends State<FormFieldsExampleScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _multilineController;
  late final TextEditingController _searchController;

  String? _dropdownValue;
  bool _switchValue = false;
  bool _checkboxValue = false;

  static const List<String> _dropdownOptions = ['Option A', 'Option B', 'Option C'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _multilineController = TextEditingController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _multilineController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Form Fields Example',
        showBackButton: true,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppDesignSystem.surfaceDarkSecondary
          : AppDesignSystem.surface,
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  /// Scrollable form body with sectioned inputs.
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Basic inputs'),
            SizedBox(height: AppDesignSystem.spacing16),
            _buildBasicFields(context),
            SizedBox(height: AppDesignSystem.spacing24),
            _buildSectionHeader(context, 'Password & multiline'),
            SizedBox(height: AppDesignSystem.spacing16),
            _buildPasswordAndMultiline(context),
            SizedBox(height: AppDesignSystem.spacing24),
            _buildSectionHeader(context, 'Search'),
            SizedBox(height: AppDesignSystem.spacing16),
            _buildSearchField(context),
            SizedBox(height: AppDesignSystem.spacing24),
            _buildSectionHeader(context, 'Dropdown & toggles'),
            SizedBox(height: AppDesignSystem.spacing16),
            _buildDropdownAndToggles(context),
            SizedBox(height: AppDesignSystem.spacing32),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  /// Section title.
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.heading3,
    );
  }

  /// Name (required), email (validated), phone (optional).
  Widget _buildBasicFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFormField(
          label: 'Full name',
          hint: 'Enter your name',
          controller: _nameController,
          required: true,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
        ),
        SizedBox(height: AppDesignSystem.spacing16),
        AppFormFieldWithIcon(
          label: 'Email',
          hint: 'you@example.com',
          controller: _emailController,
          required: true,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Email is required';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: AppDesignSystem.spacing16),
        AppFormField(
          label: 'Phone',
          hint: 'Optional',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  /// Password (obscure, min length) and multiline.
  Widget _buildPasswordAndMultiline(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFormField(
          label: 'Password',
          hint: 'Min 6 characters',
          controller: _passwordController,
          required: true,
          obscureText: true,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Password is required';
            if (v.length < 6) return 'At least 6 characters';
            return null;
          },
        ),
        SizedBox(height: AppDesignSystem.spacing16),
        AppFormField(
          label: 'Notes',
          hint: 'Multiple lines...',
          controller: _multilineController,
          maxLines: 4,
          maxLength: 200,
        ),
      ],
    );
  }

  /// Search field.
  Widget _buildSearchField(BuildContext context) {
    return AppSearchField(
      hint: 'Search example',
      controller: _searchController,
      onChanged: (_) => setState(() {}),
    );
  }

  /// Dropdown, switch, checkbox.
  Widget _buildDropdownAndToggles(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdownField<String>(
          label: 'Choose option',
          value: _dropdownValue,
          required: true,
          hint: 'Select one',
          items: _dropdownOptions
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _dropdownValue = v),
          validator: (v) => v == null || v.isEmpty ? 'Select an option' : null,
        ),
        SizedBox(height: AppDesignSystem.spacing24),
        AppSwitchField(
          label: 'Enable feature',
          subtitle: 'Toggle this setting',
          value: _switchValue,
          onChanged: (v) => setState(() => _switchValue = v),
        ),
        SizedBox(height: AppDesignSystem.spacing8),
        AppCheckboxField(
          label: 'I agree to the terms',
          subtitle: 'Required to continue',
          value: _checkboxValue,
          onChanged: (v) => setState(() => _checkboxValue = v ?? false),
        ),
      ],
    );
  }

  /// Submit button; validates form and shows snackbar.
  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppNavigationButton.primary(
        text: 'Submit',
        icon: Icons.check,
        onPressed: () => _handleSubmit(context),
      ),
    );
  }

  /// Validates form and shows success or keeps focus on first error.
  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_checkboxValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to the terms')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Submitted: ${_nameController.text}, ${_emailController.text}, '
            'dropdown=$_dropdownValue, switch=$_switchValue',
          ),
        ),
      );
    }
  }
}
