import 'package:flutter_firebase_template/data/models/issue_report_model.dart';

abstract class IssueReportState {}

/// Initial state
class IssueReportInitial extends IssueReportState {}

/// State when submitting an issue report
class IssueReportSubmitting extends IssueReportState {}

/// State when issue report is submitted successfully
class IssueReportSubmitted extends IssueReportState {
  final String issueId;

  IssueReportSubmitted({required this.issueId});
}

/// State when issue report submission fails
class IssueReportSubmissionFailure extends IssueReportState {
  final String error;

  IssueReportSubmissionFailure({required this.error});
}

/// State when loading issue reports
class IssueReportsLoading extends IssueReportState {}

/// State when issue reports are loaded successfully
class IssueReportsLoaded extends IssueReportState {
  final List<IssueReport> issueReports;

  IssueReportsLoaded({required this.issueReports});
}

/// State when loading issue reports fails
class IssueReportsLoadFailure extends IssueReportState {
  final String error;

  IssueReportsLoadFailure({required this.error});
}

/// State when updating issue status
class IssueStatusUpdating extends IssueReportState {}

/// State when issue status is updated successfully
class IssueStatusUpdated extends IssueReportState {}

/// State when updating issue status fails
class IssueStatusUpdateFailure extends IssueReportState {
  final String error;

  IssueStatusUpdateFailure({required this.error});
}

