//
//  team.swift
//  LEEDOn
//
//  Created by Group X on 08/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class team: UITableViewController {
var token = UserDefaults.standard.object(forKey: "token") as! String
    var leedid = 0
    var teamarr = NSArray()
    var currentrole = ""
    var refresh = 0
    var rolesarr = NSMutableArray()
    var selectedemail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        leedid = UserDefaults.standard.integer(forKey: "leed_id")
        self.getroles(leedid)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(refresh == 1){
        leedid = UserDefaults.standard.integer(forKey: "leed_id")
        self.getroles(leedid)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        let indexPath = self.tableView.indexPathForSelectedRow
        if(indexPath != nil){
            self.tableView.deselectRow(at: indexPath!, animated:true)
        }
        
        self.navigationController?.navigationBar.backItem?.title = "More"
    }
    
    @IBAction func add(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Add new user", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            self.adduser(firstTextField.text! )
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the user email ID to add"
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func adduser(_ mailID:String){
        let payload = NSMutableString()
        payload.append("{")
        payload.append("\"user_email\":\"\(mailID)\",")
        payload.append("\"Reltyp\":\"ZRPO81\"")
        payload.append("}")
        let str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/",credentials().domain_url, leedid))
        ////print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                var jsonDictionary = NSDictionary()
                do{
                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                //print(jsonDictionary)
                }catch{
                }
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    //print("Successfully updated")
                    self.getteamdata(self.leedid)
                    
                } catch {
                    //print(error)
                }
            }
            
        }) 
        task.resume()

    }
    
    
    
    func getroles(_ leedid:Int){
        //
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/roles/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    self.rolesarr = (jsonDictionary["EtZstrRole"] as! NSArray) as! NSMutableArray
                    let temparr = NSMutableArray()
                    for i in 0..<self.rolesarr.count{
                        let dict = self.rolesarr.object(at: i) as! NSDictionary
                        if((dict["Rtitl"] as! String) .contains("ARC")){
                            temparr.add(dict)
                        }
                    }
                    self.rolesarr = temparr
                    
                    self.getteamdata(leedid)
                    
                } catch {
                    //print(error)
                }
            }
            
        }) 
        task.resume()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotoexploreview"){
            let vc = segue.destination as! teamrole
            vc.rolesarr = rolesarr
            vc.email = selectedemail
            vc.currentrole = currentrole
        }
    }

    
    func getteamdata(_ leedid:Int){
        //
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {                    
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    self.teamarr = jsonDictionary["EtTeamMembers"] as! NSArray
                    let temparr = NSMutableArray()
                    for i in 0..<self.teamarr.count{
                        let dict = self.teamarr.object(at: i) as! NSDictionary
                        if((dict["Roledescription"] as! String) .contains("ARC") || (dict["Roledescription"] as! String) .contains("PROJECT ADMIN")){
                            temparr.add(dict)
                        }
                    }
                    self.teamarr = temparr
                    
                    DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    })
                    
                } catch {
                    //print(error)
                }
            }
            
        }) 
        task.resume()

    }
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {            
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return teamarr.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 3
    }
        // #warning Incomplete implementation, return the number of rows
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if(indexPath.row == 2){
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        var dict = (teamarr.object(at: indexPath.section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let name = String(format:"%@ %@",dict["Firstname"] as! String,dict["Lastname"] as! String)
        
        if(indexPath.row == 0){
            cell?.isUserInteractionEnabled = false
        cell?.textLabel?.text = "Name"
        cell?.detailTextLabel?.text = name
        }else if(indexPath.row == 1){
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.text = "Email"
            cell?.detailTextLabel?.text = dict["email"] as? String
        }
        else if(indexPath.row == 2){
            cell?.isUserInteractionEnabled = true
            cell?.textLabel?.text = "Role Description"
            cell?.detailTextLabel?.text = (dict["Roledescription"] as! String).capitalized
            if(cell?.detailTextLabel?.text == "Project Admin"){
                cell?.isUserInteractionEnabled = false
            }
        }
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = teamarr.object(at: indexPath.section) as! NSDictionary
        selectedemail = dict["email"] as! String
        currentrole = dict["Roledescription"] as! String
        self.performSegue(withIdentifier: "gotoexploreview", sender: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
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
