import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
     
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
          
        let appUsage = AppUsageImplementation()
          
        let controller = window?.rootViewController as! FlutterViewController
          
        AppUsageApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: appUsage)
          
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
}
