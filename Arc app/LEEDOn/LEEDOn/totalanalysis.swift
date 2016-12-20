//
//  totalanalysis.swift
//  LEEDOn
//
//  Created by Group X on 06/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class totalanalysis: UIViewController, UITabBarDelegate, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var addrlbl: UILabel!
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBAction func goback(sender: AnyObject) {
       self.performSegueWithIdentifier("gotoplaque", sender: nil)
    }
    var localavgarr = NSMutableArray()
    var globalavgarr = NSMutableArray()
    var currentscorearr = NSMutableArray()
    var maxscorearr = NSMutableArray()
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var assetname: UILabel!
    var domain_url = String()
    override func viewDidLoad() {
        super.viewDidLoad()
self.tabbar.selectedItem = self.tabbar.items![2]
        tableview.registerNib(UINib.init(nibName: "totalanalysiscell", bundle: nil), forCellReuseIdentifier: "totalcell")
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        assetname.text = dict["name"] as? String
        print("data",dict)
        domain_url = credentials().domain_url
        let mustring = NSMutableString()
        mustring.appendString(dict["street"] as! String)
        mustring.appendString(",\n")
        mustring.appendString(dict["state"] as! String)
        mustring.appendString(",\n")
        mustring.appendString(dict["country"] as! String)
        mustring.appendString(".")
        addrlbl.text = mustring as String
        getlocalavg(credentials().subscription_key,country: dict["country"] as! String,state: dict["state"] as! String,leedid:dict["leed_id"] as! Int)
        // Do as! String any additional setup after loading the view.
    }
    
    
    func getlocalavg(subscription_key:String,country:String,state:String,leedid:Int){
        let url = NSURL.init(string:String(format: "%@comparables/?state=%@%@",domain_url, country,state))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
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
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    if(jsonDictionary["energy_avg"] is NSNull){
                        self.localavgarr.addObject(0)
                    }else{
                        self.localavgarr.addObject(jsonDictionary["energy_avg"] as! Int)
                    }
                    if(jsonDictionary["water_avg"] is NSNull){
                        self.localavgarr.addObject(0)
                    }else{
                        self.localavgarr.addObject(jsonDictionary["water_avg"] as! Int)
                    }
                    if(jsonDictionary["waste_avg"] is NSNull){
                        self.localavgarr.addObject(0)
                    }else{
                        self.localavgarr.addObject(jsonDictionary["waste_avg"] as! Int)
                    }
                    if(jsonDictionary["transport_avg"] is NSNull){
                        self.localavgarr.addObject(0)
                    }else{
                        self.localavgarr.addObject(jsonDictionary["transport_avg"] as! Int)
                    }
                    if(jsonDictionary["human_experience_avg"] is NSNull){
                        self.localavgarr.addObject(0)
                    }else{
                        self.localavgarr.addObject(jsonDictionary["human_experience_avg"] as! Int)
                    }
                    
                   self.getglobalavg(subscription_key,leedid: leedid)
                   //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
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

    
    
    func getglobalavg(subscription_key:String,leedid:Int){
        let url = NSURL.init(string:String(format: "%@comparables/",domain_url))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    if(jsonDictionary["energy_avg"] is NSNull){
                        self.globalavgarr.addObject(0)
                    }else{
                        self.globalavgarr.addObject(jsonDictionary["energy_avg"] as! Int)
                    }
                    if(jsonDictionary["water_avg"] is NSNull){
                        self.globalavgarr.addObject(0)
                    }else{
                        self.globalavgarr.addObject(jsonDictionary["water_avg"] as! Int)
                    }
                    if(jsonDictionary["waste_avg"] is NSNull){
                        self.globalavgarr.addObject(0)
                    }else{
                        self.globalavgarr.addObject(jsonDictionary["waste_avg"] as! Int)
                    }
                    if(jsonDictionary["transport_avg"] is NSNull){
                        self.globalavgarr.addObject(0)
                    }else{
                        self.globalavgarr.addObject(jsonDictionary["transport_avg"] as! Int)
                    }
                    if(jsonDictionary["human_experience_avg"] is NSNull){
                        self.globalavgarr.addObject(0)
                    }else{
                        self.globalavgarr.addObject(jsonDictionary["human_experience_avg"] as! Int)
                    }
                    
                    self.getscores(leedid, subscription_key: subscription_key)
                    
                    //
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
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
        return globalavgarr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func getscores(leedid:Int, subscription_key:String){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/scores/",domain_url,leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                self.currentscorearr.addObject(0)
                self.currentscorearr.addObject(0)
                self.currentscorearr.addObject(0)
                self.currentscorearr.addObject(0)
                self.currentscorearr.addObject(0)
                self.maxscorearr.addObject(0)
                self.maxscorearr.addObject(0)
                self.maxscorearr.addObject(0)
                self.maxscorearr.addObject(0)
                self.maxscorearr.addObject(0)
                dispatch_async(dispatch_get_main_queue(), {
                    print(self.globalavgarr,self.localavgarr)
                    self.tableview.reloadData()
                })
                
                
            }else{
                print(data)
                var scorearr : NSDictionary
                do {
                    scorearr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(scorearr)
                    if(scorearr["scores"] != nil){
                    var jsonDictionary = scorearr["scores"] as! NSDictionary
                    
                    print(jsonDictionary)
                    if(jsonDictionary["energy"] is NSNull){
                        self.currentscorearr.addObject(0)
                    }else{
                        self.currentscorearr.addObject(jsonDictionary["energy"] as! Int)
                    }
                    if(jsonDictionary["water"] is NSNull){
                        self.currentscorearr.addObject(0)
                    }else{
                        self.currentscorearr.addObject(jsonDictionary["water"] as! Int)
                    }
                    if(jsonDictionary["waste"] is NSNull){
                        self.currentscorearr.addObject(0)
                    }else{
                        self.currentscorearr.addObject(jsonDictionary["waste"] as! Int)
                    }
                    if(jsonDictionary["transport"] is NSNull){
                        self.currentscorearr.addObject(0)
                    }else{
                        self.currentscorearr.addObject(jsonDictionary["transport"] as! Int)
                    }
                    if(jsonDictionary["human_experience"] is NSNull){
                        self.currentscorearr.addObject(0)
                    }else{
                        self.currentscorearr.addObject(jsonDictionary["human_experience"] as! String)
                    }
                    
                    jsonDictionary = scorearr["maxima"] as! NSDictionary
                    
                    if(jsonDictionary["energy"] is NSNull){
                        self.maxscorearr.addObject(0)
                    }else{
                        self.maxscorearr.addObject(jsonDictionary["energy"] as! Int)
                    }
                    if(jsonDictionary["water"] is NSNull){
                        self.maxscorearr.addObject(0)
                    }else{
                        self.maxscorearr.addObject(jsonDictionary["water"] as! Int)
                    }
                    if(jsonDictionary["waste"] is NSNull){
                        self.maxscorearr.addObject(0)
                    }else{
                        self.maxscorearr.addObject(jsonDictionary["waste"] as! Int)
                    }
                    if(jsonDictionary["transport"] is NSNull){
                        self.maxscorearr.addObject(0)
                    }else{
                        self.maxscorearr.addObject(jsonDictionary["transport"] as! Int)
                    }
                    if(jsonDictionary["human_experience"] is NSNull){
                        self.maxscorearr.addObject(0)
                    }else{
                        self.maxscorearr.addObject(jsonDictionary["human_experience"] as! Int)
                    }
                    }else{
                        self.currentscorearr.addObject(0)
                        self.currentscorearr.addObject(0)
                        self.currentscorearr.addObject(0)
                        self.currentscorearr.addObject(0)
                        self.currentscorearr.addObject(0)
                        self.maxscorearr.addObject(0)
                        self.maxscorearr.addObject(0)
                        self.maxscorearr.addObject(0)
                        self.maxscorearr.addObject(0)
                        self.maxscorearr.addObject(0)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        print(self.globalavgarr,self.localavgarr)
                        self.tableview.reloadData()
                    })
                    
                    //
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
   
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("totalcell") as! totalanalysiscell
        cell.globalavg.text = String(format: "Global average score = %d",globalavgarr.objectAtIndex(indexPath.section) as! Int)
        cell.localavg.text = String(format: "Local average score = %d",localavgarr.objectAtIndex(indexPath.section) as! Int)
        cell.typeimg.frame = CGRect(x:cell.typeimg.frame.origin.x,y:cell.typeimg.frame.origin.y,width:cell.typeimg.frame.size.height,height:cell.typeimg.frame.size.height)
                cell.typeplaque.frame = CGRect(x:cell.typeplaque.frame.origin.x,y:cell.typeplaque.frame.origin.y,width:cell.typeplaque.frame.size.height,height:cell.typeplaque.frame.size.height)
        
        if(indexPath.section == 0){
            cell.typename.text = "ENERGY"
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
            cell.typeplaque.image = UIImage.init(named: "energy_small")
            cell.typename.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            cell.outoflabal.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            cell.outoflabal.text = String(format: "%d out of %d",currentscorearr.objectAtIndex(indexPath.section) as! Int, maxscorearr.objectAtIndex(indexPath.section)as! Int)
            //cell.outoflabal.text =
        }else if(indexPath.section == 1){
            cell.typename.text = "WATER"
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
            cell.typeplaque.image = UIImage.init(named: "water_small")
            cell.typename.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
            cell.outoflabal.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
            cell.outoflabal.text = String(format: "%d out of %d",currentscorearr.objectAtIndex(indexPath.section) as! Int, maxscorearr.objectAtIndex(indexPath.section)as! Int)
        }else if(indexPath.section == 2){
            cell.typename.text = "WASTE"
            cell.typeplaque.image = UIImage.init(named: "waste_small")
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
            cell.typename.textColor = UIColor.init(red: 0.691, green: 0.789, blue: 0.762, alpha: 1)
            cell.outoflabal.textColor = UIColor.init(red: 0.691, green: 0.789, blue: 0.762, alpha: 1)
            cell.outoflabal.text = String(format: "%d out of %d",currentscorearr.objectAtIndex(indexPath.section) as! Int, maxscorearr.objectAtIndex(indexPath.section)as! Int)
        }
        else if(indexPath.section == 3){
            cell.typename.text = "TRANSPORTATION"
            cell.typeplaque.image = UIImage.init(named: "transport_small")
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
            cell.typename.textColor = UIColor.init(red: 0.876, green: 0.858, blue: 0.803, alpha: 1)
            cell.outoflabal.textColor = UIColor.init(red: 0.876, green: 0.858, blue: 0.803, alpha: 1)
            cell.outoflabal.text = String(format: "%d out of %d",currentscorearr.objectAtIndex(indexPath.section) as! Int, maxscorearr.objectAtIndex(indexPath.section)as! Int)
        }else if(indexPath.section == 4){
            cell.typename.text = "HUMAN EXPERIENCE"
            cell.typeplaque.image = UIImage.init(named: "human_small")
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
            cell.typename.textColor = UIColor.init(red: 0.901, green: 0.867, blue: 0.603, alpha: 1)
            cell.outoflabal.textColor = UIColor.init(red: 0.901, green: 0.867, blue: 0.603, alpha: 1)
            cell.outoflabal.text = String(format: "%d out of %d",currentscorearr.objectAtIndex(indexPath.section) as! Int, maxscorearr.objectAtIndex(indexPath.section)as! Int)
        }

    
    
    
        return cell
    }
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Plaque"){
            self.performSegueWithIdentifier("gotoplaque", sender: nil)
        }else if(item.title == "Credits/Actions"){
            self.performSegueWithIdentifier("gotoactions", sender: nil)
        }else if(item.title == "Manage" ){
            self.performSegueWithIdentifier("gotomanage", sender: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func nextanalysis(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoindividualanalysis", sender: nil)
    }
    
    
    
}
