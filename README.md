# Shake Quote App

A Flutter application that demonstrates native code integration by using device shake detection to display random motivational quotes. This app showcases how to bridge Flutter with platform-specific native code using EventChannel for real-time communication.

## Demo

Check out the live demo of the Shake Quote App: [View Demo](https://drive.google.com/file/d/1EAfVldCgn_TV8IIUKJmNCBuQQJ_2ObuO/view?usp=drive_link)

## Features

- **Native Shake Detection**: Uses platform-specific native code (Android/iOS) to detect device shake gestures
- **Real-time Communication**: Implements EventChannel for seamless communication between Flutter and native platforms
- **Animated UI**: Smooth text transitions when new quotes appear
- **Cross-platform**: Works on both Android and iOS devices

## Architecture

### Flutter Side (`lib/`)
- **`main.dart`**: Application entry point with MaterialApp setup
- **`home_view.dart`**: Main UI component that:
  - Sets up EventChannel listener for shake events
  - Manages quote display with animated transitions
  - Handles lifecycle management for event subscriptions

### Native Integration

#### EventChannel Communication
```dart
static const EventChannel _eventChannel = EventChannel('shake_event');
```

The app uses Flutter's EventChannel to establish a persistent communication channel between the Dart code and native platform code.

#### Android Integration
- **MainActivity.kt**: Extends `FlutterActivity` (standard Flutter setup)
- Native shake detection implementation (likely through accelerometer sensors)
- Sends shake events through the EventChannel to Flutter

#### iOS Integration
- **AppDelegate.swift**: Standard Flutter iOS setup
- Native shake detection using iOS motion APIs
- Forwards shake events to Flutter via EventChannel

## How It Works

1. **Shake Detection**: Native platform code monitors device accelerometer/motion sensors
2. **Event Broadcasting**: When a shake is detected, native code sends an event through the EventChannel
3. **Flutter Response**: Dart code receives the event and triggers quote display
4. **UI Update**: Animated text transition shows a new random motivational quote

## Getting Started

### Prerequisites
- Flutter SDK (^3.9.2)
- Android Studio (for Android development)
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd shake_quote_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Ensure accelerometer permissions are handled in native code
- Test on physical device for shake detection (emulator limitations)

#### iOS
- No additional permissions required for basic shake detection
- Test on physical device recommended

## Testing

Run the widget tests:
```bash
flutter test
```

## Key Concepts Demonstrated

1. **Platform Channels**: Communication between Flutter and native code
2. **EventChannel**: One-way communication from native to Flutter
3. **StreamSubscription**: Managing asynchronous event streams
4. **State Management**: Handling real-time UI updates
5. **Lifecycle Management**: Proper cleanup of event subscriptions

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **EventChannel**: Flutter platform communication
- **Android Sensors**: Accelerometer for shake detection
- **iOS Core Motion**: Motion detection APIs

## Learning Outcomes

This project demonstrates:
- How to integrate native platform features in Flutter
- Real-time communication patterns between Flutter and native code
- Proper resource management in Flutter apps
- Cross-platform development considerations
- Event-driven programming in Flutter

## Contributing

When working with native code integration:
1. Test on physical devices (emulators may not support all sensors)
2. Handle platform-specific differences appropriately
3. Ensure proper error handling for native communication
4. Document any platform-specific requirements

