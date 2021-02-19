/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app delegate submits task requests and and registers the launch handlers for the app refresh and database cleaning background tasks.
 e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.example.apple-samplecode.ColorFeed.db_cleaning"]
 e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.example.apple-samplecode.ColorFeed.cm_motion"]
 
 also add if 2 hr didnt trigger, use the min of CMActivity.starttime to checkout
 
*/

import UIKit
import BackgroundTasks
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let motionManager = CMMotionManager()
    
//    private let server: Server = MockServer()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: Registering Launch Handlers for Tasks
        
    
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.apple-samplecode.ColorFeed.cm_motion", using: nil) { task in
            // Downcast the parameter to a processing task as this identifier is used for a processing request.
            self.handleCoreMotion(task: task as! BGProcessingTask)
        }
        
//        scheduleAppRefresh()
//        scheduleCoreMotionBGTask()
        return true
    }
    func applicationDidBecomeActive(_: UIApplication){
//        NotificationCenter.default.post(name: NSNotification.Name("ReloadNotification"), object: nil)
        print("call")
        let sharepreference = UserDefaults.standard
        if (sharepreference.object(forKey: "checked_in") != nil) && sharepreference.object(forKey: "checked_in")as!Bool == true {
            let cmOpt = CoreMotionOperation()
            cmOpt.main()
            BGTaskScheduler.shared.cancelAllTaskRequests()
            AppDelegate().scheduleCoreMotionBGTask()
        }
        
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
       NotificationCenter.default.post(name: NSNotification.Name("ReloadNotification"), object: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    
    func scheduleCoreMotionBGTask() {
        print("set BGProcessingTask interval")
        print(Date())
        BGTaskScheduler.shared.cancelAllTaskRequests()
        let request = BGProcessingTaskRequest(identifier: "com.example.apple-samplecode.ColorFeed.cm_motion")
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule Task: \(error)")
        }
    }
    
    // MARK: - Handling Launch for Tasks

    
    
    func handleCoreMotion(task: BGProcessingTask) {
        print("run BGProcessingTask")
        print(Date())
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1


        let cmOpt = CoreMotionOperation()
        

        task.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
//            queue.cancelAllOperations()
        }
        
        cmOpt.completionBlock = {
            let success = !cmOpt.isCancelled
            if success {
                // Update the last clean date to the current time.
                print("Success")
                
                
            }
            
            task.setTaskCompleted(success: success)
            BGTaskScheduler.shared.cancelAllTaskRequests()
            // if checked out this one do not need to start
            self.scheduleCoreMotionBGTask()
        }
        
        queue.addOperation(cmOpt)
    }
    
}
