import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    let healthKitApiImplementation = HealthKitApiImplementation()
        
    let controller = window?.rootViewController as! FlutterViewController
        
    HealthKitApiSetup.setUp(
        binaryMessenger: controller.binaryMessenger,
        api: healthKitApiImplementation
    )
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
