# App Providers

## Purpose
The `app/` directory contains provider composition files that establish app-wide and authenticated-scope dependencies using Provider and BLoC patterns.

## Key Files
- **app_providers.dart**: App-wide providers available throughout entire lifecycle
- **authenticated_providers.dart**: Providers only available when user is authenticated

## Key Requirements
- Use `MultiProvider` for clean provider composition
- Separate app-wide providers from authenticated-only providers
- Provide single instances of repositories and BLoCs at appropriate scopes
- BLoCs should receive repository dependencies through constructor injection

## Provider Scopes

### App-Wide Providers (`AppProviders`)
Available throughout entire app lifecycle:
- `EnvCubit` - Environment selection (prod/sandbox)
- `ThemeManager` - Theme preferences
- `FontScaleManager` - Font scaling preferences
- `AuthBloc` - Authentication state

### Authenticated Providers (`AuthenticatedProviders`)
Only available when user is authenticated:
- `UserBloc` - User profile management
- `NavigationBloc` - App navigation state
- Additional feature-specific BLoCs

## Example

```dart
// App-wide providers
class AppProviders extends StatelessWidget {
  final EnvCubit envCubit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<EnvCubit>.value(value: envCubit),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => FontScaleManager()),
      ],
      child: _AuthBlocProvider(child: child),
    );
  }
}

// Authenticated providers with repository injection
class AuthenticatedProviders extends StatelessWidget {
  final String uid;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final envDb = context.read<EnvCubit>().state;
    
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => UserBloc(
            userRepository: UserRepository(envDb: envDb),
          )..add(LoadUser(uid)),
        ),
        BlocProvider(
          create: (_) => NavigationBloc(),
        ),
      ],
      child: child,
    );
  }
}
```
