/// Base class for admin-related events.
abstract class AdminEvent {}

/// Event to request fetching all admin users.
class FetchAdminsRequested extends AdminEvent {}

/// Event to request adding a user as admin by email.
class AddAdminRequested extends AdminEvent {
  final String email;

  AddAdminRequested({required this.email});
}

/// Event to reset the admin state.
class ResetAdminState extends AdminEvent {}

