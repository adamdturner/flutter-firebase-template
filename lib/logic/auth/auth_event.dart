import 'package:flutter_firebase_template/data/models/user_model.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {} // Called on app start

class AuthSignUpRequested extends AuthEvent {
  final String password;
  final UserModel user;

  AuthSignUpRequested({
    required this.password,
    required this.user,
  });
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignInRequested({required this.email, required this.password});
}

class AuthSignOutRequested extends AuthEvent {} // Called on logout

class AuthUserSignedOut extends AuthEvent {} // Called when auth state changes to null

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  AuthForgotPasswordRequested({required this.email});
}
