import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_bloc.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_event.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_state.dart';
import 'package:flutter_firebase_template/data/models/issue_report_model.dart';
import 'package:intl/intl.dart';

class AdminIssueReportsScreen extends StatefulWidget {
  const AdminIssueReportsScreen({super.key});

  @override
  State<AdminIssueReportsScreen> createState() => _AdminIssueReportsScreenState();
}

class _AdminIssueReportsScreenState extends State<AdminIssueReportsScreen> {
  String _selectedStatusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadIssueReports();
  }

  void _loadIssueReports() {
    final statusFilter = _selectedStatusFilter == 'all' ? null : _selectedStatusFilter;
    context.read<IssueReportBloc>().add(
      FetchAllIssueReportsRequested(
        statusFilter: statusFilter,
      ),
    );
  }

  void _onFilterChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedStatusFilter = value;
      });
      _loadIssueReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Issue Reports',
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppDesignSystem.surfaceDarkSecondary 
          : AppDesignSystem.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Filter section
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spacing16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    size: AppDesignSystem.iconMedium,
                  ),
                  const SizedBox(width: AppDesignSystem.spacing12),
                  Text(
                    'Status:',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppDesignSystem.spacing12),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedStatusFilter,
                      isExpanded: true,
                      underline: Container(),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All Issues')),
                        DropdownMenuItem(value: 'open', child: Text('Open')),
                        DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                        DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                        DropdownMenuItem(value: 'closed', child: Text('Closed')),
                      ],
                      onChanged: _onFilterChanged,
                    ),
                  ),
                ],
              ),
            ),

            // Issue reports list
            Expanded(
              child: BlocBuilder<IssueReportBloc, IssueReportState>(
                builder: (context, state) {
                  if (state is IssueReportsLoading) {
                    return const Center(
                      child: AppLoadingWidget(
                        message: 'Loading issue reports...',
                        isFullScreen: false,
                      ),
                    );
                  } else if (state is IssueReportsLoaded) {
                    final issues = state.issueReports;

                    if (issues.isEmpty) {
                      return EmptyStateWidget(
                        icon: Icons.bug_report_outlined,
                        title: 'No Issue Reports',
                        subtitle: _selectedStatusFilter == 'all'
                            ? 'No issue reports have been submitted yet.'
                            : 'No ${_selectedStatusFilter.replaceAll('_', ' ')} issues found.',
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        _loadIssueReports();
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppDesignSystem.spacing16),
                        itemCount: issues.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: AppDesignSystem.spacing12,
                        ),
                        itemBuilder: (context, index) {
                          final issue = issues[index];
                          return _buildIssueCard(context, issue);
                        },
                      ),
                    );
                  } else if (state is IssueReportsLoadFailure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDesignSystem.spacing24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: AppDesignSystem.iconXLarge,
                              color: AppDesignSystem.error,
                            ),
                            const SizedBox(height: AppDesignSystem.spacing16),
                            Text(
                              'Failed to load issues',
                              style: AppTextStyles.heading3,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppDesignSystem.spacing8),
                            Text(
                              state.error,
                              style: AppTextStyles.body,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppDesignSystem.spacing24),
                            ElevatedButton.icon(
                              onPressed: _loadIssueReports,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppDesignSystem.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueCard(BuildContext context, IssueReport issue) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/admin_issue_report_detail',
          arguments: issue,
        );
      },
      borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with severity and status
            Row(
              children: [
                // Severity badge
                _buildSeverityBadge(issue.severity),
                const SizedBox(width: AppDesignSystem.spacing8),
                // Status badge
                _buildStatusBadge(issue.status),
                const Spacer(),
                // Date
                Text(
                  _formatDate(issue.createdAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesignSystem.spacing12),
            
            // Title
            Text(
              issue.title,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDesignSystem.spacing8),
            
            // Description preview
            Text(
              issue.description,
              style: AppTextStyles.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDesignSystem.spacing12),
            
            // Footer with user info and screenshot count
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: AppDesignSystem.spacing4),
                Expanded(
                  child: Text(
                    '${issue.userEmail} (${issue.userRole})',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (issue.screenshots.isNotEmpty) ...[
                  const SizedBox(width: AppDesignSystem.spacing8),
                  Icon(
                    Icons.image_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: AppDesignSystem.spacing4),
                  Text(
                    '${issue.screenshots.length}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(String severity) {
    final isCritical = severity == 'critical';
    final color = isCritical ? AppDesignSystem.error : AppDesignSystem.warning;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing8,
        vertical: AppDesignSystem.spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesignSystem.radius4),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCritical ? Icons.error : Icons.info,
            size: 14,
            color: color,
          ),
          const SizedBox(width: AppDesignSystem.spacing4),
          Text(
            isCritical ? 'Critical' : 'Non-Critical',
            style: AppTextStyles.bodySmall.copyWith(
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
    
    switch (status) {
      case 'open':
        color = AppDesignSystem.info;
        label = 'Open';
        break;
      case 'in_progress':
        color = AppDesignSystem.warning;
        label = 'In Progress';
        break;
      case 'resolved':
        color = AppDesignSystem.success;
        label = 'Resolved';
        break;
      case 'closed':
        color = Colors.grey;
        label = 'Closed';
        break;
      default:
        color = Colors.grey;
        label = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing8,
        vertical: AppDesignSystem.spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesignSystem.radius4),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}

