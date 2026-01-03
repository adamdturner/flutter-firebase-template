# Flutter Firebase Template

A production-ready Flutter template with Firebase integration, including Authentication, Firestore, Storage, and Cloud Functions.

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase CLI: `npm install -g firebase-tools`
- Node.js 20+ (for Cloud Functions)

### Setup for New Projects

1. **Clone this template**
   ```bash
   git clone <your-template-repo-url>
   cd flutter-firebase-template
   ```

2. **Create your Firebase project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Authentication, Firestore, and Storage

3. **Configure Firebase for your project**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure your Flutter app with your Firebase project
   flutterfire configure
   ```
   This generates `firebase_options.dart` and platform-specific config files (gitignored).

4. **Install dependencies**
   ```bash
   flutter pub get
   cd functions && npm install && cd ..
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
  ├── main.dart              # App entry point
  └── firebase_options.dart  # Generated (gitignored)

functions/
  ├── src/
  │   └── index.ts          # Cloud Functions
  ├── package.json
  └── tsconfig.json

firestore.rules               # Firestore Security Rules
storage.rules                 # Storage Security Rules
firebase.json                 # Firebase configuration
```

## 🔐 Security Notes

**The following files are gitignored and contain your credentials:**
- `firebase_options.dart` / `lib/firebase_options.dart`
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS/macOS)
- `.firebaserc` (your Firebase project ID)
- `functions/node_modules/`
- `functions/lib/` (compiled functions)

**These files ARE tracked (template code):**
- `firebase.json` - Firebase project configuration
- `firestore.rules` - Database security rules (production-ready)
- `storage.rules` - Storage security rules (production-ready)
- `functions/src/` - Cloud Functions source code

## 🛡️ Security Rules

The template includes **production-ready security rules** that require authentication:

**Firestore (`firestore.rules`):**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Storage (`storage.rules`):**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Customize these rules** based on your app's data structure and access patterns.

## 🔥 Firebase Features

### Authentication
- Email/Password
- Google Sign-In
- (Add more providers as needed)

### Firestore Database
- NoSQL cloud database
- Real-time synchronization
- Offline support

### Cloud Storage
- File uploads
- Image storage
- Secure access control

### Cloud Functions
- Backend logic
- Triggers (Firestore, Auth, Storage)
- HTTP endpoints

## 🛠️ Development

### Run locally with emulators

```bash
firebase emulators:start
```

### Deploy to Firebase

```bash
# Deploy everything
firebase deploy

# Deploy specific services
firebase deploy --only firestore
firebase deploy --only functions
firebase deploy --only storage
```

### Build functions

```bash
cd functions
npm run build
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)

## 📝 License

[Add your license here]
