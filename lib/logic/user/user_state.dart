import 'package:flutter_firebase_template/data/models/user_model.dart';

/// Base class for user-related states.
abstract class UserState {}

/// Initial state before any user data is loaded.
class UserInitial extends UserState {}

/// State while user data is being fetched.
class UserLoading extends UserState {}

/// State when user data has been successfully loaded.
class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

/// State when fetching user data has failed.
class UserFailure extends UserState {
  final String message;
  UserFailure(this.message);
}

