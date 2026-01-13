import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/data/services/add_admin_service.dart';
import 'package:flutter_firebase_template/data/models/user_model.dart';
import 'package:flutter_firebase_template/logic/admin/admin_event.dart';
import 'package:flutter_firebase_template/logic/admin/admin_state.dart';

/// Bloc for managing admin user operations.
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AddAdminService addAdminService;
  List<UserModel> _cachedAdmins = [];

  AdminBloc({required this.addAdminService}) : super(AdminInitial()) {
    on<FetchAdminsRequested>(_onFetchAdmins);
    on<AddAdminRequested>(_onAddAdmin);
    on<ResetAdminState>(_onResetState);
  }

  /// Handles fetching all admin users.
  Future<void> _onFetchAdmins(
    FetchAdminsRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminsLoading());
    try {
      final admins = await addAdminService.getAllAdmins();
      _cachedAdmins = admins;
      emit(AdminsLoaded(admins: admins));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Admin BLoC Error: failed to fetch admins - $e');
      }
      emit(AdminsLoadFailure(
        error: 'Admin BLoC Error: failed to fetch admins - ${e.toString()}',
      ));
    }
  }

  /// Handles adding a user as admin.
  Future<void> _onAddAdmin(
    AddAdminRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AddingAdmin(admins: _cachedAdmins));
    try {
      await addAdminService.addUserAsAdmin(email: event.email);
      // Refresh admin list after adding
      final admins = await addAdminService.getAllAdmins();
      _cachedAdmins = admins;
      emit(AdminAdded(email: event.email, admins: admins));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Admin BLoC Error: failed to add admin - $e');
      }
      emit(AddAdminFailure(
        error: 'Admin BLoC Error: failed to add admin - ${e.toString()}',
        admins: _cachedAdmins,
      ));
    }
  }

  /// Handles resetting the admin state.
  void _onResetState(
    ResetAdminState event,
    Emitter<AdminState> emit,
  ) {
    _cachedAdmins = [];
    emit(AdminInitial());
  }
}

