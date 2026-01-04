import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/data/models/issue_report_model.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_bloc.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_event.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_state.dart';
import 'package:intl/intl.dart';

class AdminIssueReportDetailScreen extends StatefulWidget {
  final IssueReport issueReport;

  const AdminIssueReportDetailScreen({
    super.key,
    required this.issueReport,
  });

  @override
  State<AdminIssueReportDetailScreen> createState() => _AdminIssueReportDetailScreenState();
}

class _AdminIssueReportDetailScreenState extends State<AdminIssueReportDetailScreen> {
  late IssueReport _currentIssue;

  @override
  void initState() {
    super.initState();
    _currentIssue = widget.issueReport;
  }

  void _updateStatus(String newStatus) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Update Status',
            style: AppTextStyles.heading3,
          ),
          content: Text(
            'Change issue status to "${_formatStatus(newStatus)}"?',
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<IssueReportBloc>().add(
                  UpdateIssueStatusRequested(
                    issueId: _currentIssue.issueId,
                    status: newStatus,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesignSystem.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  String _formatStatus(String status) {
    return status.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<IssueReportBloc, IssueReportState>(
      listener: (context, state) {
        if (state is IssueStatusUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Issue status updated successfully'),
              backgroundColor: AppDesignSystem.success,
            ),
          );
          // Refresh the issue data
          Navigator.pop(context, true);
        } else if (state is IssueStatusUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update status: ${state.error}'),
              backgroundColor: AppDesignSystem.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Issue Details',
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? AppDesignSystem.surfaceDarkSecondary 
            : AppDesignSystem.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDesignSystem.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and severity badges
                Row(
                  children: [
                    _buildSeverityBadge(_currentIssue.severity),
                    const SizedBox(width: AppDesignSystem.spacing8),
                    _buildStatusBadge(_currentIssue.status),
                  ],
                ),
                const SizedBox(height: AppDesignSystem.spacing16),

                // Title
                Text(
                  _currentIssue.title,
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: AppDesignSystem.spacing24),

                // Issue info card
                _buildInfoCard(
                  theme,
                  [
                    _buildInfoRow('Reported by', _currentIssue.userEmail),
                    _buildInfoRow('User role', _currentIssue.userRole.toUpperCase()),
                    _buildInfoRow('Platform', _currentIssue.platform),
                    _buildInfoRow(
                      'Submitted',
                      DateFormat('MMM d, yyyy • h:mm a').format(_currentIssue.createdAt),
                    ),
                    if (_currentIssue.resolvedAt != null)
                      _buildInfoRow(
                        'Resolved',
                        DateFormat('MMM d, yyyy • h:mm a').format(_currentIssue.resolvedAt!),
                      ),
                  ],
                ),
                const SizedBox(height: AppDesignSystem.spacing24),

                // Description
                Text(
                  'Description',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: AppDesignSystem.spacing12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDesignSystem.spacing16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    _currentIssue.description,
                    style: AppTextStyles.body,
                  ),
                ),
                const SizedBox(height: AppDesignSystem.spacing24),

                // Screenshots
                if (_currentIssue.screenshots.isNotEmpty) ...[
                  Text(
                    'Screenshots (${_currentIssue.screenshots.length})',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppDesignSystem.spacing12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppDesignSystem.spacing12,
                      mainAxisSpacing: AppDesignSystem.spacing12,
                    ),
                    itemCount: _currentIssue.screenshots.length,
                    itemBuilder: (context, index) {
                      final imageUrl = _currentIssue.screenshots[index];
                      return GestureDetector(
                        onTap: () => _viewFullImage(context, imageUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              // Show detailed error for debugging
                              debugPrint('Image load error: $error');
                              debugPrint('Image URL: $imageUrl');
                              
                              return Container(
                                color: theme.colorScheme.surface,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.broken_image, 
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'CORS Error?\nSee console',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppDesignSystem.spacing24),
                ],

                // Resolution notes (if resolved)
                if (_currentIssue.resolutionNotes != null) ...[
                  Text(
                    'Resolution Notes',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppDesignSystem.spacing12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDesignSystem.spacing16),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
                      border: Border.all(
                        color: AppDesignSystem.success.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _currentIssue.resolutionNotes!,
                      style: AppTextStyles.body,
                    ),
                  ),
                  const SizedBox(height: AppDesignSystem.spacing24),
                ],

                // Action buttons
                Text(
                  'Actions',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: AppDesignSystem.spacing12),
                
                Wrap(
                  spacing: AppDesignSystem.spacing8,
                  runSpacing: AppDesignSystem.spacing8,
                  children: [
                    if (_currentIssue.status == 'open')
                      _buildActionButton(
                        'Mark In Progress',
                        Icons.pending_actions,
                        AppDesignSystem.warning,
                        () => _updateStatus('in_progress'),
                      ),
                    if (_currentIssue.status != 'resolved' && _currentIssue.status != 'closed')
                      _buildActionButton(
                        'Mark Resolved',
                        Icons.check_circle,
                        AppDesignSystem.success,
                        () => _updateStatus('resolved'),
                      ),
                    if (_currentIssue.status != 'closed')
                      _buildActionButton(
                        'Close Issue',
                        Icons.close,
                        Colors.grey,
                        () => _updateStatus('closed'),
                      ),
                  ],
                ),
                const SizedBox(height: AppDesignSystem.spacing40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
        ),
        boxShadow: AppDesignSystem.shadowSmall,
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(String severity) {
    final isCritical = severity == 'critical';
    final color = isCritical ? AppDesignSystem.error : AppDesignSystem.warning;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing12,
        vertical: AppDesignSystem.spacing8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCritical ? Icons.error : Icons.info,
            size: 20,
            color: color,
          ),
          const SizedBox(width: AppDesignSystem.spacing8),
          Text(
            isCritical ? 'Critical' : 'Non-Critical',
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    IconData icon;
    
    switch (status) {
      case 'open':
        color = AppDesignSystem.info;
        label = 'Open';
        icon = Icons.flag;
        break;
      case 'in_progress':
        color = AppDesignSystem.warning;
        label = 'In Progress';
        icon = Icons.pending_actions;
        break;
      case 'resolved':
        color = AppDesignSystem.success;
        label = 'Resolved';
        icon = Icons.check_circle;
        break;
      case 'closed':
        color = Colors.grey;
        label = 'Closed';
        icon = Icons.close;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.info;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing12,
        vertical: AppDesignSystem.spacing8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(width: AppDesignSystem.spacing8),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spacing16,
          vertical: AppDesignSystem.spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
        ),
      ),
    );
  }

  void _viewFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(imageUrl),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

