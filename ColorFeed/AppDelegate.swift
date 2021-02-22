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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // The BGProcessingTask and BGTaskScheduler can only be run on IOS 13 or above. If the user device is lower that that, can only run at the Operation in applicationDidBecomeActive without background support
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.apple-samplecode.ColorFeed.cm_motion", using: nil) { task in
            self.handleCoreMotion(task: task as! BGProcessingTask)
        }

        return true
    }
    func applicationDidBecomeActive(_: UIApplication){
        print("call")
        let sharepreference = UserDefaults.standard
        if (sharepreference.object(forKey: "checked_in") != nil) && sharepreference.object(forKey: "checked_in")as!Bool == true {
            let cmOpt = CoreMotionOperation(callflag: "Foreground")
            cmOpt.main()
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
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60*10)
        do {
            try BGTaskScheduler.shared.submit(request)
            NotificationObj.bgTaskRegisterNotification()
        } catch {
            print("Could not schedule Task: \(error)")
        }
    }

    
    func handleCoreMotion(task: BGProcessingTask) {
        print("run BGProcessingTask")
        print(Date())
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1


        let cmOpt = CoreMotionOperation(callflag: "BGProcessTask")
        

        task.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
            queue.cancelAllOperations()
        }
        
        cmOpt.completionBlock = {
            let success = !cmOpt.isCancelled
            if success {
                // Update the last clean date to the current time.
                print("Success")
                NotificationObj.bgTaskNotification()
            }
            task.setTaskCompleted(success: success)
            let sharepreference = UserDefaults.standard
            if (sharepreference.object(forKey: "checked_in") != nil) && sharepreference.object(forKey: "checked_in")as!Bool == true {
                self.scheduleCoreMotionBGTask()
            }
            
        }
        
        queue.addOperation(cmOpt)
    }
    
}
