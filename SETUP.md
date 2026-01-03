# Firebase Template Setup Guide

Follow these steps to create a new Flutter + Firebase project using this template.

## Prerequisites

- Flutter SDK installed ([Get Flutter](https://docs.flutter.dev/get-started/install))
- Firebase CLI: `npm install -g firebase-tools`
- Node.js 20+ (for Cloud Functions)
- FlutterFire CLI: `dart pub global activate flutterfire_cli`

## Step 1: Clone the Template

```bash
git clone <your-template-repo-url> my-new-app
cd my-new-app
rm -rf .git  # Remove template git history
git init     # Start fresh
```

## Step 2: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project**
3. Enter your project name and click **Continue**
4. (Optional) Enable Google Analytics
5. Click **Create Project**
6. **Upgrade to Blaze Plan** (Pay-as-you-go) for Cloud Functions

## Step 3: Enable Firebase Services

### Authentication
1. Go to **Build → Authentication**
2. Click **Get Started**
3. Enable authentication methods:
   - **Email/Password** - Toggle on
   - **Google** - Toggle on, add support email

### Firestore Database
1. Go to **Build → Firestore Database**
2. Click **Create Database**
3. Select **Production mode** (rules are already in template)
4. Choose location: **us-central1** (free tier)

### Cloud Storage
1. Go to **Build → Storage**
2. Click **Get Started**
3. Select **Production mode**
4. Choose location: **us-central1** (free tier)

## Step 4: Configure Your Flutter App

Run the FlutterFire configuration tool to connect your app:

```bash
# This generates firebase_options.dart and platform configs
flutterfire configure

# Select your project when prompted
# Select platforms: iOS, Android, Web, macOS (as needed)
```

This creates:
- `lib/firebase_options.dart` (gitignored)
- `android/app/google-services.json` (gitignored)
- `ios/Runner/GoogleService-Info.plist` (gitignored)

## Step 5: Install Dependencies

```bash
# Flutter dependencies
flutter pub get

# Cloud Functions dependencies
cd functions && npm install && cd ..
```

## Step 6: Initialize Firebase Services

Login and set your project:

```bash
# Login to Firebase
firebase login

# Set your active project
firebase use --add
# Select your project and give it an alias (e.g., "default")
```

## Step 7: Deploy to Firebase

Deploy Firestore rules, Storage rules, and Cloud Functions:

```bash
# Deploy everything
firebase deploy

# Or deploy individually:
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
firebase deploy --only functions
```

## Step 8: Test Your Setup

### Test Cloud Functions
```bash
# After deploy, you'll get a URL like:
# https://us-central1-YOUR-PROJECT.cloudfunctions.net/helloWorld

curl https://YOUR-FUNCTION-URL/helloWorld
# Should return: "Hello from Firebase!"
```

### Test Flutter App
```bash
flutter run
```

## 🔒 Security Rules

The template includes **production-ready security rules** that require authentication:

### Firestore Rules (`firestore.rules`)
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
Users can only access their own documents in the `/users/{userId}` collection.

### Storage Rules (`storage.rules`)
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
Users can only access files under their own `/users/{userId}/` path.

**Customize these rules** based on your app's data structure and access patterns.

## 🎉 You're Done!

Your Flutter + Firebase project is ready. Start building!

## Troubleshooting

**"Firebase CLI not found"**
```bash
npm install -g firebase-tools
```

**"flutterfire: command not found"**
```bash
dart pub global activate flutterfire_cli
# Add to PATH: ~/.pub-cache/bin
```

**"Deployment failed"**
- Ensure you're on Blaze (Pay-as-you-go) plan
- Check `firebase login` is authenticated
- Verify `firebase use` shows correct project

**"Cloud Functions build error"**
```bash
cd functions
npm install
npm run build
cd ..
firebase deploy --only functions
```
