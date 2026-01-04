import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/data/models/user_model.dart';
import 'package:flutter_firebase_template/data/services/add_admin_service.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({super.key});

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final _emailController = TextEditingController();
  final _addAdminService = AddAdminService();
  bool _isLoading = false;
  List<UserModel> _allAdmins = [];
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadAdmins();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadAdmins() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final admins = await _addAdminService.getAllAdmins();
      
      setState(() {
        _allAdmins = admins;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading admins: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addUserAsAdmin() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an email address';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await _addAdminService.addUserAsAdmin(email: email);
      
      setState(() {
        _successMessage = 'Successfully added $email as admin!';
        _emailController.clear();
        _isLoading = false;
      });
      
      // Reload admins to show updated admin list
      await _loadAdmins();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error adding user as admin: $e';
        _isLoading = false;
      });
    }
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
        child: SingleChildScrollView(
        padding: EdgeInsets.all(AppDesignSystem.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add Admin Section
            Card(
              elevation: 2,
              shadowColor: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
              color: isDark ? AppDesignSystem.surfaceDarkSecondary : AppDesignSystem.surface,
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
                        color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
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
                        fillColor: isDark ? AppDesignSystem.surfaceDarkTertiary : Colors.grey.shade100,
                        labelStyle: TextStyle(
                          color: isDark ? AppDesignSystem.onSurfaceDarkSecondary : Colors.grey.shade600,
                        ),
                        hintStyle: TextStyle(
                          color: isDark ? AppDesignSystem.onSurfaceDarkTertiary : Colors.grey.shade500,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
                      ),
                    ),
                    SizedBox(height: AppDesignSystem.spacing16),
                    SizedBox(
                      width: double.infinity,
                      height: AppDesignSystem.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _addUserAsAdmin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppDesignSystem.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: AppDesignSystem.iconMedium,
                                height: AppDesignSystem.iconMedium,
                                child: CircularProgressIndicator(
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
            ),
            
            SizedBox(height: AppDesignSystem.spacing16),
            
            // Messages
            if (_errorMessage != null)
              Card(
                elevation: 2,
                shadowColor: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
                color: AppDesignSystem.error.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppDesignSystem.spacing16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error,
                        color: AppDesignSystem.error,
                        size: AppDesignSystem.iconMedium,
                      ),
                      SizedBox(width: AppDesignSystem.spacing8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTextStyles.body.copyWith(
                            color: AppDesignSystem.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            if (_successMessage != null)
              Card(
                elevation: 2,
                shadowColor: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
                color: AppDesignSystem.success.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppDesignSystem.spacing16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppDesignSystem.success,
                        size: AppDesignSystem.iconMedium,
                      ),
                      SizedBox(width: AppDesignSystem.spacing8),
                      Expanded(
                        child: Text(
                          _successMessage!,
                          style: AppTextStyles.body.copyWith(
                            color: AppDesignSystem.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            SizedBox(height: AppDesignSystem.spacing16),
            
            // Current Admins Section
            Card(
              elevation: 2,
              shadowColor: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
              color: isDark ? AppDesignSystem.surfaceDarkSecondary : AppDesignSystem.surface,
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
                          'Current Admins (${_allAdmins.length})',
                          style: AppTextStyles.heading3.copyWith(
                            color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
                          ),
                        ),
                        IconButton(
                          onPressed: _loadAdmins,
                          icon: Icon(
                            Icons.refresh,
                            color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
                            size: AppDesignSystem.iconMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDesignSystem.spacing16),
                    if (_isLoading)
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
                    else if (_allAdmins.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppDesignSystem.spacing32),
                          child: Text(
                            'No admins found',
                            style: AppTextStyles.body.copyWith(
                              color: isDark ? AppDesignSystem.onSurfaceDarkSecondary : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._allAdmins.map((admin) {
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
                              borderRadius: BorderRadius.circular(AppDesignSystem.radiusFull),
                            ),
                          ),
                          backgroundColor: isDark ? AppDesignSystem.surfaceDarkTertiary : Colors.grey.shade100,
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
