import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/healthkit_api.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/pranav/iosPlayground/HealthKitApi.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/HealthKitApi.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'com.pranav.iosPlayground',
  ),
)
class HealthSummary {
  int steps;
  double calories;
  double avgHeartRate;

  HealthSummary({
    required this.steps,
    required this.calories,
    required this.avgHeartRate,
  });
}

@HostApi()
abstract class HealthKitApi {
  @async
  HealthSummary getHealthSummary();
}
