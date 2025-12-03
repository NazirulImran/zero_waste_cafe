<!-- # zero_waste_cafe

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference. -->

# ZeroWaste Cafe - Flutter Version (REFERENCE CODE ONLY)

## ⚠️ CRITICAL: THIS IS REFERENCE CODE ONLY

**These files CANNOT run in Figma Make.** This environment only supports React/TypeScript.

## How to Use This Code:

1. **Install Flutter SDK** on your computer
2. **Create a new Flutter project**:
   ```bash
   flutter create zerowaste_cafe
   cd zerowaste_cafe
   ```
3. **Copy these files** into your Flutter project:
   - Copy `pubspec.yaml` to replace the default one
   - Copy all files from `lib/` into your project's `lib/` folder
4. **Get dependencies**:
   ```bash
   flutter pub get
   ```
5. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure:

```
zerowaste_cafe/
├── pubspec.yaml
└── lib/
    ├── main.dart
    ├── models/
    │   ├── food_item.dart
    │   ├── reservation.dart
    │   └── app_state.dart
    ├── screens/
    │   ├── home_screen.dart
    │   ├── food_details_screen.dart
    │   ├── reservation_confirmation_screen.dart
    │   └── profile_screen.dart
    └── widgets/
        ├── food_card.dart
        ├── add_food_modal.dart
        └── reservation_card.dart
```

## Required Dependencies:

- provider (state management)
- qr_flutter (QR code display)
- intl (date/time formatting)
- cached_network_image (image loading)

## Notes:

- This code is unverified and may contain errors
- You'll need to debug and test in a proper Flutter environment
- Images use network URLs - ensure device has internet connection
- This is a direct conversion from the React version
