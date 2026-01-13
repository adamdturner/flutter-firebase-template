import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_template/data/services/service_config.dart';

class AuthService {
  final _functions = FirebaseFunctions.instance;
  

  Future<void> setUserRole({
    required String uid,
    required String role,
  }) async {
    try {
      final callable = _functions.httpsCallableFromUrl(
        ServiceConfig.setUserRoleURL,
      );
      final response = await callable.call({
        'uid': uid,
        'role': role,
      });

      final data = response.data;
      if (data['error'] == true) {
        throw Exception('Auth Service Error: ${data['message']}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Auth Service Error: failed to set user role - $e');
      }
      if (e.toString().contains('Auth Service Error')) {
        rethrow;
      }
      throw Exception('Auth Service Error: failed to set user role - ${e.toString()}');
    }
  }
}
