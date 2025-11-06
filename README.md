# BookSwap

A Flutter application for swapping books between users, built with Firebase backend and Riverpod state management.

## Features

- **Authentication**: Email/password signup and login with email verification
- **Book Listings**: Create, read, update, and delete book listings with cover images
- **Swap Functionality**: Make swap offers, accept/reject swaps with real-time updates
- **Chat**: Real-time messaging between users after swap initiation
- **Navigation**: Bottom navigation with Browse, My Listings, Chats, and Settings
- **Settings**: Profile management, notification preferences, and logout

## Architecture

### State Management

This project uses **Riverpod** for state management. Riverpod provides:
- **Providers**: For dependency injection and singleton services
- **StreamProviders**: For real-time Firestore data streams
- **FutureProviders**: For async operations
- **StateProviders**: For simple reactive state (e.g., selected tab index)
- **StateNotifierProviders**: For complex state with business logic

#### Key State Management Patterns:

1. **Service Providers**: Singleton services exposed via `Provider`
   ```dart
   final bookServiceProvider = Provider<BookService>((ref) => BookService());
   ```

2. **Stream Providers**: Real-time data from Firestore
   ```dart
   final allBooksProvider = StreamProvider<List<Book>>((ref) {
     final bookService = ref.watch(bookServiceProvider);
     return bookService.getAllBooks();
   });
   ```

3. **Family Providers**: Parameterized providers (e.g., user-specific data)
   ```dart
   final userBooksProvider = StreamProvider.family<List<Book>, String>((ref, userId) {
     final bookService = ref.watch(bookServiceProvider);
     return bookService.getBooksByUser(userId);
   });
   ```

4. **Consumer Widgets**: Widgets that can read providers
   ```dart
   class MyWidget extends ConsumerWidget {
     Widget build(BuildContext context, WidgetRef ref) {
       final books = ref.watch(allBooksProvider);
       // ...
     }
   }
   ```

### Project Structure

```
lib/
├── Firebase/              # Firebase authentication and providers
│   ├── auth_providers.dart    # Riverpod providers for auth state
│   ├── auth_service.dart      # Authentication service
│   └── auth_wrapper.dart      # Auth state wrapper (routes based on auth)
├── Models/               # Data models
│   ├── book.dart
│   ├── chat.dart
│   ├── message.dart
│   └── swap.dart
├── Services/            # Business logic and data access
│   ├── book_providers.dart    # Riverpod providers for books
│   ├── book_service.dart      # Book CRUD operations
│   ├── chat_providers.dart    # Riverpod providers for chats
│   ├── chat_service.dart      # Chat operations
│   ├── profile_providers.dart # Riverpod providers for profiles
│   ├── profile_service.dart   # Profile operations
│   ├── swap_providers.dart    # Riverpod providers for swaps
│   └── swap_service.dart      # Swap operations
├── Screens/             # Full-screen UI components
│   ├── add_book.dart           # Add/Edit book screen
│   ├── chat_detail.dart        # Chat conversation screen
│   ├── email_verification.dart # Email verification screen
│   ├── home.dart               # Main home screen with navigation
│   ├── login.dart              # Login screen
│   ├── my_offers.dart          # My swap offers screen
│   ├── signup.dart             # Signup screen
│   └── splashscreen.dart       # Splash screen
├── Layouts/             # Reusable layout components
│   ├── bottom-navigation.dart  # Bottom navigation bar
│   ├── browse-layout.dart      # Browse books layout
│   ├── chat-layout.dart        # Chat list layout
│   ├── listing-layout.dart     # My listings layout
│   ├── settings-layout.dart    # Settings layout
│   └── top-navigation.dart     # Top app bar
└── routes/              # Navigation routing
    └── routes.dart
```

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        UI Layer                              │
│  (Screens, Layouts) - ConsumerWidgets consuming Providers   │
└──────────────────────┬──────────────────────────────────────┘
                       │ ref.watch() / ref.read()
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    State Management                          │
│  Riverpod Providers (StreamProvider, FutureProvider, etc.)  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    Service Layer                             │
│  (BookService, ChatService, SwapService, AuthService)       │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    Firebase Backend                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Firestore   │  │  Firebase    │  │  Firebase    │      │
│  │  (Database)  │  │  Auth        │  │  Storage     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘

Firestore Collections:
  - books: Book listings with userId, title, author, condition, coverImageUrl
  - swaps: Swap offers with requesterId, ownerId, bookId, status
  - chats: Chat conversations with participants array
  └── messages: Subcollection with chat messages

Data Flow:
  1. User action in UI → ref.read(serviceProvider).method()
  2. Service method → Firebase operation
  3. Firebase updates → StreamProvider emits new data
  4. UI rebuilds automatically via ref.watch()
```

## Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (included with Flutter)
- Firebase account
- Android Studio / Xcode (for mobile development)
- Git

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select existing project
3. Follow the setup wizard

### 2. Enable Firebase Services

Enable the following services in Firebase Console:

- **Authentication**: 
  - Go to Authentication → Sign-in method
  - Enable "Email/Password" provider
  - Enable "Email link (passwordless sign-in)" if desired

- **Firestore Database**:
  - Go to Firestore Database → Create database
  - Start in test mode (or use production with security rules)
  - Choose a location (e.g., us-central1)

- **Storage**:
  - Go to Storage → Get started
  - Start in test mode (or use production with security rules)

### 3. Configure Android App

1. In Firebase Console, go to Project Settings → Add app → Android
2. Register app with package name: `com.example.bookswap` (or your package name)
3. Download `google-services.json`
4. Place it in `android/app/google-services.json`
5. Add to `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.android.application")
       id("kotlin-android")
       id("com.google.gms.google-services") // Add this
   }
   ```
6. Add to `android/build.gradle.kts`:
   ```kotlin
   dependencies {
       classpath("com.google.gms:google-services:4.4.0") // Add this
   }
   ```

### 4. Configure iOS App

1. In Firebase Console, go to Project Settings → Add app → iOS
2. Register app with bundle ID: `com.example.bookswap` (or your bundle ID)
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/GoogleService-Info.plist`
5. Open `ios/Runner.xcworkspace` in Xcode
6. Ensure `GoogleService-Info.plist` is added to the Runner target

### 5. Configure Firestore Security Rules

Copy the rules from `firestore.rules` to Firebase Console:
1. Go to Firestore Database → Rules
2. Paste the rules from `firestore.rules`
3. Publish the rules

### 6. Configure Storage Security Rules

Copy the rules from `storage.rules` to Firebase Console:
1. Go to Storage → Rules
2. Paste the rules from `storage.rules`
3. Publish the rules

### 7. Create Firestore Indexes

The app requires composite indexes for queries. Deploy them:

```bash
firebase deploy --only firestore:indexes
```

Or manually create in Firebase Console:
- Collection: `swaps`
  - Fields: `ownerId` (Ascending), `status` (Ascending), `createdAt` (Descending)

## Build Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd bookswap
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

1. Follow the Firebase Setup section above
2. Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in place

### 4. Run the App

**For Android:**
```bash
flutter run
```

**For iOS:**
```bash
flutter run
```

**For a specific device:**
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

### 5. Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## Troubleshooting

### Firebase Initialization Errors

If you see Firebase initialization errors:

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check configuration files:**
   - Ensure `google-services.json` is in `android/app/`
   - Ensure `GoogleService-Info.plist` is in `ios/Runner/`
   - Verify package name/bundle ID matches Firebase project

3. **Check Firebase Console:**
   - Verify all services are enabled
   - Check that security rules are published

### Common Issues

1. **"No Firebase App '[DEFAULT]' has been created"**
   - Solution: Ensure Firebase is initialized in `main.dart` before `runApp()`

2. **"Permission denied" errors**
   - Solution: Check Firestore and Storage security rules

3. **Image upload fails**
   - Solution: Verify Storage is enabled and rules allow authenticated uploads

## Development

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Formatting Code

```bash
flutter format .
```

## Key Dependencies

- `flutter_riverpod: ^2.6.1` - State management
- `firebase_core: ^3.6.0` - Firebase core
- `firebase_auth: ^5.3.1` - Authentication
- `cloud_firestore: ^5.4.3` - Database
- `firebase_storage: ^12.3.2` - File storage
- `image_picker: ^1.1.2` - Image selection
- `shared_preferences: ^2.2.2` - Local storage

## License

This project is for educational purposes.
