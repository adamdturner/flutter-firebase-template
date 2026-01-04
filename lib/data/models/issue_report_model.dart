import 'package:cloud_firestore/cloud_firestore.dart';

class IssueReport {
  final String issueId;
  final String userId;
  final String userEmail;
  final String userRole;
  final String title;
  final String description;
  final String severity; // 'critical' or 'non_critical'
  final List<String> screenshots;
  final DateTime createdAt;
  final String platform;
  final String status; // 'open', 'in_progress', 'resolved', 'closed'
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String? resolutionNotes;

  IssueReport({
    required this.issueId,
    required this.userId,
    required this.userEmail,
    required this.userRole,
    required this.title,
    required this.description,
    required this.severity,
    required this.screenshots,
    required this.createdAt,
    required this.platform,
    this.status = 'open',
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNotes,
  });

  /// Create IssueReport from Firestore document
  factory IssueReport.fromMap(Map<String, dynamic> data, {required String issueId}) {
    return IssueReport(
      issueId: issueId,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userRole: data['userRole'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      severity: data['severity'] ?? 'non_critical',
      screenshots: List<String>.from(data['screenshots'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      platform: data['platform'] ?? '',
      status: data['status'] ?? 'open',
      resolvedAt: data['resolvedAt'] != null
          ? (data['resolvedAt'] as Timestamp).toDate()
          : null,
      resolvedBy: data['resolvedBy'],
      resolutionNotes: data['resolutionNotes'],
    );
  }

  /// Convert IssueReport to Firestore map
  Map<String, dynamic> toFirestoreMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'userRole': userRole,
      'title': title,
      'description': description,
      'severity': severity,
      'screenshots': screenshots,
      'createdAt': Timestamp.fromDate(createdAt),
      'platform': platform,
      'status': status,
      if (resolvedAt != null) 'resolvedAt': Timestamp.fromDate(resolvedAt!),
      if (resolvedBy != null) 'resolvedBy': resolvedBy,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
    };
  }

  /// Create a copy of IssueReport with modified fields
  IssueReport copyWith({
    String? issueId,
    String? userId,
    String? userEmail,
    String? userRole,
    String? title,
    String? description,
    String? severity,
    List<String>? screenshots,
    DateTime? createdAt,
    String? platform,
    String? status,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
  }) {
    return IssueReport(
      issueId: issueId ?? this.issueId,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userRole: userRole ?? this.userRole,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      screenshots: screenshots ?? this.screenshots,
      createdAt: createdAt ?? this.createdAt,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }

  /// Get severity display name
  String get severityDisplayName {
    switch (severity) {
      case 'critical':
        return 'Critical';
      case 'non_critical':
        return 'Non-Critical';
      default:
        return severity;
    }
  }

  /// Check if issue is critical
  bool get isCritical => severity == 'critical';

  /// Check if issue is resolved
  bool get isResolved => status == 'resolved' || status == 'closed';
}

