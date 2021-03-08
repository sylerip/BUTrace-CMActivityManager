//
//  SearchCMMotion.swift
//  ColorFeed
//
//  Created by Comp 631C on 8/3/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion


class SearchCMMotionViewController: UITableViewController {
    @IBOutlet var CMDataTableView: UITableView!
    var motion_arr:[String] = []
    let cellReuseIdentifier = "cell"
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Register the table view cell class and its reuse id
            self.CMDataTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
                    // This view controller itself will provide the delegate methods and row data for the table view.
            tableView.delegate = self
            tableView.dataSource = self
            self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//            let motionActivityManager = CMMotionActivityManager()
//            if CMMotionActivityManager.isActivityAvailable() {
//                motionActivityManager.queryActivityStarting(from: NSDate(timeIntervalSinceNow: -7200) as Date,
//                                                            to: Date(),
//                                                            to: OperationQueue.main) { (motionActivities, error) in
//                    self.motion_arr=[]
//                                                                for motionActivity in motionActivities! {
//                                                                    print(motionActivity)
//                                                                    let formatter = DateFormatter()
//                                                                    formatter.dateFormat = "yyyy/MM/dd HH:mm"
//                                                                    formatter.timeZone = NSTimeZone.local
//                                                                    let someDateTime = formatter.string(from: motionActivity.startDate)
//                                                                    var str = "Time: "+someDateTime+"\n"
//                                                                    str+="\nEvent:\n stationary,"
//                                                                    str+=String(motionActivity.stationary ?"1":"0")+",walking,"+String(motionActivity.walking ?"1":"0")+",running,"+String(motionActivity.running ?"1":"0")+",automotive,"+String(motionActivity.automotive ?"1":"0")+",cycling,"+String(motionActivity.cycling ?"1":"0")
//                                                                    self.motion_arr.append(str)
//                                                                }
//                    self.CMDataTableView.reloadData()
//
//                }
//
//            }
        let startSearchDatePicker: UIDatePicker = UIDatePicker()
        startSearchDatePicker.timeZone = NSTimeZone.local
        startSearchDatePicker.frame = CGRect(x: 10, y: 50, width: 270, height: 100)
            let alertController = UIAlertController(title: "Please select a start search date\n\n", message: nil, preferredStyle: .alert)
            alertController.view.addSubview(startSearchDatePicker)
            let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                print("Selected Start Date: \(startSearchDatePicker.date)")
                let endSearchDatePicker: UIDatePicker = UIDatePicker()
                endSearchDatePicker.timeZone = NSTimeZone.local
                endSearchDatePicker.frame = CGRect(x: 10, y: 50, width: 270, height: 100)
                    let alertController = UIAlertController(title: "Please select a end search date\n\n", message: nil, preferredStyle: .alert)
                    alertController.view.addSubview(endSearchDatePicker)
                    let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        print("Selected End Date: \(endSearchDatePicker.date)")
                        let motionActivityManager = CMMotionActivityManager()
                        if CMMotionActivityManager.isActivityAvailable() {
                            motionActivityManager.queryActivityStarting(from: startSearchDatePicker.date,
                                                                        to: endSearchDatePicker.date,
                                                                        to: OperationQueue.main) { (motionActivities, error) in
                                                                        self.motion_arr=[]
                                                                            for motionActivity in motionActivities! {
                                                                                print(motionActivity)
                                                                                let formatter = DateFormatter()
                                                                                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                                                                                formatter.timeZone = NSTimeZone.local
                                                                                let someDateTime = formatter.string(from: motionActivity.startDate)
                                                                                var str = "Time: "+someDateTime+"\n"
                                                                                str+="Event:\nstationary,"
                                                                                str+=String(motionActivity.stationary ?"1":"0")+",walking,"+String(motionActivity.walking ?"1":"0")+",running,"+String(motionActivity.running ?"1":"0")+",automotive,"+String(motionActivity.automotive ?"1":"0")+",cycling,"+String(motionActivity.cycling ?"1":"0")
                                                                                self.motion_arr.append(str)
                                                                            }
                                self.CMDataTableView.reloadData()
                                                                            
                                                                           
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
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        print("call")
        self.CMDataTableView.reloadData()
        self.refreshControl?.endRefreshing()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return motion_arr.count
       
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                // create a new cell if needed or reuse an old one
                let cell:UITableViewCell = (CMDataTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
                
    //            print(date)
                // Create Date Formatter
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "HH:mm:ss d/M/Y"
                // set the text from the data model
                cell.textLabel!.lineBreakMode = .byWordWrapping
                cell.textLabel!.numberOfLines = 0
                cell.textLabel!.text = motion_arr[indexPath.row]
                cell.textLabel!.textAlignment = .left
                
    //            print(dateFormatter.string(from: date))
                return cell
        
        
        }
    @IBAction func newSearch(_ sender: Any) {
        motion_arr = []
        let startSearchDatePicker: UIDatePicker = UIDatePicker()
        startSearchDatePicker.timeZone = NSTimeZone.local
        startSearchDatePicker.frame = CGRect(x: 10, y: 50, width: 270, height: 100)
            let alertController = UIAlertController(title: "Please select a start search date\n\n", message: nil, preferredStyle: .alert)
            alertController.view.addSubview(startSearchDatePicker)
            let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                print("Selected Start Date: \(startSearchDatePicker.date)")
                let endSearchDatePicker: UIDatePicker = UIDatePicker()
                endSearchDatePicker.timeZone = NSTimeZone.local
                endSearchDatePicker.frame = CGRect(x: 10, y: 50, width: 270, height: 100)
                    let alertController = UIAlertController(title: "Please select a end search date\n\n", message: nil, preferredStyle: .alert)
                    alertController.view.addSubview(endSearchDatePicker)
                    let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        print("Selected End Date: \(endSearchDatePicker.date)")
                        let motionActivityManager = CMMotionActivityManager()
                        if CMMotionActivityManager.isActivityAvailable() {
                            motionActivityManager.queryActivityStarting(from: startSearchDatePicker.date,
                                                                        to: endSearchDatePicker.date,
                                                                        to: OperationQueue.main) { (motionActivities, error) in
                                                                        self.motion_arr=[]
                                                                            for motionActivity in motionActivities! {
                                                                                print(motionActivity)
                                                                                let formatter = DateFormatter()
                                                                                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                                                                                formatter.timeZone = NSTimeZone.local
                                                                                let someDateTime = formatter.string(from: motionActivity.startDate)
                                                                                var str = "Time: "+someDateTime+"\n"
                                                                                str+="Event:\nstationary,"
                                                                                str+=String(motionActivity.stationary ?"1":"0")+",walking,"+String(motionActivity.walking ?"1":"0")+",running,"+String(motionActivity.running ?"1":"0")+",automotive,"+String(motionActivity.automotive ?"1":"0")+",cycling,"+String(motionActivity.cycling ?"1":"0")
                                                                                self.motion_arr.append(str)
                                                                            }
                                self.CMDataTableView.reloadData()
                                                                            
                                                                           
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
