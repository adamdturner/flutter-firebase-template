import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/data/models/user_model.dart';
import 'package:flutter_firebase_template/data/repositories/repository_utils.dart';
import 'package:flutter_firebase_template/envdb.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    EnvDb? envDb,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = getDatabaseInstance(envDb: envDb, firestore: firestore);

  Future<UserCredential> signUp({
    required String password,
    required UserModel user,
  }) async {
    try {
      final email = user.email;

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('Auth Repository Error: UID is null after user creation');
      }

      final userWithUid = user.copyWith(uid: uid);

      // Write to users collection with all user data
      await _firestore.collection('users').doc(uid).set({
        ...userWithUid.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } catch (e) {
      if (e.toString().contains('Auth Repository Error')) {
        rethrow;
      }
      throw Exception('Auth Repository Error: failed to sign up user - ${e.toString()}');
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Ensure the user credential is valid
      if (userCredential.user == null) {
        throw Exception('Auth Repository Error: user credential is null after sign in');
      }
      // uncomment the code below to print the claims when the user logs in
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Force a token refresh to ensure you have the latest custom claims
        await user.getIdToken(true);

        final idTokenResult = await user.getIdTokenResult();
        final claims = idTokenResult.claims;

        debugPrint('✅ Custom claims for ${user.uid}: $claims');
      }
      
      return userCredential;
    } catch (e) {
      if (e.toString().contains('Auth Repository Error')) {
        rethrow;
      }
      throw Exception('Auth Repository Error: failed to sign in - ${e.toString()}');
    }
  }

  /// Signs the user out of Firebase Auth.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Auth Repository Error: failed to sign out - ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e.toString().contains('Auth Repository Error')) {
        rethrow;
      }
      throw Exception('Auth Repository Error: failed to send password reset email - ${e.toString()}');
    }
  }

}