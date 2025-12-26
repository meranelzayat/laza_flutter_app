# Firebase Setup Guide (Flutter)

## 1) Create Firebase Project
1. Go to Firebase Console
2. Create a new project

---

## 2) Enable Authentication (Email/Password)
1. Firebase Console → Authentication → Get started
2. Sign-in method → Enable **Email/Password**
3. Save

---

## 3) Create Firestore Database
1. Firebase Console → Firestore Database → Create database
2. Choose **Start in test mode** temporarily (for quick dev)
3. Pick a region
4. Create

> After that install `firestore.rules` for safer access.

---

## 4) Add Android App
1. Firebase Console → Project settings → Your apps → Add app → Android
2. Add your Android package name (found in `android/app/src/main/AndroidManifest.xml`)
3. Download `google-services.json`
4. Put it in:
   - `android/app/google-services.json`

---

## 5) Add iOS App (macOS only)
1. Firebase Console → Add app → iOS
2. Add Bundle ID (found in Xcode under Runner settings)
3. Download `GoogleService-Info.plist`
4. Put it in:
   - `ios/Runner/GoogleService-Info.plist`

---

## 6) Generate firebase_options.dart (FlutterFire CLI)
Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli

## 7) Configure:
flutterfire configure

## 8) Initialize Firebase in main.dart
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const LazaApp());
