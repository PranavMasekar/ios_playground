// pigeons/app_usage_api.dart
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/app_usage_api.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/example/ios_playground/AppUsage.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/AppUsage.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'com.example.ios_playground',
  ),
)
enum State { success, error }

class StateResult {
  final State state;
  final String message;

  StateResult(this.state, this.message);
}

class UsedApp {
  final String id;
  final String name;
  final int minutesUsed;

  UsedApp(this.id, this.name, this.minutesUsed);
}

@HostApi()
abstract class AppUsageApi {
  @async
  String? getPlatformVersion();

  @async
  List<UsedApp> getApps();

  @async
  StateResult setAppTimeLimit(String appId, int minutesUsed);
}
