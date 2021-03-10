# This is a sample app for using CMMotionActivityManager and BGProcessingTaskRequest

Use scheduled background tasks for getting CMMotionActivity and determine if checkout should be recorded.

## Main usage

The code below can be pack called when checked in and the app is back to foreground or reopened. Also, it can be called from BGProcessingTask.

In this sample project, the code below is packed as an operation and called from BGProcessingTask. The operation can also be called at applicationDidBecomeActive in AppDelegate.

```swift 
	let motionActivityManager = CMMotionActivityManager()
        if CMMotionActivityManager.isActivityAvailable() {
            if (sharepreference.object(forKey: "taxi_checkin_time") != nil)  {
                let q_time = sharepreference.object(forKey: "taxi_checkin_time")as! Date
                motionActivityManager.queryActivityStarting(from: q_time,
                                                            to: Date(),
                                                            to: OperationQueue.main) { (motionActivities, error) in
                                                                
                                                                for motionActivity in motionActivities! {
                                                                    print(motionActivity)
                                                                    if (motionActivity.confidence == CMMotionActivityConfidence.high  )&&(motionActivity.running||motionActivity.walking) {
                                                                        // may use the following logic to integrate with X-hour auto check-out
                                                                        // if motionActivity.startDate > q_time.addingTimeInterval(X-hour) {
                                                                        //     use X-hour for check-out
                                                                        //     cancel BGTaskScheduler
                                                                        //     break
                                                                        // }
//                                                                        print(motionActivity)
                                                                        if  ((i < motionActivities!.count-1 && motionActivities![i+1].startDate > motionActivities![i].startDate.addingTimeInterval(self.leadtime))||(i == motionActivities!.count-1 && Date() > motionActivities![i].startDate.addingTimeInterval(self.leadtime))) && motionActivities![i].startDate > q_time.addingTimeInterval(self.init_grace_period) {
                                                                            self.checkout(activity: motionActivities![i])
                                                                            break
                                                                        }
                                                                    }
                                                                }
                }
            }
        }
```

In this sample, UserDefaults is used for sample data storing.

## Suggested program flow

### Background Task

1. After check-in a taxi, use BGTaskScheduler to invoke queryActivityStarting 

- Check historical activities since last check

``` swift
motionActivities?.forEach { activity in
          if activity.confidence == .medium || activity.confidence == .high {
              if activity.walking {
                  * log the check-out record with (activity.startDate) *
              }  else if activity.running {
                  * log the check-out record with (activity.startDate) *
              } 
      }
```
2. If no "walking" or "running" detected, repeat step 1 (Register BGTaskScheduler)

### Foreground (after check-in a taxi)

1. when the user turns the app back to foreground, it will first check if the there are activities recorded from check-in time
- Check historical activities since last check

``` swift
motionActivities?.forEach { activity in
          if activity.confidence == .medium || activity.confidence == .high {
              if activity.walking {
                  * log the check-out record with (activity.startDate) *
              }  else if activity.running {
                  * log the check-out record with (activity.startDate) *
              } 
      }
```
2. If no "walking" or "running" detected, repeat step 1 of Background Task(Register BGTaskScheduler)

