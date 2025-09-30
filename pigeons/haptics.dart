import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/haptics.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/example/ios_playground/Haptics.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/Haptics.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'com.example.ios_playground',
  ),
)
@HostApi()
abstract class HapticsApi {
  void triggerHapticFeedback(String type);
}
