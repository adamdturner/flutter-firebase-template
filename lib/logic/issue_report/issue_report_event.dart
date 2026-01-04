import 'package:flutter_firebase_template/data/models/issue_report_model.dart';

abstract class IssueReportEvent {}

/// Event to submit a new issue report
class SubmitIssueReportRequested extends IssueReportEvent {
  final IssueReport issueReport;

  SubmitIssueReportRequested({required this.issueReport});
}

/// Event to fetch user's issue reports
class FetchUserIssueReportsRequested extends IssueReportEvent {
  final String userId;

  FetchUserIssueReportsRequested({required this.userId});
}

/// Event to fetch all issue reports (admin only)
class FetchAllIssueReportsRequested extends IssueReportEvent {
  final String? severityFilter;
  final String? statusFilter;
  final int limit;

  FetchAllIssueReportsRequested({
    this.severityFilter,
    this.statusFilter,
    this.limit = 50,
  });
}

/// Event to update issue status (admin only)
class UpdateIssueStatusRequested extends IssueReportEvent {
  final String issueId;
  final String status;
  final String? resolvedBy;
  final String? resolutionNotes;

  UpdateIssueStatusRequested({
    required this.issueId,
    required this.status,
    this.resolvedBy,
    this.resolutionNotes,
  });
}

/// Event to reset the issue report state
class ResetIssueReportState extends IssueReportEvent {}

