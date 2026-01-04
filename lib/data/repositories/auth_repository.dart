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
    final email = user.email;

    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user?.uid;
    if (uid == null) throw Exception('UID is null');

    final userWithUid = user.copyWith(uid: uid);

    // Write to users collection with all user data
    await _firestore.collection('users').doc(uid).set({
      ...userWithUid.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return userCredential;
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
        throw Exception('User credential is null after sign in');
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


    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Signs the user out of Firebase Auth.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

}