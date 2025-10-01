import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/airplay_api.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/example/ios_playground/Airplay.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/Airplay.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'com.example.ios_playground',
  ),
)
@HostApi()
abstract class AirplayApi {
  void startAirplay();
  void stopAirplay();
}
