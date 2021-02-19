# This is an sample app for using CMMotionActivityManager and BGProcessingTaskRequest

Use scheduled background tasks for getting CMMotionActivity and determine if checkout should be reminded.

## Main usage

```swift 
import Foundation
import CoreMotion
import BackgroundTasks
class CoreMotionOperation: Operation {
    
    var counter = 0
    var uploadstr = ""
    var flag = true
    
    override func main() {
        let sharepreference = UserDefaults.standard
        let motionActivityManager = CMMotionActivityManager()
        var now = Date()
        var act = CMMotionActivity()
        var hit_flag = false
        if CMMotionActivityManager.isActivityAvailable() {
            if (sharepreference.object(forKey: "last_run_time") != nil)  {
                var q_time = sharepreference.object(forKey: "last_run_time")as! Date
                motionActivityManager.queryActivityStarting(from: q_time,
                                                            to: Date(),
                                                            to: OperationQueue.main) { (motionActivities, error) in
                                                                
                                                                for motionActivity in motionActivities! {
                                                                    if motionActivity.confidence == CMMotionActivityConfidence.high&&(motionActivity.running||motionActivity.walking) {
                                                                        act = motionActivity
                                                                        print(act)
                                                                        hit_flag = true
                                                                    }
                                                                }
                                                                if hit_flag {
                                                                    print(q_time)
                                                                    print(act.startDate)
                                                                    var time = act.startDate
                                                                    if time > q_time.addingTimeInterval(30) {
                                                                        self.checkout(activity: act)
                                                                        sharepreference.set(act.startDate,forKey: "last_run_time")
                                                                    }
                                                                    
                                                                }
                }
            }
            
        }
    }
 
}

```

In this sample, UserDefaults is used for data storing.