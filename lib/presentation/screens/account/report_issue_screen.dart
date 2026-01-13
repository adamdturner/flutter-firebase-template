import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_bloc.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_event.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_state.dart';
import 'package:flutter_firebase_template/logic/user/user_bloc.dart';
import 'package:flutter_firebase_template/logic/user/user_state.dart';
import 'package:flutter_firebase_template/logic/image_picker/image_picker_cubit.dart';
import 'package:flutter_firebase_template/logic/image_picker/image_picker_state.dart';
import 'package:flutter_firebase_template/data/models/issue_report_model.dart';
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

  String _selectedSeverity = 'non_critical';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Shows the image source dialog or picks from gallery directly on web.
  void _showImageSourceDialog() {
    final cubit = context.read<ImagePickerCubit>();

    // On web, only show gallery option
    if (kIsWeb) {
      cubit.pickFromGallery();
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
                  cubit.pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Removes an image at the specified index.
  void _removeImage(int index) {
    context.read<ImagePickerCubit>().removeImage(index);
  }

  /// Submits the issue report.
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
      final imagePickerCubit = context.read<ImagePickerCubit>();
      List<String> screenshotUrls = [];

      if (imagePickerCubit.state.selectedImages.isNotEmpty) {
        try {
          final tempIssueId = DateTime.now().millisecondsSinceEpoch.toString();
          screenshotUrls = await imagePickerCubit.uploadImages(
            userId: user.uid,
            issueId: tempIssueId,
          );
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to upload images: ${e.toString()}'),
                backgroundColor: AppDesignSystem.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
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
      if (mounted) {
        context.read<IssueReportBloc>().add(
              SubmitIssueReportRequested(issueReport: issueReport),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<IssueReportBloc, IssueReportState>(
      listener: (context, state) {
        if (state is IssueReportSubmitted) {
          // Reset image picker on success
          context.read<ImagePickerCubit>().reset();
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Issue reported successfully! We\'ll look into it.'),
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
          child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
            builder: (context, imagePickerState) {
              final selectedImages = imagePickerState.selectedImages;
              final isUploadingImages = imagePickerState is ImagesUploading;
              final uploadProgress = imagePickerState is ImagesUploading
                  ? 'Uploading image ${imagePickerState.current} of ${imagePickerState.total}...'
                  : null;

              return Stack(
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
                            padding:
                                const EdgeInsets.all(AppDesignSystem.spacing16),
                            decoration: BoxDecoration(
                              color: AppDesignSystem.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                  AppDesignSystem.radius12),
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
                            hint:
                                'Provide detailed information about the issue...',
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
                                description:
                                    'Minor issue, typo, or improvement suggestion',
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
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDesignSystem.spacing8),
                              Text(
                                'Add screenshots showing the issue',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: AppDesignSystem.spacing16),

                              // Screenshot preview grid
                              if (selectedImages.isEmpty)
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                        AppDesignSystem.spacing32),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.2),
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppDesignSystem.radius12),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 48,
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.4),
                                        ),
                                        const SizedBox(
                                            height: AppDesignSystem.spacing8),
                                        Text(
                                          'No screenshots added yet',
                                          style:
                                              AppTextStyles.bodySmall.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.4),
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
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: AppDesignSystem.spacing8,
                                    mainAxisSpacing: AppDesignSystem.spacing8,
                                  ),
                                  itemCount: selectedImages.length,
                                  itemBuilder: (context, index) {
                                    final image = selectedImages[index];
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              AppDesignSystem.radius8),
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
                                  icon: const Icon(
                                      Icons.add_photo_alternate_outlined),
                                  label: const Text('Add Screenshot'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppDesignSystem.primary,
                                    side: const BorderSide(
                                        color: AppDesignSystem.primary),
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
                              final isSubmitting =
                                  state is IssueReportSubmitting ||
                                      isUploadingImages;

                              return Column(
                                children: [
                                  if (uploadProgress != null) ...[
                                    Text(
                                      uploadProgress,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppDesignSystem.primary,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: AppDesignSystem.spacing8),
                                  ],
                                  SizedBox(
                                    width: double.infinity,
                                    height: AppDesignSystem.buttonHeight,
                                    child: ElevatedButton(
                                      onPressed:
                                          isSubmitting ? null : _submitIssue,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppDesignSystem.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDesignSystem.radius12),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: isSubmitting
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'Submit Issue',
                                              style:
                                                  AppTextStyles.button.copyWith(
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
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds a severity option widget.
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
          color: isSelected ? color.withOpacity(0.1) : theme.colorScheme.surface,
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
