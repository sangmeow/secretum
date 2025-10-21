# Secretum

A secure, encrypted note-taking application built with Flutter. Secretum provides PIN-based authentication and encrypted storage for your private notes.

## Features

- **PIN Authentication**: 6-digit PIN-based security system
- **Encrypted Storage**: All notes are encrypted and stored locally using Hive
- **Secure PIN Storage**: PIN is securely stored using Flutter Secure Storage
- **Clean UI**: Minimalist dark theme design
- **CRUD Operations**: Create, read, update, and delete notes
- **Automatic Timestamps**: Track creation and update times for each note
- **Native Splash Screen**: Professional app loading experience

## Screenshots

The app features a clean, dark-themed interface optimized for readability and privacy.

## Security Features

### PIN Protection
- 6-digit PIN authentication system
- First-time setup flow for new users
- Secure storage using `flutter_secure_storage`
- Encrypted PIN verification using SHA-256 hashing

### Data Encryption
- Local encrypted database using Hive
- Notes stored with encryption at rest
- No cloud storage - all data remains on device

## Tech Stack

### Core Framework
- **Flutter**: Cross-platform mobile development framework
- **Dart SDK**: ^3.9.2

### Dependencies
- `hive: ^2.2.3` - Fast, local NoSQL database
- `hive_flutter: ^1.1.0` - Flutter adapter for Hive
- `flutter_secure_storage: ^9.2.2` - Secure key-value storage
- `crypto: ^3.0.3` - Cryptographic functions for hashing
- `shared_preferences: ^2.3.3` - Simple persistent storage
- `uuid: ^4.5.1` - Unique identifier generation

### Dev Dependencies
- `flutter_native_splash: ^2.4.3` - Native splash screen generation
- `flutter_launcher_icons: ^0.14.2` - App icon configuration
- `flutter_lints: ^5.0.0` - Code quality and style enforcement

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   └── secret.dart               # Secret/Note data model
├── routes/
│   └── pin_router.dart           # PIN-based navigation router
├── screens/
│   ├── splash_screen.dart        # App splash screen
│   ├── pin_setup_page.dart       # Initial PIN setup
│   ├── pin_input_page.dart       # PIN entry/verification
│   ├── secret_list_page.dart     # Notes list view
│   ├── secret_view_page.dart     # Read-only note view
│   └── secret_edit_page.dart     # Note creation/editing
├── services/
│   ├── auth_state_service.dart   # Authentication state management
│   ├── pin_encryption_service.dart # PIN hashing and verification
│   └── encryption_key_service.dart # Encryption key management
├── utils/
│   └── pin_dots_widget.dart      # PIN input UI component
└── widgets/
    └── pin_pad.dart              # Numeric keypad widget
```

## Design System

### Color Palette
- **Background**: `#1e1e1e` - Primary dark background
- **Card/Button**: `#2c2c2c` - Secondary surface color
- **Primary Text**: `#dcdcdc` - SECRETUM brand color
- **Secondary Text**: `#f5f5f5` - White smoke
- **Accent**: Theme-based primary color

### UI Components
- Custom PIN pad with numeric keypad
- Animated PIN dots for visual feedback
- Minimalist card-based note list
- Clean form inputs with proper focus management

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK (compatible with Flutter version)
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/secretum.git
cd secretum
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate native splash screen
```bash
flutter pub run flutter_native_splash:create
```

4. Generate app icons
```bash
flutter pub run flutter_launcher_icons
```

5. Run the app
```bash
flutter run
```

### Clean Build

If you encounter issues, perform a clean build:
```bash
flutter clean
flutter pub get
flutter run
```

## Building for Production

### Android APK

Build release APK for direct installation:
```bash
flutter clean
flutter pub get
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Google Play)

Build App Bundle for Google Play Store distribution:
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

Build for iOS devices:
```bash
flutter clean
flutter pub get
flutter build ios --release
```

## Usage

### First Launch
1. App displays splash screen
2. User is prompted to set up a 6-digit PIN
3. Confirm PIN by entering it again
4. Access granted to notes list

### Daily Usage
1. Enter your 6-digit PIN
2. View all your encrypted notes
3. Tap a note to view full content
4. Create new notes with the + button
5. Edit or delete existing notes

### Note Management
- **Create**: Tap the floating + button
- **View**: Tap any note in the list
- **Edit**: Tap "Edit" button in note view
- **Delete**: Tap "Delete" button in note view (with confirmation)

## Security Considerations

- PIN is hashed using SHA-256 before storage
- Notes are encrypted in local database
- No network requests - fully offline operation
- Secure storage uses platform-specific security (Keychain on iOS, KeyStore on Android)
- All data remains on device - no cloud synchronization

## Development

### Code Style
The project follows Flutter's recommended linting rules defined in `analysis_options.yaml`.

### State Management
- Local state management using StatefulWidget
- Service-based architecture for shared functionality
- Hive for reactive data persistence

## License

This project is private and not licensed for public use.

## Version

Current version: 1.0.0+1

## Contributing

This is a private project. Contributions are not currently accepted.

## Support

For issues or questions, please contact the repository owner.
