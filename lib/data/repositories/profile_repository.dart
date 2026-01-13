import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_template/data/models/user_model.dart';
import 'package:flutter_firebase_template/data/repositories/repository_utils.dart';
import 'package:flutter_firebase_template/envdb.dart';

/// Generic profile repository that handles profile editing for all user types
class ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository({
    EnvDb? envDb,
    FirebaseFirestore? firestore,
  }) : _firestore = getDatabaseInstance(envDb: envDb, firestore: firestore);

  /// Get user role from the users collection
  Future<String> getUserRole(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('Profile Repository Error: user not found in users collection');
      }
      return userDoc.data()!['role'] as String;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Profile Repository Error: failed to get user role - $e');
      }
      if (e.toString().contains('Profile Repository Error')) {
        rethrow;
      }
      throw Exception('Profile Repository Error: failed to get user role - ${e.toString()}');
    }
  }

  /// Fetch user data directly from users collection
  Future<UserModel> fetchUser(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        throw Exception('Profile Repository Error: user not found in users collection');
      }
      
      return UserModel.fromMap(userDoc.data()!, uid: userId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Profile Repository Error: failed to fetch user - $e');
      }
      if (e.toString().contains('Profile Repository Error')) {
        rethrow;
      }
      throw Exception('Profile Repository Error: failed to fetch user - ${e.toString()}');
    }
  }

  /// Update user profile in users collection
  Future<void> updateProfile({
    required String userId,
    Map<String, dynamic>? updates,
  }) async {
    try {
      if (updates == null || updates.isEmpty) {
        throw Exception('Profile Repository Error: no fields to update');
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .update(updates);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Profile Repository Error: failed to update profile - $e');
      }
      if (e.toString().contains('Profile Repository Error')) {
        rethrow;
      }
      throw Exception('Profile Repository Error: failed to update profile - ${e.toString()}');
    }
  }

  /// Stream user data for real-time updates
  Stream<UserModel> streamUser(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((snapshot) {
        if (!snapshot.exists) {
          throw Exception('Profile Repository Error: user not found in users collection');
        }
        
        return UserModel.fromMap(snapshot.data()!, uid: userId);
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Profile Repository Error: failed to stream user - $e');
      }
      throw Exception('Profile Repository Error: failed to stream user - ${e.toString()}');
    }
  }

  /// Get current user from Firebase Auth
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      
      return await fetchUser(user.uid);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Profile Repository Error: failed to get current user - $e');
      }
      if (e.toString().contains('Profile Repository Error')) {
        rethrow;
      }
      throw Exception('Profile Repository Error: failed to get current user - ${e.toString()}');
    }
  }

  /// Get current user role
  Future<String?> getCurrentUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      
      return await getUserRole(user.uid);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Profile Repository Error: failed to get current user role - $e');
      }
      if (e.toString().contains('Profile Repository Error')) {
        rethrow;
      }
      throw Exception('Profile Repository Error: failed to get current user role - ${e.toString()}');
    }
  }
}
