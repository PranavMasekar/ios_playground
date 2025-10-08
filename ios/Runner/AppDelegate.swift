import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    if #available(iOS 16.2, *) {
        let liveActivityImplementation = LiveActivityImplementation()
                
        let controller = window?.rootViewController as! FlutterViewController
                
        LiveActivityApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: liveActivityImplementation)
    }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
