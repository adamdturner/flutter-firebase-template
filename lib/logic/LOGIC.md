# Business Logic (BLoC)

## Purpose
The `logic/` directory contains all BLoC (Business Logic Component) state management code. BLoCs handle the application's business logic, coordinate between UI and data layers, and manage state.

## Key Requirements
- Follows event/state/bloc pattern from UI triggers to repository or service calls
- Try-catch blocks are used for all error handling and contain a debugPrint for debug mode
- Each feature has three files: `*_bloc.dart`, `*_event.dart`, `*_state.dart`
- BLoCs receive repository/service dependencies through constructor injection
- UI never directly calls repositories or services - always through BLoC
- Events represent user actions or system events
- States represent different UI states (loading, success, error, etc.)

## BLoC Pattern Structure

### Event File
Defines all possible user actions and system events:
```dart
abstract class AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  
  AuthSignInRequested({required this.email, required this.password});
}

class AuthSignOutRequested extends AuthEvent {}
```

### State File
Defines all possible states the UI can be in:
```dart
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}
class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
```

### BLoC File
Handles events and emits states:
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      
      final user = userCredential.user;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Auth BLoC Error: failed to sign in - $e');
      }
      emit(AuthFailure(error: 'Failed to sign in: ${e.toString()}'));
    }
  }
}
```

## Usage in UI
```dart
// Dispatch events
context.read<AuthBloc>().add(AuthSignInRequested(
  email: email,
  password: password,
));

// React to state changes
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return AppLoadingWidget();
    } else if (state is AuthAuthenticated) {
      return HomeScreen();
    } else if (state is AuthFailure) {
      return ErrorWidget(message: state.error);
    }
    return LoginScreen();
  },
)
```
