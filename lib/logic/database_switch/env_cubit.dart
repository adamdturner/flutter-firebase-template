import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_firebase_template/envdb.dart';
import 'package:flutter_firebase_template/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnvCubit extends Cubit<Env> {
  static const _key = 'current_env';
  EnvCubit(Env initial) : super(initial);

  static Future<EnvCubit> load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key) ?? 'prod';
    final env = str == 'sandbox' ? Env.sandbox : Env.prod;
    return EnvCubit(env);
  }

  Future<void> setEnv(Env next) async {
    if (next == state) return;
    emit(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, next.name);
  }

  /// Check if the currently logged in user is an admin and handle demo mode accordingly
  Future<void> enforceAdminOnlyDemoMode() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final envDb = EnvDb(state);
      final userRepository = UserRepository(envDb: envDb);
      final userModel = await userRepository.fetchUserData(currentUser.uid);
      
      // If we're in demo mode but the user is not an admin, switch back to production
      if (state == Env.sandbox && userModel.role != 'admin') {
        await setEnv(Env.prod);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Env Cubit Error: failed to enforce admin only demo mode - $e');
      }
      // If there's an error fetching user data and we're in demo mode, 
      // switch back to production for safety
      if (state == Env.sandbox) {
        await setEnv(Env.prod);
      }
    }
  }
}
