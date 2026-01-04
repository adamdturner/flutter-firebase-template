import 'package:cloud_firestore/cloud_firestore.dart';

// List the databases here
enum Env { prod, sandbox }

class EnvDb {
  final Env env;
  final FirebaseFirestore db;

  EnvDb._(this.env, this.db);
  
  // Get the correct collection reference based on environment
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return db.collection(path);
  }

  factory EnvDb(Env env) {
    if (env == Env.prod) {
      // Production uses the default Firestore instance
      return EnvDb._(env, FirebaseFirestore.instance);
    } else {
      // Sandbox uses a named database instance
      try {
        final app = FirebaseFirestore.instance.app;
        final sandboxDb = FirebaseFirestore.instanceFor(
          app: app,
          databaseId: 'sandbox',
        );
        return EnvDb._(env, sandboxDb);
      } catch (e) {
        // Fallback to default database if sandbox database doesn't exist
        final defaultDb = FirebaseFirestore.instance;
        return EnvDb._(env, defaultDb);
      }
    }
  }
}
