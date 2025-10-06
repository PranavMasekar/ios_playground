---
title: "Intro to Pigeon in Flutter: iOS Haptics with Swift"
slug: flutter-pigeon-ios-haptics
tags: flutter, ios, swift, pigeon, platform-channels
---

## Introduction

Platform channels let Flutter call native APIs when you need capabilities outside the framework. **Pigeon** is a tool that generates the type-safe plumbing for those calls, so you focus on APIs instead of bytes and codecs. In this post, we’ll create a tiny Pigeon API for iOS haptics, implement it in Swift, and trigger it from Flutter buttons.

## Prerequisites

- Flutter SDK installed
- Xcode set up for iOS builds
- Basic Flutter project ready

## What is Pigeon?

Pigeon generates matching Dart and host-platform (Swift/Kotlin) code from a single schema. You declare an API interface once; Pigeon outputs:
- Dart client that sends typed messages
- Swift/Kotlin protocol + setup glue to receive those messages

This eliminates manual `MethodChannel` boilerplate and reduces runtime errors.

## Define the API (Pigeon schema)

Create `pigeons/haptics.dart` describing a host API that iOS will implement. Ours exposes one method: `triggerHapticFeedback(String type)`.

```1:18:/Users/pranavmasekar/Flutter_projects/ios_playground/pigeons/haptics.dart
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/haptics.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/pranav/iosPlayground/Haptics.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/Haptics.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'com.pranav.iosPlayground',
  ),
)
@HostApi()
abstract class HapticsApi {
  void triggerHapticFeedback(String type);
}
```

The `@ConfigurePigeon` annotation tells Pigeon where to place generated files for Dart, Swift, and (optionally) Android. We’ll focus on Flutter and Swift here.

**Why an abstract `HapticsApi`?**

- Pigeon uses an abstract class as the schema for your API. Methods are declarations (no bodies) that describe the shape of calls Flutter will make to the host platform.
- `@HostApi` marks this interface as implemented on the host (iOS in our case). Pigeon will generate:
  - A concrete Dart client named `HapticsApi` that sends typed messages.
  - A Swift protocol `HapticsApi` plus a setup helper to receive those messages.
- You do not implement this Dart abstract class yourself. Instead, you implement the generated Swift protocol (`HapticsApi`) on iOS and register it.

**Method signatures and types**

- Keep signatures simple and serializable: `bool`, `int`, `double`, `String`, `Uint8List`, lists/maps, and Pigeon data classes/enums.
- Our example takes a `String type` ("Light", "Medium", "Heavy"). For stronger typing, prefer a Pigeon `enum` so both Dart and Swift enforce valid values.
- Even though the schema shows `void`, the generated Dart client method returns `Future<void>` because the call is asynchronous over a message channel.

**Channel names and namespacing**

- Pigeon composes a stable channel name using the Dart package name and API/class/method, so you don’t handcraft channel strings. You’ll see this in the generated Dart and Swift.

## Add Pigeon to dev_dependencies

```16:21:/Users/pranavmasekar/Flutter_projects/ios_playground/pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  pigeon: ^26.0.1
```

Then generate code:

```bash
dart run pigeon --input pigeons/haptics.dart
```

This creates a Dart client (`lib/haptics.dart`) and Swift protocol/setup (`ios/Runner/Haptics.swift`).

## Implement the API in Swift

Pigeon generates a Swift `HapticsApi` protocol. We implement it and choose a `UIImpactFeedbackGenerator` style based on the requested type.

```10:27:/Users/pranavmasekar/Flutter_projects/ios_playground/ios/Runner/HapticsImplementation.swift
class HapticsImplementation: HapticsApi {
    func triggerHapticFeedback(type: String) {
        let impactStyle: UIImpactFeedbackGenerator.FeedbackStyle
        
        switch type {
        case "Light":
            impactStyle = .light
        case "Medium":
            impactStyle = .medium
        case "Heavy":
            impactStyle = .heavy
        default:
            impactStyle = .medium
        }
        
        let generator = UIImpactFeedbackGenerator(style: impactStyle)
        generator.impactOccurred()
    }
}
```

Register the implementation with the generated setup so it can receive messages from Flutter.

```10:18:/Users/pranavmasekar/Flutter_projects/ios_playground/ios/Runner/AppDelegate.swift
    GeneratedPluginRegistrant.register(with: self)
      
    let hapticsAPI = HapticsImplementation()
      
    let controller = window?.rootViewController as! FlutterViewController
      
    HapticsApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: hapticsAPI)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
```

That’s all the native setup. No manual channel names or codecs needed—Pigeon generated them.

## Call it from Flutter

Use the generated Dart client to invoke haptics from UI. Here, three buttons trigger light/medium/heavy feedback.

```24:46:/Users/pranavmasekar/Flutter_projects/ios_playground/lib/home_view.dart
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadButton(
                  onPressed: () async {
                    await HapticsApi().triggerHapticFeedback('Light');
                  },
                  child: const Text('Light'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: () async {
                    await HapticsApi().triggerHapticFeedback('Medium');
                  },
                  child: const Text('Medium'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: () async {
                    await HapticsApi().triggerHapticFeedback('Heavy');
                  },
                  child: const Text('Heavy'),
                ),
              ],
            ),
```

Optionally, here’s what the generated Swift protocol + setup look like, showing the channel name Pigeon manages for you.

```88:101:/Users/pranavmasekar/Flutter_projects/ios_playground/ios/Runner/Haptics.swift
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol HapticsApi {
  func triggerHapticFeedback(type: String) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class HapticsApiSetup {
  static var codec: FlutterStandardMessageCodec { HapticsPigeonCodec.shared }
  /// Sets up an instance of `HapticsApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: HapticsApi?, messageChannelSuffix: String = "") {
```

## Run it

Build and run on an iOS device or simulator. Tap the buttons to feel the feedback.

```bash
flutter run -d ios
```

## Troubleshooting: `Haptics.swift` not visible in Xcode

If the generated `Haptics.swift` doesn’t appear in Xcode’s Project Navigator even though it exists on disk, you can work around it by creating the file in Xcode and pasting the generated contents:

- In Xcode, open the `Runner` project.
- Right‑click the `Runner` group → New File… → Swift File.
- Name it exactly `Haptics.swift` and save it under `ios/Runner/`.
- Open the generated file on disk (`ios/Runner/Haptics.swift`) and copy all contents into the newly created file in Xcode.
- In the File Inspector, ensure Target Membership includes `Runner`.
- Clean and rebuild:

```
flutter clean && flutter pub get && flutter run -d ios
```

If you regenerate with Pigeon and Xcode loses the reference again, repeat these steps.

## Wrap-up

We defined a tiny Pigeon API, generated Dart/Swift glue, implemented a Swift handler for `UIImpactFeedbackGenerator`, and invoked it from Flutter. Pigeon keeps platform channels type-safe and ergonomic, so you can focus on features instead of plumbing.

**Keep Fluttering 💙💙💙**


