import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_bloc.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_event.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_state.dart';
import 'package:flutter_firebase_template/logic/user/user_bloc.dart';
import 'package:flutter_firebase_template/logic/user/user_state.dart';
import 'package:flutter_firebase_template/data/models/issue_report_model.dart';
import 'package:flutter_firebase_template/data/services/image_upload_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final ImageUploadService _imageUploadService = ImageUploadService();
  
  String _selectedSeverity = 'non_critical';
  bool _isUploadingImages = false;
  String? _uploadProgress;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = source == ImageSource.gallery
          ? await _imageUploadService.pickImageFromGallery()
          : await _imageUploadService.pickImageFromCamera();

      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: AppDesignSystem.error,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    // On web, only show gallery option (camera doesn't work on web)
    if (kIsWeb) {
      _pickImage(ImageSource.gallery);
      return;
    }

    // On mobile, show both options
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitIssue() async {
    if (_formKey.currentState!.validate()) {
      // Get current user info
      final userState = context.read<UserBloc>().state;
      if (userState is! UserLoaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to get user information. Please try again.'),
            backgroundColor: AppDesignSystem.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final user = userState.user;

      // Upload images first if any are selected
      List<String> screenshotUrls = [];
      
      if (_selectedImages.isNotEmpty) {
        setState(() {
          _isUploadingImages = true;
          _uploadProgress = 'Uploading images...';
        });

        try {
          // Generate a temporary issue ID for storage path
          final tempIssueId = DateTime.now().millisecondsSinceEpoch.toString();

          screenshotUrls = await _imageUploadService.uploadMultipleScreenshots(
            images: _selectedImages,
            userId: user.uid,
            issueId: tempIssueId,
            onProgress: (current, total) {
              if (mounted) {
                setState(() {
                  _uploadProgress = 'Uploading image $current of $total...';
                });
              }
            },
          );
        } catch (e) {
          if (mounted) {
            setState(() {
              _isUploadingImages = false;
              _uploadProgress = null;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to upload images: ${e.toString()}'),
                backgroundColor: AppDesignSystem.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        } finally {
          if (mounted) {
            setState(() {
              _isUploadingImages = false;
              _uploadProgress = null;
            });
          }
        }
      }

      // Create issue report model
      final issueReport = IssueReport(
        issueId: '', // Will be set by repository
        userId: user.uid,
        userEmail: user.email,
        userRole: user.role,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        severity: _selectedSeverity,
        screenshots: screenshotUrls,
        createdAt: DateTime.now(),
        platform: Theme.of(context).platform.toString(),
      );

      // Submit via BLoC
      context.read<IssueReportBloc>().add(
        SubmitIssueReportRequested(issueReport: issueReport),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<IssueReportBloc, IssueReportState>(
      listener: (context, state) {
        if (state is IssueReportSubmitted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Issue reported successfully! We\'ll look into it.'),
              backgroundColor: AppDesignSystem.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Navigate back
          Navigator.of(context).pop();
        } else if (state is IssueReportSubmissionFailure) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit issue: ${state.error}'),
              backgroundColor: AppDesignSystem.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Report Issue',
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? AppDesignSystem.surfaceDarkSecondary 
            : AppDesignSystem.surface,
        body: SafeArea(
          child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppDesignSystem.spacing24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header info
                    Container(
                      padding: const EdgeInsets.all(AppDesignSystem.spacing16),
                      decoration: BoxDecoration(
                        color: AppDesignSystem.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                        border: Border.all(
                          color: AppDesignSystem.info.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppDesignSystem.info,
                            size: AppDesignSystem.iconMedium,
                          ),
                          const SizedBox(width: AppDesignSystem.spacing12),
                          Expanded(
                            child: Text(
                              'Help us improve the app by reporting any issues you encounter.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDesignSystem.spacing32),

                    // Issue Title
                    AppFormField(
                      label: 'Issue Title',
                      hint: 'Brief description of the issue',
                      controller: _titleController,
                      required: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an issue title';
                        }
                        if (value.trim().length < 3) {
                          return 'Title must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDesignSystem.spacing24),

                    // Description
                    AppFormField(
                      label: 'Description',
                      hint: 'Provide detailed information about the issue...',
                      controller: _descriptionController,
                      maxLines: 6,
                      required: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please provide a description';
                        }
                        if (value.trim().length < 10) {
                          return 'Description must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDesignSystem.spacing24),

                    // Severity Rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Severity Rating',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                            children: const [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: AppDesignSystem.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDesignSystem.spacing12),
                        
                        // Critical option
                        _buildSeverityOption(
                          value: 'critical',
                          title: 'Critical',
                          description: 'App is broken or unusable',
                          icon: Icons.error,
                          color: AppDesignSystem.error,
                        ),
                        const SizedBox(height: AppDesignSystem.spacing12),
                        
                        // Non-critical option
                        _buildSeverityOption(
                          value: 'non_critical',
                          title: 'Non-Critical',
                          description: 'Minor issue, typo, or improvement suggestion',
                          icon: Icons.info,
                          color: AppDesignSystem.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDesignSystem.spacing32),

                    // Screenshots Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Screenshots',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: AppDesignSystem.spacing8),
                            Text(
                              '(Optional)',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDesignSystem.spacing8),
                        Text(
                          'Add screenshots showing the issue',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: AppDesignSystem.spacing16),
                        
                        // Screenshot preview grid
                        if (_selectedImages.isEmpty)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(AppDesignSystem.spacing32),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 48,
                                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                  const SizedBox(height: AppDesignSystem.spacing8),
                                  Text(
                                    'No screenshots added yet',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: AppDesignSystem.spacing8,
                              mainAxisSpacing: AppDesignSystem.spacing8,
                            ),
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              final image = _selectedImages[index];
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
                                    child: kIsWeb
                                        ? Image.network(
                                            image.path,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(image.path),
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppDesignSystem.error,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        
                        const SizedBox(height: AppDesignSystem.spacing16),
                        
                        // Add screenshot button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _showImageSourceDialog,
                            icon: const Icon(Icons.add_photo_alternate_outlined),
                            label: const Text('Add Screenshot'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppDesignSystem.primary,
                              side: const BorderSide(color: AppDesignSystem.primary),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDesignSystem.spacing12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDesignSystem.spacing40),

                    // Submit Button
                    BlocBuilder<IssueReportBloc, IssueReportState>(
                      builder: (context, state) {
                        final isSubmitting = state is IssueReportSubmitting || _isUploadingImages;
                        
                        return Column(
                          children: [
                            if (_uploadProgress != null) ...[
                              Text(
                                _uploadProgress!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppDesignSystem.primary,
                                ),
                              ),
                              const SizedBox(height: AppDesignSystem.spacing8),
                            ],
                            SizedBox(
                              width: double.infinity,
                              height: AppDesignSystem.buttonHeight,
                              child: ElevatedButton(
                                onPressed: isSubmitting ? null : _submitIssue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppDesignSystem.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                                  ),
                                  elevation: 0,
                                ),
                                child: isSubmitting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'Submit Issue',
                                        style: AppTextStyles.button.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppDesignSystem.spacing24),
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

  Widget _buildSeverityOption({
    required String value,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedSeverity == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSeverity = value;
        });
      },
      borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
      child: Container(
        padding: const EdgeInsets.all(AppDesignSystem.spacing16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
          border: Border.all(
            color: isSelected
                ? color
                : theme.colorScheme.onSurface.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spacing8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
              ),
              child: Icon(
                icon,
                color: color,
                size: AppDesignSystem.iconMedium,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppDesignSystem.spacing4),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: AppDesignSystem.iconMedium,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                size: AppDesignSystem.iconMedium,
              ),
          ],
        ),
      ),
    );
  }
}

