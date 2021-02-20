/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A collection of classes, extensions, and functions for fetching, adding, and deleting feed entries from the database.
*/

import Foundation
import CoreMotion
import BackgroundTasks
class CoreMotionOperation: Operation {
    
    var counter = 0
    var uploadstr = ""
    var flag = true
    var callflag = ""
    init(callflag: String) {
        self.callflag = callflag
    }
    override func main() {
        let sharepreference = UserDefaults.standard
        let motionActivityManager = CMMotionActivityManager()
        if CMMotionActivityManager.isActivityAvailable() {
            if (sharepreference.object(forKey: "last_run_time") != nil)  {
                let q_time = sharepreference.object(forKey: "last_run_time")as! Date
                motionActivityManager.queryActivityStarting(from: q_time,
                                                            to: Date(),
                                                            to: OperationQueue.main) { (motionActivities, error) in
                                                                
                                                                for motionActivity in motionActivities! {
                                                                    print(motionActivity)
                                                                    if (motionActivity.confidence == CMMotionActivityConfidence.high  )&&(motionActivity.running||motionActivity.walking) {
                                                                        // Can directly call checkout function for real application
                                                                        // The logic below is to prevent checkout too short for testing purpose
                                                                        
//                                                                        print(motionActivity)
                                                                        if motionActivity.startDate > q_time.addingTimeInterval(5) {
                                                                            self.checkout(activity: motionActivity)
                                                                            sharepreference.set(Date(),forKey: "last_run_time")
                                                                            break
                                                                        }
                                                                    }
                                                                }
                }
            }
        }
    }
    func checkout(activity: CMMotionActivity){
        // This checkout function is for storing demo data only
        print("checkout")
//        print(activity)
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
            checkout_arr.append(sharepreference.object(forKey: "taxi_number")as! String)
            sharepreference.set(checkout_arr,forKey: "checkout_taxi_arr")
        } else {
            var checkout_arr = Array<String>()
            checkout_arr.append(sharepreference.object(forKey: "taxi_number")as! String)
            sharepreference.set(checkout_arr,forKey: "checkout_taxi_arr")
        }
        if (sharepreference.object(forKey: "checkout_trigger_arr") != nil)  {
            var checkout_arr = sharepreference.object(forKey: "checkout_trigger_arr")as! Array<String>
            checkout_arr.append(self.callflag)
            sharepreference.set(checkout_arr,forKey: "checkout_trigger_arr")
        } else {
            var checkout_arr = Array<String>()
            checkout_arr.append(self.callflag)
            sharepreference.set(checkout_arr,forKey: "checkout_trigger_arr")
        }
        sharepreference.set(false,forKey: "checked_in")
    }
}
