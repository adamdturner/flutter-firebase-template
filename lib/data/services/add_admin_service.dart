import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/data/models/user_model.dart';
import 'package:flutter_firebase_template/data/services/auth_service.dart';
import 'package:flutter_firebase_template/data/repositories/repository_utils.dart';
import 'package:flutter_firebase_template/envdb.dart';

class AddAdminService {
  final FirebaseFirestore _defaultFirestore;
  final FirebaseFirestore _sandboxFirestore;
  final AuthService _authService;

  AddAdminService({
    EnvDb? envDb,
    FirebaseFirestore? defaultFirestore,
    FirebaseFirestore? sandboxFirestore,
    AuthService? authService,
  })  : _defaultFirestore = getDatabaseInstance(envDb: EnvDb(Env.prod), firestore: defaultFirestore),
        _sandboxFirestore = getDatabaseInstance(envDb: EnvDb(Env.sandbox), firestore: sandboxFirestore),
        _authService = authService ?? AuthService();

  /// Adds an existing user as an admin by email
  /// 
  /// This method:
  /// 1. Looks up the user by email in the default database
  /// 2. Updates their role to 'admin' in the default database
  /// 3. Calls the cloud function to update custom claims
  /// 4. Creates a minimal user document in the sandbox database
  Future<void> addUserAsAdmin({required String email}) async {
    try {
      // Step 1: Find the user by email in the default database
      final userQuery = await _defaultFirestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('User with email $email not found');
      }

      final userDoc = userQuery.docs.first;
      final userData = userDoc.data();
      final userId = userDoc.id;

      // Step 2: Update the user's role to 'admin' in the default database
      await _defaultFirestore
          .collection('users')
          .doc(userId)
          .update({'role': 'admin'});

      // Step 3: Update custom claims via cloud function
      await _authService.setUserRole(uid: userId, role: 'admin');

      // Step 4: Create a minimal user document in the sandbox database
      await _createSandboxUserDocument(userId: userId, userData: userData);

      debugPrint('✅ Successfully added $email as admin');
    } catch (e) {
      debugPrint('❌ Error adding user as admin: $e');
      rethrow;
    }
  }

  /// Creates a minimal user document in the sandbox database
  /// 
  /// Only includes essential fields needed for the app to function:
  /// - uid, email, role, firstName, lastName
  /// - Initializes reward-related fields to 0
  /// - Does not copy personal information like phone, profile image, etc.
  Future<void> _createSandboxUserDocument({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      // Check if user already exists in sandbox database
      final existingDoc = await _sandboxFirestore
          .collection('users')
          .doc(userId)
          .get();

      if (existingDoc.exists) {
        debugPrint('⚠️ User already exists in sandbox database, updating role only');
        await _sandboxFirestore
            .collection('users')
            .doc(userId)
            .update({'role': 'admin'});
        return;
      }

      // Create minimal user document for sandbox database
      final sandboxUserData = {
        'uid': userId,
        'email': userData['email'] ?? '',
        'role': 'admin',
        'firstName': userData['firstName'] ?? '',
        'lastName': userData['lastName'] ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'isDemoUser': true, // Flag to identify demo users
      };

      await _sandboxFirestore
          .collection('users')
          .doc(userId)
          .set(sandboxUserData);

      debugPrint('✅ Created sandbox user document for $userId');
    } catch (e) {
      debugPrint('❌ Error creating sandbox user document: $e');
      rethrow;
    }
  }

  /// Gets a list of all users from the default database
  /// Useful for admin interfaces to see who can be added as admin
  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _defaultFirestore
          .collection('users')
          .orderBy('email')
          .get();

      return querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data(), uid: doc.id);
      }).toList();
    } catch (e) {
      debugPrint('❌ Error getting all users: $e');
      rethrow;
    }
  }

  /// Gets a list of all admins from the default database
  Future<List<UserModel>> getAllAdmins() async {
    try {
      final querySnapshot = await _defaultFirestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .orderBy('email')
          .get();

      return querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data(), uid: doc.id);
      }).toList();
    } catch (e) {
      debugPrint('❌ Error getting all admins: $e');
      rethrow;
    }
  }

  /// Checks if a user exists in the sandbox database
  Future<bool> isUserInDemoDatabase({required String userId}) async {
    try {
      final doc = await _sandboxFirestore
          .collection('users')
          .doc(userId)
          .get();
      
      return doc.exists;
    } catch (e) {
      debugPrint('❌ Error checking sandbox database: $e');
      return false;
    }
  }
}
