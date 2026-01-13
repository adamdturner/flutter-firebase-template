import 'package:flutter_firebase_template/data/models/user_model.dart';

/// Base class for admin-related states.
abstract class AdminState {}

/// Initial state before any admin data is loaded.
class AdminInitial extends AdminState {}

/// State while admin list is being fetched.
class AdminsLoading extends AdminState {}

/// State when admin list has been successfully loaded.
class AdminsLoaded extends AdminState {
  final List<UserModel> admins;

  AdminsLoaded({required this.admins});
}

/// State when fetching admin list has failed.
class AdminsLoadFailure extends AdminState {
  final String error;

  AdminsLoadFailure({required this.error});
}

/// State while adding a new admin.
class AddingAdmin extends AdminState {
  final List<UserModel> admins;

  AddingAdmin({required this.admins});
}

/// State when admin has been successfully added.
class AdminAdded extends AdminState {
  final String email;
  final List<UserModel> admins;

  AdminAdded({required this.email, required this.admins});
}

/// State when adding admin has failed.
class AddAdminFailure extends AdminState {
  final String error;
  final List<UserModel> admins;

  AddAdminFailure({required this.error, required this.admins});
}

