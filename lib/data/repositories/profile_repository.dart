import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        throw Exception('User not found in users collection');
      }
      return userDoc.data()!['role'] as String;
    } catch (e) {
      throw Exception('Error getting user role: $e');
    }
  }

  /// Fetch user data directly from users collection
  Future<UserModel> fetchUser(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        throw Exception('User not found in users collection');
      }
      
      return UserModel.fromMap(userDoc.data()!, uid: userId);
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  /// Update user profile in users collection
  Future<void> updateProfile({
    required String userId,
    Map<String, dynamic>? updates,
  }) async {
    try {
      if (updates == null || updates.isEmpty) {
        throw Exception('No fields to update');
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .update(updates);
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  /// Stream user data for real-time updates
  Stream<UserModel> streamUser(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        throw Exception('User not found in users collection');
      }
      
      return UserModel.fromMap(snapshot.data()!, uid: userId);
    });
  }

  /// Get current user from Firebase Auth
  Future<UserModel?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    
    try {
      return await fetchUser(user.uid);
    } catch (e) {
      return null;
    }
  }

  /// Get current user role
  Future<String?> getCurrentUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    
    try {
      return await getUserRole(user.uid);
    } catch (e) {
      return null;
    }
  }
}
