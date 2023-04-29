import UIKit
import Flutter
import flutter_local_notifications
import workmanager
import BackgroundTasks

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // Register the background task
      BackgroundTask.shared.registerBackgroundTask()
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    GeneratedPluginRegistrant.register(with: registry)}
    if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}





class BackgroundTask {
    
    static let shared = BackgroundTask()
    
    private init() {}
    
    func registerBackgroundTask() {
        let backgroundTaskIdentifier = "com.example.myapp.backgroundtask"
        
        // Register the background task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
            // This task is called by the system when it's time to run the background task
            self.handleBackgroundTask(task: task as! BGAppRefreshTask)
        }
        
        // Schedule the background task
        do {
            let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
            request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 15) // Run the task every 15 minutes
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Error scheduling background task: \(error.localizedDescription)")
        }
    }
    
    private func handleBackgroundTask(task: BGAppRefreshTask) {
        let flutterViewController = UIApplication.shared.keyWindow?.rootViewController as! FlutterViewController
        
        // Call the Flutter method
        let channel = FlutterMethodChannel(name: "com.example.myapp/background_task", binaryMessenger: flutterViewController.binaryMessenger)
        channel.invokeMethod("backgroundTask", arguments: nil) { result in
            task.setTaskCompleted(success: true)
        }
    }
    
}
