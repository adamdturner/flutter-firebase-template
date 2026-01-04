import 'package:cloud_functions/cloud_functions.dart';
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
        throw Exception(data['message']);
      }
    } on FirebaseFunctionsException catch (e) {
      throw Exception('FirebaseFunctionsException: ${e.message}');
    } catch (e) {
      throw Exception('Error setting user role: $e');
    }
  }
}
