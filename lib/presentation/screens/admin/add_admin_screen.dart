import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/data/models/user_model.dart';
import 'package:flutter_firebase_template/logic/admin/admin_bloc.dart';
import 'package:flutter_firebase_template/logic/admin/admin_event.dart';
import 'package:flutter_firebase_template/logic/admin/admin_state.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({super.key});

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(FetchAdminsRequested());
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Handles adding a user as admin via bloc.
  void _onAddAdminPressed() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an email address'),
          backgroundColor: AppDesignSystem.error,
        ),
      );
      return;
    }
    context.read<AdminBloc>().add(AddAdminRequested(email: email));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Admin',
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppDesignSystem.surfaceDarkSecondary
          : AppDesignSystem.surface,
      body: SafeArea(
        child: BlocConsumer<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state is AdminAdded) {
              _emailController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully added ${state.email} as admin!'),
                  backgroundColor: AppDesignSystem.success,
                ),
              );
            } else if (state is AddAdminFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppDesignSystem.error,
                ),
              );
            } else if (state is AdminsLoadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppDesignSystem.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AdminsLoading;
            final isAdding = state is AddingAdmin;
            final admins = _getAdminsFromState(state);

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppDesignSystem.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Add Admin Section
                  _buildAddAdminCard(
                    isDark: isDark,
                    isAdding: isAdding,
                  ),

                  SizedBox(height: AppDesignSystem.spacing16),

                  // Current Admins Section
                  _buildAdminsListCard(
                    isDark: isDark,
                    isLoading: isLoading,
                    admins: admins,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Extracts admin list from the current state.
  List<UserModel> _getAdminsFromState(AdminState state) {
    if (state is AdminsLoaded) return state.admins;
    if (state is AdminAdded) return state.admins;
    if (state is AddingAdmin) return state.admins;
    if (state is AddAdminFailure) return state.admins;
    return [];
  }

  /// Builds the card for adding a new admin.
  Widget _buildAddAdminCard({
    required bool isDark,
    required bool isAdding,
  }) {
    return Card(
      elevation: 2,
      shadowColor:
          isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
      color: isDark
          ? AppDesignSystem.surfaceDarkSecondary
          : AppDesignSystem.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDesignSystem.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add User as Admin',
              style: AppTextStyles.heading3.copyWith(
                color: isDark
                    ? AppDesignSystem.onSurfaceDark
                    : AppDesignSystem.onSurface,
              ),
            ),
            SizedBox(height: AppDesignSystem.spacing16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'User Email',
                hintText: 'Enter the email of the user to make admin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                ),
                filled: true,
                fillColor: isDark
                    ? AppDesignSystem.surfaceDarkTertiary
                    : Colors.grey.shade100,
                labelStyle: TextStyle(
                  color: isDark
                      ? AppDesignSystem.onSurfaceDarkSecondary
                      : Colors.grey.shade600,
                ),
                hintStyle: TextStyle(
                  color: isDark
                      ? AppDesignSystem.onSurfaceDarkTertiary
                      : Colors.grey.shade500,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: isDark
                    ? AppDesignSystem.onSurfaceDark
                    : AppDesignSystem.onSurface,
              ),
            ),
            SizedBox(height: AppDesignSystem.spacing16),
            SizedBox(
              width: double.infinity,
              height: AppDesignSystem.buttonHeight,
              child: ElevatedButton(
                onPressed: isAdding ? null : _onAddAdminPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppDesignSystem.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                  ),
                  elevation: 2,
                ),
                child: isAdding
                    ? SizedBox(
                        width: AppDesignSystem.iconMedium,
                        height: AppDesignSystem.iconMedium,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Add as Admin',
                        style: AppTextStyles.button.copyWith(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the card showing the list of current admins.
  Widget _buildAdminsListCard({
    required bool isDark,
    required bool isLoading,
    required List<UserModel> admins,
  }) {
    return Card(
      elevation: 2,
      shadowColor:
          isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
      color: isDark
          ? AppDesignSystem.surfaceDarkSecondary
          : AppDesignSystem.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDesignSystem.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Admins (${admins.length})',
                  style: AppTextStyles.heading3.copyWith(
                    color: isDark
                        ? AppDesignSystem.onSurfaceDark
                        : AppDesignSystem.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      context.read<AdminBloc>().add(FetchAdminsRequested()),
                  icon: Icon(
                    Icons.refresh,
                    color: isDark
                        ? AppDesignSystem.onSurfaceDark
                        : AppDesignSystem.onSurface,
                    size: AppDesignSystem.iconMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDesignSystem.spacing16),
            if (isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDesignSystem.spacing32),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppDesignSystem.primary,
                    ),
                  ),
                ),
              )
            else if (admins.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDesignSystem.spacing32),
                  child: Text(
                    'No admins found',
                    style: AppTextStyles.body.copyWith(
                      color: isDark
                          ? AppDesignSystem.onSurfaceDarkSecondary
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              )
            else
              ...admins.map((admin) {
                return ListItemTile(
                  title: admin.displayTitle,
                  subtitle: admin.email,
                  leading: CircleAvatar(
                    backgroundColor: AppDesignSystem.primary,
                    radius: AppDesignSystem.avatarSize / 2,
                    child: Text(
                      admin.firstName.isNotEmpty
                          ? admin.firstName[0].toUpperCase()
                          : admin.email[0].toUpperCase(),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  trailing: Chip(
                    label: Text(
                      admin.role.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppDesignSystem.warning,
                      ),
                    ),
                    backgroundColor: AppDesignSystem.warning.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDesignSystem.radiusFull),
                    ),
                  ),
                  backgroundColor: isDark
                      ? AppDesignSystem.surfaceDarkTertiary
                      : Colors.grey.shade100,
                );
              }),
          ],
        ),
      ),
    );
  }
}
