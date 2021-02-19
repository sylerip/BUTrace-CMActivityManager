/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A collection of classes, extensions, and functions for fetching, adding, and deleting feed entries from the database.
*/

import Foundation
import CoreData
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
//            let calendar = Calendar.current
//            print(calendar)
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
        
        
//        AppDelegate().scheduleCoreMotionBGTask()
    }
    func checkout(activity: CMMotionActivity){
        // can schuale a local notification to ask if wanna check and enter the app foreground if clicked the notification
        
        print("checkout")
        print(activity)
//        print(activity.startDate)
        BGTaskScheduler.shared.cancelAllTaskRequests()
        let sharepreference = UserDefaults.standard
        var trigger = ""
        if activity.running {
            trigger="running"
        }
        if activity.walking {
            trigger="walking"
        }
        sharepreference.set(false, forKey:"checked_in")
        
        if (sharepreference.object(forKey: "checkout_act_arr") != nil)  {
            var checkout_arr = sharepreference.object(forKey: "checkout_act_arr")as! Array<String>
            checkout_arr.append(trigger)
            sharepreference.set(checkout_arr,forKey: "checkout_act_arr")
        } else {
            var checkout_arr = Array<String>()
            checkout_arr.append(trigger)
            sharepreference.set(checkout_arr,forKey: "checkout_act_arr")
        }
        if (sharepreference.object(forKey: "checkout_date_arr") != nil)  {
            var checkout_arr = sharepreference.object(forKey: "checkout_date_arr")as! Array<Date>
            checkout_arr.append(activity.startDate)
            sharepreference.set(checkout_arr,forKey: "checkout_date_arr")
        } else {
            var checkout_arr = Array<Date>()
            checkout_arr.append(activity.startDate)
            sharepreference.set(checkout_arr,forKey: "checkout_date_arr")
        }
        if (sharepreference.object(forKey: "checkout_taxi_arr") != nil)  {
            var checkout_arr = sharepreference.object(forKey: "checkout_taxi_arr")as! Array<String>
            checkout_arr.append(sharepreference.object(forKey: "taxi_number") as! String)
            sharepreference.set(checkout_arr,forKey: "checkout_taxi_arr")
        } else {
            var checkout_arr = Array<String>()
            checkout_arr.append(sharepreference.object(forKey: "taxi_number") as! String)
            sharepreference.set(checkout_arr,forKey: "checkout_taxi_arr")
        }
        sharepreference.set(false,forKey: "checked_in")
        sharepreference.removeObject(forKey: "taxi_number")
//        FeedTableViewController().reloadData()
    }
}
