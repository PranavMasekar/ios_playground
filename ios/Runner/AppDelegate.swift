import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    let airplayImplementation = AirplayImplementation()
                
    let controller = window?.rootViewController as! FlutterViewController
                
    AirplayApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: airplayImplementation)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
