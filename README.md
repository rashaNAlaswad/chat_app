# Chat App

A real-time chat application built with Flutter and Firebase. This app provides a seamless messaging experience with user authentication, real-time messaging, and a clean, responsive UI.

## 🚀 Features

- **User Authentication**: Login, registration, and password recovery
- **Real-time Messaging**: Instant chat with Firebase Firestore
- **User Discovery**: Find and chat with other users
- **Message History**: Persistent chat storage

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Firebase project setup
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd chat_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication and Firestore Database
   - Download `google-services.json` for Android and place it in `android/app/`
   - Download `GoogleService-Info.plist` for iOS and place it in `ios/Runner/`
   - Run `flutterfire configure` to generate `firebase_options.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Configuration

1. **Authentication Setup**
   - Enable Email/Password authentication in Firebase Console
   - Configure authentication providers as needed

2. **Firestore Database Setup**
   - Create a Firestore database
   - Set up security rules for your collections:
     - `users`: User profile information
     - `chatRooms`: Chat room metadata
     - `messages`: Individual chat messages

## 📁 Project Structure

```
lib/
├── core/
│   ├── common/           # Common utilities and extensions
│   ├── constants/        # App constants and configuration
│   ├── di/              # Dependency injection setup
│   ├── helper/          # Helper functions and utilities
│   ├── models/          # Data models (User, ChatRoom, ChatMessage)
│   ├── providers/       # State management providers
│   ├── router/          # Navigation and routing
│   ├── services/        # Business logic services
│   ├── theme/           # App theming and styling
│   └── utils/           # Utility functionss
├── features/
│   ├── chat/            # Chat functionality
│   ├── login/           # Authentication screens
│   ├── profile/         # User profile management
│   ├── register/        # User registration
│   └── users/           # User management
└── main.dart           # App entry point
```

### Dependencies

Key dependencies include:
- `firebase_core`: Firebase integration
- `firebase_auth`: User authentication
- `cloud_firestore`: Real-time database
- `provider`: State management
- `get_it`: Dependency injection
- `flutter_screenutil`: Responsive design