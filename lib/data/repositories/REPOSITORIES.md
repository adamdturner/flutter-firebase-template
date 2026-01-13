# Repositories

## Purpose
Repository files provide the ONLY access point to Firestore collections. They abstract database operations and handle environment-aware database instance selection.

## Key Requirements
- The ONLY location that a firestore collection will be accessed is through a repository file
- Methods should all have a try-catch block with debugPrint (for debug mode only)
- There should be a new repository file for every firestore collection or for every new unique system process, depending on how complex the app gets
- Single responsibility rule is important - there should not be one function or one file doing too much stuff
- Never perform database operations directly in UI, BLoC, or service files
- Use models for type-safe data conversion
- Support environment switching (prod/sandbox) via EnvDb

## Repository Structure
1. **Dependencies**: Firestore instance and EnvDb for environment switching
2. **Collection Helper**: Method to get environment-aware collection reference
3. **CRUD Methods**: Create, read, update, delete operations
4. **Error Handling**: Try-catch with debug prints and descriptive errors

## Example

```dart
class UserRepository {
  final FirebaseFirestore _firestore;
  final EnvDb? _envDb;

  UserRepository({
    EnvDb? envDb,
    FirebaseFirestore? firestore,
  }) : _firestore = getDatabaseInstance(envDb: envDb, firestore: firestore),
       _envDb = envDb;

  // Get environment-aware collection reference
  CollectionReference<Map<String, dynamic>> _getCollection(String path) {
    if (_envDb != null) {
      return _envDb.collection(path);
    }
    return _firestore.collection(path);
  }

  // Fetch user data from Firestore
  Future<UserModel> fetchUserData(String userID) async {
    try {
      final userDoc = await _getCollection('users').doc(userID).get();
      
      if (!userDoc.exists) {
        throw Exception('User Repository Error: user not found');
      }
      
      final data = userDoc.data()!;
      return UserModel.fromMap(data, uid: userID);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ User Repository Error: failed to fetch user - $e');
      }
      if (e.toString().contains('User Repository Error')) {
        rethrow;
      }
      throw Exception('User Repository Error: failed to fetch user - ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      if (updates.isEmpty) {
        throw Exception('User Repository Error: no fields to update');
      }

      await _getCollection('users')
          .doc(userId)
          .update(updates);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ User Repository Error: failed to update profile - $e');
      }
      throw Exception('User Repository Error: failed to update profile - ${e.toString()}');
    }
  }
}
```
