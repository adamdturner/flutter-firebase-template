# Flutter Firebase Template - Setup Guide

Follow these steps to create a new Flutter + Firebase app using this template.

## Prerequisites

Before you begin, ensure you have:

- **Flutter SDK** - [Installation Guide](https://docs.flutter.dev/get-started/install)
- **Node.js 20+** - For Cloud Functions ([Download](https://nodejs.org/))
- **Firebase CLI** - Install globally:
  ```bash
  npm install -g firebase-tools
  ```
- **FlutterFire CLI** - Install globally:
  ```bash
  dart pub global activate flutterfire_cli
  ```
  > Add `~/.pub-cache/bin` to your PATH if not already done

## Step 1: Clone the Template

```bash
# Clone into your new project directory
git clone <your-template-repo-url> my-new-app
cd my-new-app

# Remove template git history and start fresh
rm -rf .git
git init
```

## Step 2: Create Firebase Project

1. Open the [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project**
3. Enter your project name (e.g., "My New App")
4. (Optional) Enable Google Analytics
5. Click **Create Project**
6. **Important:** Upgrade to the **Blaze Plan** (Pay-as-you-go) to use Cloud Functions
   - Go to **Project Settings → Usage and billing → Details & settings**
   - Click **Modify plan** and select Blaze

## Step 3: Enable Firebase Services

### Enable Authentication

1. In Firebase Console, go to **Build → Authentication**
2. Click **Get Started**
3. Enable sign-in methods:
   - **Email/Password** - Toggle on
   - **Google** - Toggle on, then add a support email

### Enable Firestore Database

1. Go to **Build → Firestore Database**
2. Click **Create Database**
3. Choose **Start in production mode** (security rules are included in template)
4. Select a Cloud Firestore location:
   - Recommended: **us-central1** (best for free tier)
   - Choose closest to your users

### Enable Cloud Storage

1. Go to **Build → Storage**
2. Click **Get Started**
3. Choose **Start in production mode** (security rules are included in template)
4. Select storage location (use same location as Firestore)

## Step 4: Connect Flutter App to Firebase

Run the FlutterFire CLI to automatically configure your app:

```bash
flutterfire configure
```

When prompted:
- **Select your Firebase project** from the list
- **Choose platforms** to support (iOS, Android, Web, macOS)

This command generates:
- `lib/firebase_options.dart` (gitignored)
- `android/app/google-services.json` (gitignored)
- `ios/Runner/GoogleService-Info.plist` (gitignored)
- `macos/Runner/GoogleService-Info.plist` (gitignored, if macOS selected)

## Step 5: Install Dependencies

```bash
# Install Flutter packages
flutter pub get

# Install Cloud Functions dependencies
cd functions
npm install
cd ..
```

## Step 6: Configure Firebase CLI

Authenticate and link your local project to Firebase:

```bash
# Login to Firebase (opens browser)
firebase login

# Link this project to your Firebase project
firebase use --add
```

When prompted:
- Select your Firebase project
- Enter an alias (typically "default")

This creates `.firebaserc` (gitignored) with your project ID.

## Step 7: Deploy Firebase Configuration

Deploy security rules and Cloud Functions to your Firebase project:

```bash
# Build Cloud Functions
cd functions
npm run build
cd ..

# Deploy all Firebase services
firebase deploy
```

Alternatively, deploy services individually:
```bash
firebase deploy --only firestore:rules  # Firestore security rules
firebase deploy --only storage:rules    # Storage security rules
firebase deploy --only functions        # Cloud Functions
```

## Step 8: Verify Setup

### Test the Flutter App

```bash
flutter run
```

The app should launch successfully and connect to Firebase.

### Test Cloud Functions

After deployment, Firebase will provide URLs for your functions:
```
https://us-central1-YOUR-PROJECT-ID.cloudfunctions.net/helloWorld
```

Test the example function:
```bash
curl https://YOUR-REGION-YOUR-PROJECT-ID.cloudfunctions.net/helloWorld
```

Expected response: `"Hello from Firebase!"`

## 🔒 Understanding Security Rules

This template includes **production-ready security rules** that require user authentication.

### Firestore Rules

File: `firestore.rules`

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

- Users can only read/write documents in `/users/{userId}` where `userId` matches their auth UID
- **Customize this** based on your app's data structure

### Storage Rules

File: `storage.rules`

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

- Users can only access files under `/users/{userId}/`
- **Customize this** based on your storage structure

### Modifying Rules

1. Edit `firestore.rules` or `storage.rules` locally
2. Deploy changes:
   ```bash
   firebase deploy --only firestore:rules
   firebase deploy --only storage:rules
   ```

## 🎉 Setup Complete!

Your Flutter + Firebase project is ready. Next steps:

1. Review the [README.md](README.md) for architecture and coding standards
2. Check [lib/core/STYLING_GUIDE.md](lib/core/STYLING_GUIDE.md) for UI guidelines
3. Start building your app!

## 🐛 Troubleshooting

### "Firebase CLI not found"
```bash
npm install -g firebase-tools
```

### "flutterfire: command not found"
```bash
dart pub global activate flutterfire_cli
# Ensure ~/.pub-cache/bin is in your PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"  # Add to ~/.zshrc or ~/.bashrc
```

### "Deployment failed" or "Billing account required"
- Verify you've upgraded to the **Blaze Plan** (required for Cloud Functions)
- Run `firebase login` to re-authenticate
- Check `firebase use` shows the correct project

### "Cloud Functions build error"
```bash
cd functions
rm -rf node_modules package-lock.json
npm install
npm run build
cd ..
firebase deploy --only functions
```

### "FlutterFire configuration failed"
- Ensure Firebase project exists in Console
- Verify you've enabled required services (Auth, Firestore, Storage)
- Try running `firebase login --reauth`

### "App won't connect to Firebase"
- Check that `firebase_options.dart` was generated
- Verify platform-specific config files exist:
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`
- Rebuild the app completely: `flutter clean && flutter pub get && flutter run`

### Need More Help?

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Flutter Documentation](https://docs.flutter.dev/)
