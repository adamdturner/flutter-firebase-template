/// Base class for user-related events.
abstract class UserEvent {}

/// Event to request fetching user data by ID.
class FetchUserRequested extends UserEvent {
  final String userId;
  FetchUserRequested(this.userId);
}

/// Event to force refresh user data, bypassing cache.
class RefreshUserRequested extends UserEvent {
  final String userId;
  RefreshUserRequested(this.userId);
}

/// Event to clear the cached user data.
class ClearUserCache extends UserEvent {}

