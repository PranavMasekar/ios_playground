import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/live_activity_api.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/example/ios_playground/LiveActivityApi.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/LiveActivityApi.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'com.pranav.iosPlayground',
  ),
)
@HostApi()
abstract class LiveActivityApi {
  void startLiveActivity();
  void stopLiveActivity();
}
