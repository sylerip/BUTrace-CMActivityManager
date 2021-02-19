# This is an sample app for using CMMotionActivityManager and BGProcessingTaskRequest

Use scheduled background tasks for getting CMMotionActivity and determine if checkout should be reminded.

## Main usage

The code below can be pack call when checked in and the app is back to foreground or app open. Also, it can be call from BGProcessingTask. 

In this sample project, the code below is packed as an operation and called from BGProcessingTask. The operation also be called at applicationDidBecomeActive in AppDelegate.

```swift 
	let motionActivityManager = CMMotionActivityManager()
        if CMMotionActivityManager.isActivityAvailable() {
            if (sharepreference.object(forKey: "last_run_time") != nil)  {
                let q_time = sharepreference.object(forKey: "last_run_time")as! Date
                motionActivityManager.queryActivityStarting(from: q_time,
                                                            to: Date(),
                                                            to: OperationQueue.main) { (motionActivities, error) in
                                                                
                                                                for motionActivity in motionActivities! {
                                                                    if motionActivity.confidence == CMMotionActivityConfidence.high&&(motionActivity.running||motionActivity.walking) {
                                                                        // Can directly call checkout function for real application
                                                                        // Apple suggest to push a local notification to user as if they wanna checkout
                                                                        // The logic below is to prevent checkout too short for testing purpose
                                                                        
//                                                                        print(motionActivity)
                                                                        if motionActivity.startDate > q_time.addingTimeInterval(10) {
                                                                            self.checkout(activity: motionActivity)
                                                                            sharepreference.set(motionActivity.startDate,forKey: "last_run_time")
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

