# Flutter Firebase Template

A production-ready Flutter template with Firebase integration, featuring a clean architecture with separation of concerns, BLoC state management, and production-ready security rules.

## 🚀 Getting Started

**New to this template?** See [SETUP.md](SETUP.md) for complete setup instructions.

## 🏗️ Architecture Overview

This template follows a **layered architecture** with strict separation of concerns to ensure maintainable, testable, and scalable code.

```
┌─────────────────────────────────────┐
│     Presentation Layer (UI)         │  
│  Screens, Widgets, User Input       │
└──────────────┬──────────────────────┘
               │ Events
               ▼
┌─────────────────────────────────────┐
│      Logic Layer (BLoC)             │
│  State Management, Business Logic   │
└──────────────┬──────────────────────┘
               │ Method Calls
               ▼
┌─────────────────────────────────────┐
│      Data Layer                     │
│  Repositories, Services, Models     │
└──────────────┬──────────────────────┘
               │ API/Database Calls
               ▼
┌─────────────────────────────────────┐
│    External Services                │
│  Firebase, Cloud Functions, APIs    │
└─────────────────────────────────────┘
```

### Data Flow Pattern

**Separation of Concerns:**
```
UI Interaction → Event Updates BLoC State → BLoC Logic Executes → 
Repository/Service Called → Try/Catch Error Handling → Response to UI
```

**Critical Rule:** UI NEVER directly accesses the database. All data operations flow through the BLoC layer.

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── authenticated_app.dart       # Post-authentication app shell
├── firebase_options.dart        # Generated Firebase config (gitignored)
│
├── core/                        # Application constants & globals
│   ├── design_system.dart       # Design tokens (colors, spacing, typography)
│   ├── theme.dart               # Theme configuration
│   ├── theme_manager.dart       # Theme state management
│   ├── font_scale_manager.dart  # Accessibility font scaling
│   ├── STYLING_GUIDE.md         # UI/UX styling guidelines
│   └── utils/                   # Core utility functions
│
├── data/                        # Data access layer
│   ├── models/                  # Firestore document models
│   │   └── *_model.dart         # Model with read/write methods
│   ├── repositories/            # Database access (Firestore collections)
│   │   └── *_repository.dart    # ONLY place for Firestore operations
│   └── services/                # External integrations
│       └── *_service.dart       # Cloud Functions, third-party APIs
│
├── logic/                       # Business logic & state management
│   ├── auth/                    # Authentication BLoC
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── user/                    # User data BLoC
│   └── */                       # Feature-specific BLoCs
│
├── presentation/                # UI layer
│   ├── screens/                 # Full-page screens
│   │   └── *_screen.dart
│   └── widgets/                 # Reusable UI components
│       └── *.dart
│
└── routes/
    └── app_router.dart          # Navigation configuration
```

## 🧩 Layer Responsibilities

### 1. Data Layer (`lib/data/`)

#### Models (`models/`)
- **One model per Firestore document type**
- Contains methods for reading and writing that document
- Maintains consistent variable types and field names
- Example: `user_model.dart`, `post_model.dart`

**Model Pattern:**
```dart
class UserModel {
  final String id;
  final String email;
  final String displayName;
  
  // Constructor, fromJson, toJson
  
  // Document operations
  Future<void> saveToFirestore() async { ... }
  static Future<UserModel?> fromFirestore(String id) async { ... }
}
```

#### Repositories (`repositories/`)
- **One repository per Firestore collection** or independent feature
- **ONLY repositories can read/write Firestore documents**
- Handle all database operations with proper error handling
- Example: `auth_repository.dart`, `user_repository.dart`

**Repository Pattern:**
```dart
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return UserModel.fromFirestore(doc);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> updateUser(UserModel user) async { ... }
}
```

#### Services (`services/`)
- Communicate with **external systems** (not Firestore)
- Cloud Functions calls
- Third-party API integrations
- Example: `analytics_service.dart`, `notification_service.dart`

### 2. Core Layer (`lib/core/`)

Contains application-wide constants and configurations:

- **`design_system.dart`**: Design tokens (colors, spacing, border radius, shadows)
- **`theme.dart`**: Material theme configuration
- **`STYLING_GUIDE.md`**: Comprehensive UI/UX guidelines
- Standard font sizes, weights, and families
- Global color palette and semantic colors
- Spacing and layout constants

**Usage:** Import from core for all styling decisions to maintain consistency.

### 3. Logic Layer (`lib/logic/`)

#### BLoC State Management
- **Middle layer** between UI and data
- Handles business logic and state transitions
- Each feature has its own BLoC (auth, user, navigation, etc.)

**BLoC Pattern:**
```dart
// Event: UI triggers action
class LoadUserEvent extends UserEvent {
  final String userId;
  LoadUserEvent(this.userId);
}

// State: Represents current state
class UserLoadedState extends UserState {
  final UserModel user;
  UserLoadedState(this.user);
}

// BLoC: Business logic
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;
  
  UserBloc(this._repository) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        final user = await _repository.getUser(event.userId);
        emit(UserLoadedState(user));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }
}
```

### 4. Presentation Layer (`lib/presentation/`)

#### Screens (`screens/`)
- Full-page views
- Listen to BLoC states via `BlocBuilder` or `BlocListener`
- Dispatch events to BLoC
- **Never** directly call repositories or services

#### Widgets (`widgets/`)
- Reusable UI components
- Stateless when possible
- Accept callbacks for user interactions
- Follow design system from `core/`

**UI Pattern:**
```dart
class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadingState) return LoadingIndicator();
        if (state is UserErrorState) return ErrorWidget(state.message);
        if (state is UserLoadedState) {
          return _buildProfile(state.user);
        }
        return Container();
      },
    );
  }
  
  void _onUpdatePressed(BuildContext context) {
    // Dispatch event to BLoC
    context.read<UserBloc>().add(UpdateUserEvent(...));
  }
}
```

## 🎨 Coding Standards

### General Guidelines
- Follow the [STYLING_GUIDE.md](lib/core/STYLING_GUIDE.md) for UI consistency
- Use explicit types, avoid `var` when type is not obvious
- Add concise comments before function definitions
- Prefer composition over inheritance
- Keep files focused and under 300 lines when possible

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `kCamelCase` (prefix with `k`)
- **Private members**: `_leadingUnderscore`

### Error Handling

**Critical:** All business logic must have comprehensive error handling with descriptive messages.

#### Error Message Convention
Error messages must identify their source layer and provide specific context:
- **Repository errors:** `"[RepositoryName] Error: [specific issue]"`
- **Service errors:** `"[ServiceName] Error: [specific issue]"`
- **BLoC errors:** `"[BlocName] Error: [specific issue]"`

#### Repository/Service Pattern
Every method in repositories and services MUST have a try-catch block:

```dart
// Repository Example
class UserRepository {
  Future<UserModel> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User Repository Error: user not found in users collection');
      }
      return UserModel.fromFirestore(doc);
    } catch (e) {
      if (e.toString().contains('User Repository Error')) {
        rethrow; // Already a repository error
      }
      throw Exception('User Repository Error: failed to fetch user - ${e.toString()}');
    }
  }
}

// Service Example
class NotificationService {
  Future<void> sendNotification(String userId, String message) async {
    try {
      final response = await _httpClient.post(...);
      if (response.statusCode != 200) {
        throw Exception('Notification Service Error: API returned ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Notification Service Error')) {
        rethrow;
      }
      throw Exception('Notification Service Error: failed to send notification - ${e.toString()}');
    }
  }
}
```

#### BLoC Pattern
Every event handler in BLoCs MUST have a try-catch block:

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  on<LoadUserEvent>((event, emit) async {
    emit(UserLoadingState());
    try {
      final user = await _repository.getUser(event.userId);
      emit(UserLoadedState(user));
    } catch (e) {
      // Repository errors are already descriptive, add BLoC context
      emit(UserErrorState('User BLoC Error: failed to load user - ${e.toString()}'));
    }
  });
  
  on<UpdateUserEvent>((event, emit) async {
    emit(UserLoadingState());
    try {
      await _repository.updateUser(event.user);
      emit(UserUpdatedState(event.user));
    } catch (e) {
      emit(UserErrorState('User BLoC Error: failed to update user - ${e.toString()}'));
    }
  });
}
```

**Benefits:**
- Easy to identify the source layer of any error
- Specific context for debugging
- Consistent error format across the entire app
- Error messages help locate issues in logs quickly

## 🔥 Firebase Features

### Authentication
- Email/Password authentication
- Google Sign-In
- User session management via BLoC

### Firestore Database
- NoSQL cloud database
- Real-time synchronization
- Offline support
- Production-ready security rules

### Cloud Storage
- File uploads (images, documents)
- Secure user-specific storage paths
- Access control via security rules

### Cloud Functions
- Backend logic and triggers
- Callable functions for complex operations
- Access via Services layer

## 🛠️ Development Commands

```bash
# Run the app
flutter run

# Run with Firebase emulators
firebase emulators:start

# Build for production
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web

# Deploy Firebase services
firebase deploy                    # Deploy all
firebase deploy --only firestore   # Firestore rules only
firebase deploy --only functions   # Cloud Functions only
firebase deploy --only storage     # Storage rules only
```

## 📚 Additional Resources

- [Setup Guide](SETUP.md) - Complete setup instructions
- [Styling Guide](lib/core/STYLING_GUIDE.md) - UI/UX guidelines
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [BLoC Documentation](https://bloclibrary.dev/)

## 📝 License

[Add your license here]
