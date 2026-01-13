import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_event.dart';
import 'package:flutter_firebase_template/logic/issue_report/issue_report_state.dart';
import 'package:flutter_firebase_template/data/repositories/issue_report_repository.dart';

class IssueReportBloc extends Bloc<IssueReportEvent, IssueReportState> {
  final IssueReportRepository issueReportRepository;

  IssueReportBloc({required this.issueReportRepository})
      : super(IssueReportInitial()) {
    
    // Handle submit issue report
    on<SubmitIssueReportRequested>((event, emit) async {
      emit(IssueReportSubmitting());
      try {
        final issueId = await issueReportRepository.submitIssueReport(event.issueReport);
        emit(IssueReportSubmitted(issueId: issueId));
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ Issue Report BLoC Error: failed to submit issue report - $e');
        }
        emit(IssueReportSubmissionFailure(error: 'Issue Report BLoC Error: failed to submit issue report - ${e.toString()}'));
      }
    });

    // Handle fetch user issue reports
    on<FetchUserIssueReportsRequested>((event, emit) async {
      emit(IssueReportsLoading());
      try {
        final issueReports = await issueReportRepository.fetchUserIssueReports(event.userId);
        emit(IssueReportsLoaded(issueReports: issueReports));
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ Issue Report BLoC Error: failed to fetch user issue reports - $e');
        }
        emit(IssueReportsLoadFailure(error: 'Issue Report BLoC Error: failed to fetch user issue reports - ${e.toString()}'));
      }
    });

    // Handle fetch all issue reports (admin)
    on<FetchAllIssueReportsRequested>((event, emit) async {
      emit(IssueReportsLoading());
      try {
        final issueReports = await issueReportRepository.fetchAllIssueReports(
          severityFilter: event.severityFilter,
          statusFilter: event.statusFilter,
          limit: event.limit,
        );
        emit(IssueReportsLoaded(issueReports: issueReports));
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ Issue Report BLoC Error: failed to fetch all issue reports - $e');
        }
        emit(IssueReportsLoadFailure(error: 'Issue Report BLoC Error: failed to fetch all issue reports - ${e.toString()}'));
      }
    });

    // Handle update issue status (admin)
    on<UpdateIssueStatusRequested>((event, emit) async {
      emit(IssueStatusUpdating());
      try {
        await issueReportRepository.updateIssueStatus(
          issueId: event.issueId,
          status: event.status,
          resolvedBy: event.resolvedBy,
          resolutionNotes: event.resolutionNotes,
        );
        emit(IssueStatusUpdated());
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ Issue Report BLoC Error: failed to update issue status - $e');
        }
        emit(IssueStatusUpdateFailure(error: 'Issue Report BLoC Error: failed to update issue status - ${e.toString()}'));
      }
    });

    // Handle reset state
    on<ResetIssueReportState>((event, emit) {
      emit(IssueReportInitial());
    });
  }
}

