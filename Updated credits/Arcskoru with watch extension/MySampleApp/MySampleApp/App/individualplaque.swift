//
//  ViewController.swift
//  dashboard
//
//  Created by Group X on 19/01/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class individualplaque: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var localavgscorevalue = 0
    var globalavgscorevalue = 0
    var outerscorevalue = 0
    var innerstroke = UIColor.whiteColor()
    var pageIndex = 0
    var outermaxscorevalue = 0
    var middlescorevalue = 0
    var middlemaxscorevalue = 0
    var innerscorevalue = 0
    var innermaxscorevalue = 0
    var titlevalue = ""
    var context1value = ""
    var context2value = ""
    var strokecolor = UIColor.whiteColor()
    var plaqueimg = UIImage.init(named: "energy")!
    var w = 0.8 * UIScreen.mainScreen().bounds.size.width
    var performance_data = [String:AnyObject]()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.None
        self.titlefont()
        tableview.registerNib(UINib.init(nibName: "progresscell", bundle: nil), forCellReuseIdentifier: "progresscell")
       /* print("Two")
        print(UIScreen.mainScreen().bounds.size.width)
        var v = UIScreen.mainScreen().bounds.size.width
        self.vv.frame.size.height = v
        self.vv.frame.size.width = v
        vv.localavgscorevalue = 32
        vv.globalavgscorevalue = 22
        vv.outerscorevalue = 31
        vv.outermaxscorevalue = 33        
        self.vv.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2,UIScreen.mainScreen().bounds.size.height/2);
        sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
        vv.setNeedsDisplay()
        vv.removeAllAnimations()
        vv.addUntitled1Animation()
         */
        performance_data = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("performance_data") as! NSData) as! [String:AnyObject]
        self.view.backgroundColor = UIColor.blackColor()
        self.vv.backgroundColor = UIColor.clearColor()
        self.vv.setNeedsDisplay()
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
            var v = UIScreen.mainScreen().bounds.size.width
            self.vv.frame.size.height = v
            self.vv.frame.size.width = v
        }else{
            var v = UIScreen.mainScreen().bounds.size.height
            self.vv.frame.size.height = v
            self.vv.frame.size.width = v
        }
       
        
        
        sview.scrollEnabled = true
        self.vv.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2,UIScreen.mainScreen().bounds.size.height/2);
        sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
        self.vv.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2,UIScreen.mainScreen().bounds.size.height/3.6);
        self.tableview.frame.origin.y = 1.3 * (self.vv.center.y + self.vv.frame.size.height)
        self.tableview.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2,self.vv.center.y + (self.vv.frame.size.height * 1));
        self.tableview.frame.size.height = 3 * (0.095 * self.view.frame.size.height)
        if(titlevalue.lowercaseString.containsString("human")){
        self.tableview.frame.size.height = 6 * (0.095 * self.view.frame.size.height)
        }
        sview.contentSize =  CGSizeMake(UIScreen.mainScreen().bounds.size.width, (self.vv.frame.size.height + self.tableview.frame.size.height ))
        self.tableview.scrollEnabled = false
        
        
        vv.localavgscorevalue = localavgscorevalue
        vv.globalavgscorevalue = globalavgscorevalue
        vv.outermaxscorevalue = outermaxscorevalue
        vv.outerscorevalue = outerscorevalue
        vv.middlescorevalue = middlescorevalue
        vv.middlemaxscorevalue = middlemaxscorevalue
        vv.innerscorevalue = innerscorevalue
        vv.titlevalue = titlevalue
        vv.innerstrokes = innerstroke
        vv.context1value = context1value
        vv.context2value = context2value
        vv.strokecolor = strokecolor
        vv.categoryimg = plaqueimg
        vv.innermaxscorevalue = innermaxscorevalue
        vv.removeAllAnimations()
        vv.addUntitled1Animation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 0.095 * self.view.frame.size.height
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0.067 * self.view.frame.size.height
        }
        return 0.020 * self.view.frame.size.height
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.006 * self.view.frame.size.height
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "category scores"
        }
        return ""
    }

    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if(titlevalue.lowercaseString.containsString("human")){
        return 4
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("progresscell") as! progresscell
        if(titlevalue.lowercaseString.containsString("energy")){
            cell.vv.strokecolor = strokecolor
            if(performance_data["energy"] == nil || performance_data["energy"] is NSNull){
                cell.vv.strokevalue = 0.0
                cell.percentagelbl.text = "0"
                cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Energy score (Out of 100)"
            }else{
            cell.vv.strokevalue = Double(performance_data["energy"] as! Float)/100.0
                cell.percentagelbl.text = String(format: "%d",Int(performance_data["energy"] as! Float))
                cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Energy score (Out of 100)"
            }
        }else if(titlevalue.lowercaseString.containsString("water")){
            cell.vv.strokecolor = strokecolor
            if(performance_data["water"] == nil || performance_data["water"] is NSNull){
                cell.vv.strokevalue = 0.0
                cell.percentagelbl.text = "0"
                cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Water score (Out of 100)"
            }else{
                cell.vv.strokevalue = Double(performance_data["water"] as! Float)/100.0
                cell.percentagelbl.text = String(format: "%d",Int(performance_data["water"] as! Float))
                cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Water score (Out of 100)"
            }
        }
        else if(titlevalue.lowercaseString.containsString("waste")){
            cell.vv.strokecolor = strokecolor
            if(performance_data["waste"] == nil || performance_data["waste"] is NSNull){
                cell.vv.strokevalue = 0.0
                cell.percentagelbl.text = "0"
                cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Waste score (Out of 100)"
            }else{
                cell.percentagelbl.text = String(format: "%d",Int(performance_data["waste"] as! Float))
                cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Waste score (Out of 100)"
                cell.vv.strokevalue = Double(performance_data["waste"] as! Double)/100.0
            }
        }else if(titlevalue.lowercaseString.containsString("transport")){
            cell.vv.strokecolor = strokecolor
            if(performance_data["transport"] == nil || performance_data["transport"] is NSNull){
                cell.vv.strokevalue = 0.0
                cell.percentagelbl.text = "0"
                cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Transportation score (Out of 100)"
            }else{
                cell.vv.strokevalue = Double(performance_data["transport"] as! Float)/100.0
                cell.percentagelbl.text = String(format: "%d",Int(performance_data["transport"] as! Float))
                cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Transportation score (Out of 100)"
            }
        }else if(titlevalue.lowercaseString.containsString("human")){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCellWithIdentifier("progresscell") as! progresscell
                cell.vv.strokecolor = strokecolor
                if(performance_data["human_experience"] == nil || performance_data["human_experience"] is NSNull){
                    cell.vv.strokevalue = 0.0
                    cell.percentagelbl.text = "0"
                    cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Human experience score (Out of 100)"
                }else{
                    cell.vv.strokevalue = Double(performance_data["human_experience"] as! Float)/100.0
                    cell.percentagelbl.text = String(format: "%d",Int(performance_data["human_experience"] as! Float))
                    cell.contextlbl.text = "\(cell.percentagelbl.text! as! String)% of Human experience score (Out of 100)"
                }
                cell.vv.addUntitled1Animation()
                return cell
            }
            else if(indexPath.row == 1){
                let cell = tableView.dequeueReusableCellWithIdentifier("progresscell") as! progresscell
                if(satisfactionlevel == 0){
                    cell.vv.strokevalue = 0.0
                    cell.percentagelbl.text = "0"
                    cell.contextlbl.text = "% of Occupant satisfaction score (Out of 100)"
                }else{
                    cell.vv.strokevalue = Double(satisfactionlevel)/100.0
                    cell.percentagelbl.text = String(format: "%d",Int(satisfactionlevel))
                    cell.contextlbl.text = "% of Occupant satisfaction (Out of 100)"
                }
                cell.vv.strokecolor = strokecolor
                cell.vv.addUntitled1Animation()
                return cell
            }else if(indexPath.row == 2){
                let cell = tableView.dequeueReusableCellWithIdentifier("progresscell") as! progresscell
                cell.vv.strokecolor = strokecolor
                if(co2 == 0){
                    cell.vv.strokevalue = 0.0
                    cell.percentagelbl.text = "0"
                    cell.contextlbl.text = "% of CO2 level score (Out of 100)"
                }else{
                    cell.vv.strokevalue = Double(co2)/100.0
                    cell.percentagelbl.text = String(format: "%d",Int(co2))
                    cell.contextlbl.text = "% of CO2 level score (Out of 100)"
                }
                cell.vv.strokecolor = strokecolor
                cell.vv.addUntitled1Animation()
                return cell
            }else if(indexPath.row == 3){
                let cell = tableView.dequeueReusableCellWithIdentifier("progresscell") as! progresscell
                cell.vv.strokecolor = strokecolor
                if(voc == 0){
                    cell.vv.strokevalue = 0.0
                    cell.percentagelbl.text = "0"
                    cell.contextlbl.text = "% of Total VOC level score (Out of 100)"
                }else{
                    cell.vv.strokevalue = Double(voc)/100.0
                    cell.percentagelbl.text = String(format: "%d",Int(voc))
                    cell.contextlbl.text = "% of Total VOC level score (Out of 100)"
                }
                cell.vv.strokecolor = strokecolor
                cell.vv.addUntitled1Animation()
                return cell
            }

        }
        cell.vv.addUntitled1Animation()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"totalanalysis"])
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.sview.setContentOffset(CGPointMake(0, 0), animated: true)        
        if(titlevalue.lowercaseString.containsString("human")){
            getanalysis(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), token: NSUserDefaults.standardUserDefaults().objectForKey("token") as! String)
        }else{
        tableview.reloadData()
        }
    }
    
    
    
    
    func getanalysis(leedid:Int,token:String){
        let url = NSURL(string: "\(credentials().domain_url)assets/LEED:\(leedid)/analysis/")
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        
        
        let tasky = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            var taskerror = false
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    //self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }else{
                
                
                if error == nil {
                    
                    
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        //print("Data",jsonDictionary)
                        if(jsonDictionary["human"] == nil || jsonDictionary["human"] is NSNull){
                            
                        }else{
                            var humandict = jsonDictionary["human"] as! [String:AnyObject]
                            if(humandict["info_json"] == nil || humandict["info_json"] is NSNull){
                                
                            }else{
                                dispatch_async(dispatch_get_main_queue(), {
                                    var tempdata = humandict["info_json"] as! String
                                    tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                                    tempdata = tempdata.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
                                    print(tempdata)
                                    var json = [String:AnyObject]()
                                    if(self.convertStringToDictionary(tempdata) != nil){
                                        json = self.convertStringToDictionary(tempdata)! as! [String:AnyObject]
                                    }
                                    //print("Info json",json)
                                    if(self.convertStringToDictionary(tempdata) != nil){
                                        if(json["Human Experience Subscores (out of 100, weighted equally)"]!["occupant_satisfaction"] != nil && json["Human Experience Subscores (out of 100, weighted equally)"]!["occupant_satisfaction"] as? String != "None"){
                                            if let date = json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as? Float {
                                                self.satisfactionlevel = Double(json["Human Experience Subscores (out of 100, weighted equally)"]!["occupant_satisfaction"] as! Float)
                                            }
                                            
                                            if let date = json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as? Int {
                                                self.satisfactionlevel = Double(json["Human Experience Subscores (out of 100, weighted equally)"]!["occupant_satisfaction"] as! Int)
                                            }
                                            
                                        }
                                        if(json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] != nil && json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as? String != "None"){
                                            
                                            if let date = json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as? String {
                                                
                                            }
                                            if let date = json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as? Float {
                                                self.co2 = Double(json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as! Float)
                                            }
                                            
                                            if let date = json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as? Int {
                                                self.co2 = Double(json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as! Int)
                                            }
                                        }
                                        if(json["Human Experience Subscores (out of 100, weighted equally)"]!["voc"] != nil){
                                            
                                            if let date = json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as? Float {
                                                self.voc = Double(json["Human Experience Subscores (out of 100, weighted equally)"]!["voc"] as! Float)
                                            }
                                            
                                            if let date = json["Human Experience Subscores (out of 100, weighted equally)"]!["co2"] as? Int {
                                                self.voc = Double(json["Human Experience Subscores (out of 100, weighted equally)"]!["voc"] as! Int)
                                            }
                                            
                                            
                                        }
                                        print("Info json",json["Human Experience Inputs"]!["voc"],json["Human Experience Inputs"]!["co2"],json["Human Experience Subscores (out of 100, weighted equally)"]!["occupant_satisfaction"])
                                    }
                                    
                                    self.tableview.reloadData()
                                })
                            }
                        }
                    } catch {
                        //print(error)
                    }
                    
                    
                } else {
                    taskerror = true
                }
            }
        })                
        tasky.resume()
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    var voc = Double(0)
    var satisfactionlevel = Double(0)
    var co2 = Double(0)
    
    @IBOutlet weak var vv: individual!
    @IBOutlet weak var sview: UIScrollView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

