//
//  listall.swift
//  LEEDOn
//
//  Created by Group X on 25/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class listall: UITableViewController, UITabBarDelegate {
    @IBOutlet var tablview: UITableView!
var dataarr = NSMutableArray()
    var selected = 0
    var id = 0
    var selectedarr = [String:AnyObject]()
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    @IBAction func addnewreading(sender: AnyObject) {
        print("Add new reading")
    }
    
    override func viewDidAppear(animated: Bool) {
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        
    }
    @IBAction func closeit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        //dataarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("selreading") as! NSData)?.mutableCopy() as! NSMutableArray
        //id = NSUserDefaults.standardUserDefaults().integerForKey("meterID")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor .blackColor()]
        tablview.registerNib(UINib.init(nibName: "customreadingcell", bundle: nil), forCellReuseIdentifier: "customreadingcell")
        tablview.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        //if(selectedarr.count>0){
          //  dataarr.replaceObjectAtIndex(selected, withObject: selectedarr)
        //}
     //   dataarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("selreading") as! NSData)?.mutableCopy() as! NSMutableArray
       // id = NSUserDefaults.standardUserDefaults().integerForKey("meterID")
        tablview.registerNib(UINib.init(nibName: "customreadingcell", bundle: nil), forCellReuseIdentifier: "customreadingcell")
        print("Selected reading", dataarr)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(dataarr.count == 0){
            return "No meters found"
        }
        return "Swipe left to edit/delete the reading"
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .Center
    
        }
    }
    
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataarr.count
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Readings"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if(segue.identifier == "gotoeditreading"){
            let vc = segue.destinationViewController as! readingvc
               vc.dataarr = selectedarr
                vc.currentindex = selected
            vc.addreading = 0
        }else if(segue.identifier == "gotoaddreading"){
            //let vc = segue.destinationViewController as! readingvc
            //vc.id = id
            //vc.addreading = 1
            let vc = segue.destinationViewController as! readingvc
                vc.listofreadings = dataarr            
            vc.id = id
            vc.addreading = 1
        }

    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var dict = dataarr.objectAtIndex(indexPath.row) as! [String:AnyObject]
        if(tableView == tablview){
         let favorite = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            let alertController = UIAlertController(title: "Delete reading", message: "Would you like to delete this reading?", preferredStyle: .Alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: {
                action in
                    self.deletereading(indexPath.row, readingID: dict["id"] as! Int)
                }
            )
            alertController.addAction(yesAction)
            
            let noaction = UIAlertAction(title: "No", style: .Cancel, handler: {
                action in
                
                }
            )
            alertController.addAction(noaction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
         }
         favorite.backgroundColor = UIColor.redColor()
         
         let share = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            self.selected = indexPath.row
            self.selectedarr = self.dataarr.objectAtIndex(indexPath.row) as! [String:AnyObject]
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("gotoeditreading", sender: nil)
         }
         share.backgroundColor = UIColor.blueColor()
         return [share, favorite]
         }
        
        return nil
    }
    
    func showalert(message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = true            
            self.view.userInteractionEnabled = true
            self.maketoast(message, type: "error")
            // self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func deletereading(row:Int, readingID:Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/ID:%d/?recompute_score=1",credentials().domain_url,leedid,id,readingID))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "DELETE"
        var httpbody = "{}"
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
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
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if(jsonDictionary["error"]![0]!["message"] != nil){
                                    self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }catch{
                            
                        }
                        
                    })
                    
                }else{
                    print(data)
                    do {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.dataarr.removeObjectAtIndex(row)
                            self.tableView.reloadData()
                        })
                        
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if(jsonDictionary["error"]![0]!["message"] != nil){
                                        self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                    }else{
                                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                    }
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }catch{
                                
                            }
                            
                        })
                        
                    }
            }
            
        }
        task.resume()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customreadingcell") as! customreadingcell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var dict = dataarr.objectAtIndex(indexPath.row) as! [String:AnyObject]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print("dates",dict["start_date"],dict["end_date"])
        var date1 = NSDate()
        var date2 = NSDate()
           date1 = dateFormatter.dateFromString(dict["start_date"] as! String)!
        date2 = dateFormatter.dateFromString(dict["end_date"] as! String)!
        print(date1, date2)
        let calendar = NSCalendar.currentCalendar()
        let twoDaysAgo = calendar.dateByAddingUnit(.Day, value: -1, toDate: date2, options: [])!
        dateFormatter.dateFormat = "d MMM yyyy"
        cell.durationlbl.text = String(format: "%@ - %@",dateFormatter.stringFromDate(date1),dateFormatter.stringFromDate(twoDaysAgo))
        cell.reading.text = String(format:"%d",dict["reading"] as! Int)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var dict = dataarr.objectAtIndex(indexPath.row) as! [String:AnyObject]
        print(dict["id"])
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addreadings(sender: AnyObject) {
            self.performSegueWithIdentifier("gotoaddreading", sender: nil)
    }
}
