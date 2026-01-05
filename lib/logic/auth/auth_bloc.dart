import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/data/services/auth_service.dart';

import 'package:flutter_firebase_template/data/repositories/auth_repository.dart';
import 'package:flutter_firebase_template/logic/auth/auth_event.dart';
import 'package:flutter_firebase_template/logic/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final AuthService _authService = AuthService();
  late final StreamSubscription<User?> _authSubscription;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthUserSignedOut>(_onUserSignedOut);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        add(AuthStarted());
      } else {
        // Use AuthUserSignedOut instead of AuthSignOutRequested to avoid
        // calling signOut() again when user is already signed out
        add(AuthUserSignedOut());
      }
    });
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignUpRequested(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signUp(
        password: event.password,
        user: event.user,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('Auth BLoC Error: user UID was null after signup');
      }

      await _authService.setUserRole(uid: uid, role: event.user.role);

      // Let authStateChanges stream trigger AuthAuthenticated state
    } catch (e) {
      emit(AuthFailure(error: 'Auth BLoC Error: failed to sign up user - ${e.toString()}'));
    }
  }

  Future<void> _onSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signIn(email: event.email, password: event.password);
      final user = userCredential.user;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(error: 'Auth BLoC Error: failed to sign in - ${e.toString()}'));
    }
  }

  Future<void> _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(error: 'Auth BLoC Error: failed to sign out - ${e.toString()}'));
    }
  }

  /// Handles auth state change when user becomes null (already signed out).
  Future<void> _onUserSignedOut(AuthUserSignedOut event, Emitter<AuthState> emit) async {
    emit(AuthUnauthenticated());
  }

  Future<void> _onForgotPasswordRequested(AuthForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.sendPasswordResetEmail(email: event.email);
      emit(AuthPasswordResetSent(email: event.email));
    } catch (e) {
      emit(AuthFailure(error: 'Auth BLoC Error: failed to send password reset email - ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
