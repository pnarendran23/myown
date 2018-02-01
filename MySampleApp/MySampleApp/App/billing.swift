//
//  billing.swift
//  LEEDOn
//
//  Created by Group X on 09/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class billing: UIViewController, UITabBarDelegate {

    
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var tabbar: UITabBar!
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    @IBOutlet weak var assetname: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var billingarr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        print(dict)
        self.tabbar.selectedItem = self.tabbar.items![3]
        assetname.text = dict["name"] as? String
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = false
            self.spinner.hidden = false
        })
        getbillingdetails()
        
        // Do any additional setup after loading the view.
    }
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Score"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
        }else if(item.title == "Manage"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
        }else if(item.title == "More"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
        }
}
    func getbillingdetails(){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/payments/history/",credentials().domain_url,leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.userInteractionEnabled = true
                    self.spinner.hidden = true
                })
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                print(data)
                
                do {
                    var jsonDictionary : NSDictionary
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    if(jsonDictionary["results"] is NSArray){
                        self.billingarr = jsonDictionary["results"] as! NSArray
                    }else{
                        let temp = NSArray.init(object: jsonDictionary["results"] as! NSDictionary)
                        self.billingarr = temp
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                            self.view.userInteractionEnabled = true
                            self.spinner.hidden = true
                        self.tableview.reloadData()
                    })
                    
                    
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = true
                        self.spinner.hidden = true
                    })
                }
            }
            
        }
        task.resume()
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return billingarr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")! 
        var dict = billingarr.objectAtIndex(indexPath.section) as!NSDictionary
        if(indexPath.row == 0){
            cell.textLabel?.text = "Payment Date"
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if(dict["payment_date"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
            let date = formatter.dateFromString(dict["payment_date"] as! String)
            if(date == nil){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = dict["payment_date"] as? String
            }
            }
        }else if(indexPath.row == 1){
            cell.textLabel?.text = "Order ID"
            if(dict["sap_order_id"] is NSNull){
            cell.detailTextLabel?.text = "Not available"
            }else{
            cell.detailTextLabel?.text = dict["sap_order_id"] as! String
            }
        }else if(indexPath.row == 2){
            cell.textLabel?.text = "Amount paid"
            if(dict["amount_paid"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
            cell.detailTextLabel?.text = String(format:"$%@",dict["amount_paid"] as! String)
            }
        }else if(indexPath.row == 3){
            cell.textLabel?.text = "Payment status"
            if(dict["payment_status"] is NSNull){
               cell.detailTextLabel?.text = "Not available"
            }else{
            cell.detailTextLabel?.text = (dict["payment_status"] as! String).capitalizedString
            }
        }
        
        
        return cell
    }
    

    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = true
                self.view.userInteractionEnabled = true
                self.navigationController?.popViewControllerAnimated(true)                
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
