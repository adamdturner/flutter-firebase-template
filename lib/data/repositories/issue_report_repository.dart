import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/data/models/issue_report_model.dart';
import 'package:flutter_firebase_template/data/repositories/repository_utils.dart';
import 'package:flutter_firebase_template/envdb.dart';

class IssueReportRepository {
  final FirebaseFirestore _firestore;

  IssueReportRepository({
    EnvDb? envDb,
    FirebaseFirestore? firestore,
  }) : _firestore = getDatabaseInstance(envDb: envDb, firestore: firestore);

  /// Submit a new issue report to Firestore
  Future<String> submitIssueReport(IssueReport issueReport) async {
    try {
      // Create a new document reference with auto-generated ID
      final docRef = _firestore.collection('issue-reports').doc();
      
      // Create the issue report with the generated ID
      final reportWithId = issueReport.copyWith(issueId: docRef.id);
      
      // Write to Firestore
      await docRef.set(reportWithId.toFirestoreMap());
      
      return docRef.id;
    } catch (e) {
      if (e.toString().contains('Issue Report Repository Error')) {
        rethrow;
      }
      throw Exception('Issue Report Repository Error: failed to submit issue report - ${e.toString()}');
    }
  }

  /// Fetch a single issue report by ID
  Future<IssueReport> fetchIssueReport(String issueId) async {
    try {
      final docSnapshot = await _firestore
          .collection('issue-reports')
          .doc(issueId)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('Issue Report Repository Error: issue report not found for ID: $issueId');
      }

      final data = docSnapshot.data()!;
      return IssueReport.fromMap(data, issueId: issueId);
    } catch (e) {
      if (e.toString().contains('Issue Report Repository Error')) {
        rethrow;
      }
      throw Exception('Issue Report Repository Error: failed to fetch issue report - ${e.toString()}');
    }
  }

  /// Fetch all issue reports for a specific user
  Future<List<IssueReport>> fetchUserIssueReports(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('issue-reports')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => IssueReport.fromMap(
                doc.data(),
                issueId: doc.id,
              ))
          .toList();
    } catch (e) {
      if (e.toString().contains('Issue Report Repository Error')) {
        rethrow;
      }
      throw Exception('Issue Report Repository Error: failed to fetch user issue reports - ${e.toString()}');
    }
  }

  /// Fetch all issue reports (admin only)
  Future<List<IssueReport>> fetchAllIssueReports({
    String? severityFilter,
    String? statusFilter,
    int limit = 50,
  }) async {
    try {
      Query query = _firestore
          .collection('issue-reports')
          .orderBy('createdAt', descending: true);

      if (severityFilter != null) {
        query = query.where('severity', isEqualTo: severityFilter);
      }

      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter);
      }

      query = query.limit(limit);

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => IssueReport.fromMap(
                doc.data() as Map<String, dynamic>,
                issueId: doc.id,
              ))
          .toList();
    } catch (e) {
      if (e.toString().contains('Issue Report Repository Error')) {
        rethrow;
      }
      throw Exception('Issue Report Repository Error: failed to fetch all issue reports - ${e.toString()}');
    }
  }

  /// Update issue report status (admin only)
  Future<void> updateIssueStatus({
    required String issueId,
    required String status,
    String? resolvedBy,
    String? resolutionNotes,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
      };

      if (status == 'resolved' || status == 'closed') {
        updateData['resolvedAt'] = Timestamp.now();
        if (resolvedBy != null) {
          updateData['resolvedBy'] = resolvedBy;
        }
        if (resolutionNotes != null) {
          updateData['resolutionNotes'] = resolutionNotes;
        }
      }

      await _firestore
          .collection('issue-reports')
          .doc(issueId)
          .update(updateData);
    } catch (e) {
      if (e.toString().contains('Issue Report Repository Error')) {
        rethrow;
      }
      throw Exception('Issue Report Repository Error: failed to update issue status - ${e.toString()}');
    }
  }

  /// Delete an issue report (admin only)
  Future<void> deleteIssueReport(String issueId) async {
    try {
      await _firestore.collection('issue-reports').doc(issueId).delete();
    } catch (e) {
      if (e.toString().contains('Issue Report Repository Error')) {
        rethrow;
      }
      throw Exception('Issue Report Repository Error: failed to delete issue report - ${e.toString()}');
    }
  }

  /// Stream of issue reports for real-time updates (admin dashboard)
  Stream<List<IssueReport>> streamIssueReports({
    String? severityFilter,
    String? statusFilter,
    int limit = 50,
  }) {
    try {
      Query query = _firestore
          .collection('issue-reports')
          .orderBy('createdAt', descending: true);

      if (severityFilter != null) {
        query = query.where('severity', isEqualTo: severityFilter);
      }

      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter);
      }

      query = query.limit(limit);

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => IssueReport.fromMap(
                  doc.data() as Map<String, dynamic>,
                  issueId: doc.id,
                ))
            .toList();
      });
    } catch (e) {
      throw Exception('Issue Report Repository Error: failed to stream issue reports - ${e.toString()}');
    }
  }
}

