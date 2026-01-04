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
        emit(IssueReportSubmissionFailure(error: e.toString()));
      }
    });

    // Handle fetch user issue reports
    on<FetchUserIssueReportsRequested>((event, emit) async {
      emit(IssueReportsLoading());
      try {
        final issueReports = await issueReportRepository.fetchUserIssueReports(event.userId);
        emit(IssueReportsLoaded(issueReports: issueReports));
      } catch (e) {
        emit(IssueReportsLoadFailure(error: e.toString()));
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
        emit(IssueReportsLoadFailure(error: e.toString()));
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
        emit(IssueStatusUpdateFailure(error: e.toString()));
      }
    });

    // Handle reset state
    on<ResetIssueReportState>((event, emit) {
      emit(IssueReportInitial());
    });
  }
}

