/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A table view controller for displaying the entire contents of the database as a feed of colors.
*/

import UIKit
import CoreData
import CoreMotion

class FeedTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var checkoutDataTableView: UITableView!
    
    @IBOutlet weak var barTitle: UINavigationItem!
    let cellReuseIdentifier = "cell"
    let sharepreference = UserDefaults.standard
    var checkout_act_arr: [String] = []
    var checkout_Date: [Date] = []
    var checkin_Date: [Date] = []
    var taxi_no_list: [String] = []
    var trigger_list: [String] = []
    var motion_arr:[String] = []
    @IBOutlet weak var mode_segment: UISegmentedControl!
    @IBOutlet weak var btn_checkin: UIBarButtonItem!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Register the table view cell class and its reuse id
        
            NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name("ReloadNotification"), object: nil)
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.requestAuthorization(options: options) {
                (didAllow, error) in
                if !didAllow {
                    print("User has declined notifications")
                }
            }
            // (optional) include this line if you want to remove the extra empty cell divider lines
            // self.tableView.tableFooterView = UIView()
            if (sharepreference.object(forKey: "checkout_act_arr") != nil)  {
                checkout_act_arr = sharepreference.object(forKey: "checkout_act_arr")as! Array<String>
                
            }
            if (sharepreference.object(forKey: "checkout_date_arr") != nil)  {
                checkout_Date = sharepreference.object(forKey: "checkout_date_arr")as! Array<Date>
                
            }
            if (sharepreference.object(forKey: "checkin_time_arr") != nil)  {
                checkin_Date = sharepreference.object(forKey: "checkin_time_arr")as! Array<Date>
                
            }
            if (sharepreference.object(forKey: "checkout_taxi_arr") != nil)  {
                taxi_no_list = sharepreference.object(forKey: "checkout_taxi_arr")as! Array<String>
                
            }
            
            if (sharepreference.object(forKey: "checkout_trigger_arr") != nil)  {
                trigger_list = sharepreference.object(forKey: "checkout_trigger_arr")as! Array<String>
                
            }
        
            self.checkoutDataTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
            // This view controller itself will provide the delegate methods and row data for the table view.
            tableView.delegate = self
            tableView.dataSource = self
            if (self.sharepreference.object(forKey: "checked_in") == nil || self.sharepreference.object(forKey: "checked_in")! as! Bool == false)  {
                self.barTitle.title = ""
            }
//            let motionActivityManager = CMMotionActivityManager()
//            if CMMotionActivityManager.isActivityAvailable() {
//                motionActivityManager.queryActivityStarting(from: NSDate(timeIntervalSinceNow: -7200) as Date,
//                                                            to: Date(),
//                                                            to: OperationQueue.main) { (motionActivities, error) in
//
//                                                                for motionActivity in motionActivities! {
//                                                                    print(motionActivity)
//                                                                    let formatter = DateFormatter()
//                                                                    formatter.dateFormat = "yyyy/MM/dd HH:mm"
//                                                                    formatter.timeZone = NSTimeZone.local
//                                                                    let someDateTime = formatter.string(from: motionActivity.startDate)
//                                                                    var str = "Time: "+someDateTime+"\n"
//                                                                    str+="\nEvent:\n stationary,"
//                                                                    str+=String(motionActivity.stationary)+",walking,"+String(motionActivity.walking)+",running,"+String(motionActivity.running)+",automotive,"+String(motionActivity.automotive)+",cycling,"+String(motionActivity.cycling)
//                                                                    self.motion_arr.append(str)
//                                                                }
//
//
//                }
//
//            }
        }
        
        // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mode_segment.selectedSegmentIndex==0 {
            return checkout_act_arr.count
        } else {
            return motion_arr.count
        }
        
    }
        
        // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.mode_segment.selectedSegmentIndex==0 {
            if indexPath.row == 0 {
                sleep(2)
            }
                // create a new cell if needed or reuse an old one
                let cell:UITableViewCell = (checkoutDataTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
                let date = checkout_Date[indexPath.row]
                let inDate = checkin_Date[indexPath.row]
    //            print(date)
                // Create Date Formatter
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "HH:mm:ss d/M/Y"
                // set the text from the data model
                cell.textLabel!.lineBreakMode = .byWordWrapping
                cell.textLabel!.numberOfLines = 0
            cell.textLabel!.text = "Taxi No:      "+taxi_no_list[indexPath.row]+" \nCheckin:    "+dateFormatter.string(from: inDate)+" \nCheckout:  "+dateFormatter.string(from: date)+" \nTrigger:       "+checkout_act_arr[indexPath.row]+" \nTriggered By: "+trigger_list[indexPath.row]
                cell.textLabel!.textAlignment = .left
                
    //            print(dateFormatter.string(from: date))
                return cell
        } else {
            let cell:UITableViewCell = (checkoutDataTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
            cell.textLabel!.lineBreakMode = .byWordWrapping
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.text = motion_arr[indexPath.row]
            cell.textLabel!.textAlignment = .left
            return cell
        }
        
        }
        
        // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }
    
    @objc func reloadData() {
        print("reloadData")
        if self.mode_segment.selectedSegmentIndex==0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
               // Code you want to be delayed
                if (self.sharepreference.object(forKey: "checkout_act_arr") != nil)  {
                    self.checkout_act_arr = self.sharepreference.object(forKey: "checkout_act_arr")as! Array<String>
                    
                }
                if (self.sharepreference.object(forKey: "checkout_date_arr") != nil)  {
                    self.checkout_Date = self.sharepreference.object(forKey: "checkout_date_arr")as! Array<Date>
                    
                }
                if (self.sharepreference.object(forKey: "checkin_time_arr") != nil)  {
                    self.checkin_Date = self.sharepreference.object(forKey: "checkin_time_arr")as! Array<Date>
                    
                }
                if (self.sharepreference.object(forKey: "checkout_taxi_arr") != nil)  {
                    self.taxi_no_list = self.sharepreference.object(forKey: "checkout_taxi_arr")as! Array<String>
                    
                }
                if (self.sharepreference.object(forKey: "checkout_trigger_arr") != nil)  {
                    self.trigger_list = self.sharepreference.object(forKey: "checkout_trigger_arr")as! Array<String>
                    
                }
                self.checkoutDataTableView.reloadData()
                if (self.sharepreference.object(forKey: "checked_in") == nil || self.sharepreference.object(forKey: "checked_in")! as! Bool == false)  {
                    self.barTitle.title = ""
                }
            }
        }
    }
    
    @IBAction func reloadTableView(_ sender: Any) {
//        print(checkout_act_arr)
//        print(checkout_Date)
//        let cmOpt = CoreMotionOperation()
//        cmOpt.main()
        reloadAllData()
    }
    
    func reloadAllData() {
        if self.mode_segment.selectedSegmentIndex==0 {
            btn_checkin.title = "Checkin"
        } else {
            btn_checkin.title = "Search Time"
        }
        if self.mode_segment.selectedSegmentIndex==0 {
            if (sharepreference.object(forKey: "checkout_act_arr") != nil)  {
                checkout_act_arr = sharepreference.object(forKey: "checkout_act_arr")as! Array<String>
                
            }
            if (sharepreference.object(forKey: "checkout_date_arr") != nil)  {
                checkout_Date = sharepreference.object(forKey: "checkout_date_arr")as! Array<Date>
                
            }
            if (sharepreference.object(forKey: "checkin_time_arr") != nil)  {
                checkin_Date = sharepreference.object(forKey: "checkin_time_arr")as! Array<Date>
                
            }
            if (sharepreference.object(forKey: "checkout_taxi_arr") != nil)  {
                taxi_no_list = sharepreference.object(forKey: "checkout_taxi_arr")as! Array<String>
                
            }
            if (sharepreference.object(forKey: "checkout_trigger_arr") != nil)  {
                trigger_list = sharepreference.object(forKey: "checkout_trigger_arr")as! Array<String>
                
            }
            checkoutDataTableView.reloadData()
                
        } else {
            let motionActivityManager = CMMotionActivityManager()
            if CMMotionActivityManager.isActivityAvailable() {
                motionActivityManager.queryActivityStarting(from: NSDate(timeIntervalSinceNow: -7200) as Date,
                                                            to: Date(),
                                                            to: OperationQueue.main) { (motionActivities, error) in
                    self.motion_arr = []
                                                                for motionActivity in motionActivities! {
                                                                    print(motionActivity)
                                                                    let formatter = DateFormatter()
                                                                    formatter.dateFormat = "yyyy/MM/dd HH:mm"
                                                                    formatter.timeZone = NSTimeZone.local
                                                                    let someDateTime = formatter.string(from: motionActivity.startDate)
                                                                    var str = "Time: "+someDateTime+"\n"
                                                                    str+="\nEvent:\n stationary,"
                                                                    str+=String(motionActivity.stationary)+",walking,"+String(motionActivity.walking)+",running,"+String(motionActivity.running)+",automotive,"+String(motionActivity.automotive)+",cycling,"+String(motionActivity.cycling)
                                                                    self.motion_arr.append(str)
                                                                }
                    self.checkoutDataTableView.reloadData()
                                                                
                                                               
                }
                
            }
        }
    }
    
    
    @IBAction func checkin_sim(_ sender: Any) {
        print("Clicked")
        if self.mode_segment.selectedSegmentIndex==0 {
            if (sharepreference.object(forKey: "checked_in") == nil || sharepreference.object(forKey: "checked_in")! as! Bool == false)  {
                let alert = UIAlertController(title: "Simulation", message: "Please insert taxi number", preferredStyle: .alert)

                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.text = "AA 1234"
                }

                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                    
                    self.checkin_Taxi()
                    self.sharepreference.set(true, forKey:"checked_in")
                    self.sharepreference.set(textField?.text,forKey: "taxi_number")
                    self.barTitle.title = "In Taxi: "+(textField?.text)!
                    
                    print("Text field: \(String(describing: textField?.text))")
                }))

                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            motion_arr = []
            let startSearchDatePicker: UIDatePicker = UIDatePicker()
            startSearchDatePicker.timeZone = NSTimeZone.local
            startSearchDatePicker.frame = CGRect(x: 0, y: 0, width: 270, height: 150)
                let alertController = UIAlertController(title: "Please select a start search date\n\n", message: nil, preferredStyle: .alert)
                alertController.view.addSubview(startSearchDatePicker)
                let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    print("Selected Start Date: \(startSearchDatePicker.date)")
                    let endSearchDatePicker: UIDatePicker = UIDatePicker()
                    endSearchDatePicker.timeZone = NSTimeZone.local
                    endSearchDatePicker.frame = CGRect(x: 0, y: 0, width: 270, height: 150)
                        let alertController = UIAlertController(title: "Please select a end search date\n\n", message: nil, preferredStyle: .alert)
                        alertController.view.addSubview(endSearchDatePicker)
                        let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            print("Selected End Date: \(endSearchDatePicker.date)")
                            let motionActivityManager = CMMotionActivityManager()
                            if CMMotionActivityManager.isActivityAvailable() {
                                motionActivityManager.queryActivityStarting(from: startSearchDatePicker.date,
                                                                            to: endSearchDatePicker.date,
                                                                            to: OperationQueue.main) { (motionActivities, error) in
                                                                                
                                                                                for motionActivity in motionActivities! {
                                                                                    print(motionActivity)
                                                                                    let formatter = DateFormatter()
                                                                                    formatter.dateFormat = "yyyy/MM/dd HH:mm"
                                                                                    formatter.timeZone = NSTimeZone.local
                                                                                    let someDateTime = formatter.string(from: motionActivity.startDate)
                                                                                    var str = "Time: "+someDateTime+"\n"
                                                                                    str+="Event:\nstationary,"
                                                                                    str+=String(motionActivity.stationary)+", walking,"+String(motionActivity.walking)+", running,"+String(motionActivity.running)+", automotive,"+String(motionActivity.automotive)+", cycling,"+String(motionActivity.cycling)
                                                                                    self.motion_arr.append(str)
                                                                                }
                                    self.checkoutDataTableView.reloadData()
                                                                                
                                                                               
                                }
                                
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(selectAction)
                        alertController.addAction(cancelAction)
                    self.present(alertController, animated: true)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(selectAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true)
        }
    }
    
    func checkin_Taxi() {
        if (sharepreference.object(forKey: "checkin_time_arr") != nil)  {
            var checkout_arr = sharepreference.object(forKey: "checkin_time_arr")as! Array<Date>
            checkout_arr.append(Date())
            sharepreference.set(checkout_arr,forKey: "checkin_time_arr")
        } else {
            var checkout_arr = Array<Date>()
            checkout_arr.append(Date())
            sharepreference.set(checkout_arr,forKey: "checkin_time_arr")
        }
        
//        print(sharepreference.array(forKey: "checkin_time_arr"))
        sharepreference.set(Date(), forKey:"taxi_checkin_time")
        let cmOpt = CoreMotionOperation(callflag: "Foreground")
        cmOpt.main()
//        AppDelegate().scheduleCoreMotionBGTask()
    }
    @IBAction func modeChange(_ sender: Any) {
        NSLog("%i", self.mode_segment.selectedSegmentIndex);
        
    }
    
}
