import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    let hapticsAPI = HapticsImplementation()
      
    let controller = window?.rootViewController as! FlutterViewController
      
    HapticsApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: hapticsAPI)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
