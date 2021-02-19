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
    
    let cellReuseIdentifier = "cell"
    let sharepreference = UserDefaults.standard
    var checkout_act_arr: [String] = []
    var checkout_Date: [Date] = []
    var checkin_Date: [Date] = []
    var taxi_no_list: [String] = []
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Register the table view cell class and its reuse id
        
            NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name("ReloadNotification"), object: nil)
            
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

            self.checkoutDataTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
            // This view controller itself will provide the delegate methods and row data for the table view.
            tableView.delegate = self
            tableView.dataSource = self
        }
        
        // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkout_act_arr.count
    }
        
        // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
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
            cell.textLabel!.text = "Taxi No:      "+taxi_no_list[indexPath.row]+" \nCheckin:    "+dateFormatter.string(from: inDate)+" \nCheckout:  "+dateFormatter.string(from: date)+" \nTrigger:       "+checkout_act_arr[indexPath.row]
            cell.textLabel!.textAlignment = .left
            
//            print(dateFormatter.string(from: date))
            return cell
        }
        
        // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }
    
    @objc func reloadData() {
        print("reloadData")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
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
            self.checkoutDataTableView.reloadData()
        }
        
    }
    
    @IBAction func reloadTableView(_ sender: Any) {
//        print(checkout_act_arr)
//        print(checkout_Date)
//        let cmOpt = CoreMotionOperation()
//        cmOpt.main()
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
        checkoutDataTableView.reloadData()
    }
    
    @IBAction func checkin_sim(_ sender: Any) {
        print("Clicked")
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
            print("Text field: \(textField?.text)")
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
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
        sharepreference.set(Date(), forKey:"last_run_time")
        AppDelegate().scheduleCoreMotionBGTask()
    }
    
}
