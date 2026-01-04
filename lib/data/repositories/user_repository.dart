import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/data/repositories/repository_utils.dart';
import 'package:flutter_firebase_template/envdb.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final EnvDb? _envDb;
  final currentUser = FirebaseAuth.instance.currentUser;

  UserRepository({
    EnvDb? envDb,
    FirebaseFirestore? firestore,
  }) : _firestore = getDatabaseInstance(envDb: envDb, firestore: firestore),
       _envDb = envDb;
  
  // Helper method to get the correct collection reference
  CollectionReference<Map<String, dynamic>> _getCollection(String path) {
    if (_envDb != null) {
      return _envDb.collection(path);
    }
    return _firestore.collection(path);
  }
  
  // Helper method to fetch user data from a specific collection
  Future<UserModel> _fetchUserDataFromCollection(
    CollectionReference<Map<String, dynamic>> collection, 
    String userID
  ) async {
    final userDoc = await collection.doc(userID).get();
    
    if (!userDoc.exists) {
      throw Exception('User not found in users collection');
    }
    
    final data = userDoc.data()!;
    return UserModel.fromMap(data, uid: userID);
  }


  Future<UserModel> fetchUserData(String userID) async {
    try {
      final userAccountsCollection = _getCollection('users');
      return await _fetchUserDataFromCollection(userAccountsCollection, userID);
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  /// Fetch user display name
  /// Returns first name, full name, or email as fallback
  Future<String> fetchUserDisplayName(String userId) async {
    try {
      final userDoc = await _getCollection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        throw Exception('User not found in users collection');
      }
      
      final data = userDoc.data();
      final firstName = data?['firstName'];
      final lastName = data?['lastName'];
      final email = data?['email'];
      
      // Return full name if available, otherwise first name, otherwise email
      if (firstName != null && lastName != null && firstName.isNotEmpty && lastName.isNotEmpty) {
        return '$firstName $lastName';
      } else if (firstName != null && firstName.isNotEmpty) {
        return firstName;
      } else {
        return email ?? 'Unknown User';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<Map<String, dynamic>?> fetchUserFields(String uid) async {
    final userDoc = await _getCollection('users').doc(uid).get();
    if (!userDoc.exists) return null;
    return userDoc.data();
  }



  /// Update user profile information
  Future<void> updateProfile({
    required String userId,
    Map<String, dynamic>? updates,
  }) async {
    try {
      if (updates == null || updates.isEmpty) {
        throw Exception('No fields to update');
      }

      await _getCollection('users')
          .doc(userId)
          .update(updates);
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }



}