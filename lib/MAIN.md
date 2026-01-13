# Main Entry Point

## Purpose
The `main.dart` file is the application entry point that initializes Firebase, loads environment preferences, and orchestrates the authentication flow to determine which app view to display.

## Key Requirements
- Initialize Firebase before running the app
- Load environment preferences (prod/sandbox) via `EnvCubit`
- Use `AppProviders` to provide app-wide dependencies
- Switch between authenticated and unauthenticated views based on auth state
- Enable edge-to-edge display for modern UI

## Architecture Overview

### Directory Structure
```
lib/
├── main.dart                    # Entry point & auth orchestration
├── authenticated_app.dart       # Authenticated user interface
├── app/                         # Provider composition
├── core/                        # Theme, design system, utilities
├── data/                        # Models, repositories, services
├── logic/                       # BLoC state management
├── presentation/                # Screens & reusable widgets
└── routes/                      # Navigation routing
```

### Authentication Flow
1. **Loading State**: Shows loading screen while checking auth
2. **Unauthenticated**: Shows login screen
3. **Authenticated**: Shows full app via `AuthenticatedApp`

### Database Switching
The `EnvCubit` manages environment selection (production vs sandbox):
- Loaded before app starts from shared preferences
- Accessed throughout app for database instance selection
- AuthRepository always uses production for sign-up/sign-in

## Example

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Load environment preference
  final envCubit = await EnvCubit.load();
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  runApp(TemplateApp(envCubit: envCubit));
}

// Root widget uses BlocBuilder to switch between views
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthAuthenticated) {
      return AuthenticatedApp(uid: state.user.uid);
    } else if (state is AuthUnauthenticated) {
      return _buildUnauthenticatedApp(context);
    } else {
      return _buildLoadingApp(context);
    }
  },
)
```
