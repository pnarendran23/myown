//
//  team.swift
//  LEEDOn
//
//  Created by Group X on 08/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class team: UITableViewController {
var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    var leedid = 0
    var teamarr = NSArray()
    var currentrole = ""
    var refresh = 0
    var rolesarr = NSMutableArray()
    var selectedemail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
        self.getroles(leedid)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        if(refresh == 1){
        leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
        self.getroles(leedid)
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        let indexPath = self.tableView.indexPathForSelectedRow
        if(indexPath != nil){
            self.tableView.deselectRowAtIndexPath(indexPath!, animated:true)
        }
        
        
    }
    
    @IBAction func add(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add New user", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            self.adduser(firstTextField.text! )
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the user email ID to add"
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func adduser(mailID:String){
        let payload = NSMutableString()
        payload.appendString("{")
        payload.appendString("\"user_email\":\"\(mailID)\",")
        payload.appendString("\"Reltyp\":\"ZRPO81\"")
        payload.appendString("}")
        let str = payload as String
        print(str)
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/teams/",credentials().domain_url, leedid))
        print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        
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
                var jsonDictionary = NSDictionary()
                do{
                jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                print(jsonDictionary)
                }catch{
                }
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    print("Successfully updated")
                    self.getteamdata(self.leedid)
                    
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()

    }
    
    
    
    func getroles(leedid:Int){
        //
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/teams/roles/",credentials().domain_url,leedid))
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
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    self.rolesarr = (jsonDictionary["EtZstrRole"] as! NSArray).mutableCopy() as! NSMutableArray
                    let temparr = NSMutableArray()
                    for i in 0..<self.rolesarr.count{
                        let dict = self.rolesarr.objectAtIndex(i) as! NSDictionary
                        if((dict["Rtitl"] as! String) .containsString("ARC")){
                            temparr.addObject(dict)
                        }
                    }
                    self.rolesarr = temparr
                    
                    self.getteamdata(leedid)
                    
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gotoexploreview"){
            let vc = segue.destinationViewController as! teamrole
            vc.rolesarr = rolesarr
            vc.email = selectedemail
            vc.currentrole = currentrole
        }
    }

    
    func getteamdata(leedid:Int){
        //
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/teams/",credentials().domain_url,leedid))
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
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    self.teamarr = jsonDictionary["EtTeamMembers"] as! NSArray
                    let temparr = NSMutableArray()
                    for i in 0..<self.teamarr.count{
                        let dict = self.teamarr.objectAtIndex(i) as! NSDictionary
                        if((dict["Roledescription"] as! String) .containsString("ARC") || (dict["Roledescription"] as! String) .containsString("PROJECT ADMIN")){
                            temparr.addObject(dict)
                        }
                    }
                    self.teamarr = temparr
                    
                    dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    })
                    
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()

    }
    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {                
                self.view.userInteractionEnabled = true
                self.navigationController?.popViewControllerAnimated(true)
                
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return teamarr.count
    }
    
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 3
    }
        // #warning Incomplete implementation, return the number of rows
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if(indexPath.row == 2){
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        var dict = teamarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        let name = String(format:"%@ %@",dict["Firstname"] as! String,dict["Lastname"] as! String)
        
        if(indexPath.row == 0){
            cell?.userInteractionEnabled = false
        cell?.textLabel?.text = "Name"
        cell?.detailTextLabel?.text = name
        }else if(indexPath.row == 1){
            cell?.userInteractionEnabled = false
            cell?.textLabel?.text = "Email"
            cell?.detailTextLabel?.text = dict["email"] as? String
        }
        else if(indexPath.row == 2){
            cell?.userInteractionEnabled = true
            cell?.textLabel?.text = "Role Description"
            cell?.detailTextLabel?.text = (dict["Roledescription"] as! String).capitalizedString
            if(cell?.detailTextLabel?.text == "Project Admin"){
                cell?.userInteractionEnabled = false
            }
        }
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let dict = teamarr.objectAtIndex(indexPath.section) as! NSDictionary
        selectedemail = dict["email"] as! String
        currentrole = dict["Roledescription"] as! String
        self.performSegueWithIdentifier("gotoexploreview", sender: nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
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

}
