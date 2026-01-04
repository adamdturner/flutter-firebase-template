
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/envdb.dart';

// ─────────────────────────────────────────────────────────────
//   Database Access Utility
// ─────────────────────────────────────────────────────────────

/// Centralized function to get the correct FirebaseFirestore instance
/// based on the current environment and provided parameters.
/// 
/// This ensures all repositories and services use the correct database
/// (sandbox or production) consistently throughout the app.
/// 
/// Priority order:
/// 1. Explicitly provided firestore instance
/// 2. Database from provided EnvDb instance
/// 3. Default FirebaseFirestore.instance (production)
/// 
/// Usage in repositories:
/// ```dart
/// class MyRepository {
///   final FirebaseFirestore _firestore;
///   
///   MyRepository({
///     EnvDb? envDb,
///     FirebaseFirestore? firestore,
///   }) : _firestore = getDatabaseInstance(envDb: envDb, firestore: firestore);
/// }
/// ```
FirebaseFirestore getDatabaseInstance({
  EnvDb? envDb,
  FirebaseFirestore? firestore,
}) {
  return firestore ?? envDb?.db ?? FirebaseFirestore.instance;
}


