//
//  wastereadings.swift
//  Arcskoru
//
//  Created by Group X on 02/03/17.
//
//

import UIKit

class wastereadings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var adding = 0
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    var row = 0
    @IBOutlet weak var tableview: UITableView!
    var meters = NSMutableArray()
    
    override func viewDidLoad() {
        self.titlefont()
        super.viewDidLoad()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        tableview.registerNib(UINib.init(nibName: "wastereadingscell", bundle: nil), forCellReuseIdentifier: "cell")
        print(meters)
        let Nam2BarBtnVar = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(add(_:)))
        self.navigationItem.setRightBarButtonItems([Nam2BarBtnVar], animated: true)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var spinner: UIView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func add(sender: UIBarButtonItem){
        adding = 1        
        self.performSegueWithIdentifier("gotodetail", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meters.count
    }
        
    override func viewDidAppear(animated: Bool) {
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        self.tableview.reloadData()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableview.dequeueReusableCellWithIdentifier("cell")! as! wastereadingscell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var dict = meters.objectAtIndex(indexPath.row) as! [String:AnyObject]
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        var str1 = format.dateFromString(dict["start_date"] as! String)
        var str2 = format.dateFromString(dict["end_date"] as! String)
        format.dateFormat = "MMM dd,yyyy"
        var startdate = format.stringFromDate(str1!)
        var enddate = format.stringFromDate(str2!)
        print(startdate,enddate)
        cell.duration.text = "\(startdate) - \(enddate)"
        if(dict["unit"] == nil || dict["unit"] is NSNull){
            cell.units.text = "N/A"
        }else{
            cell.units.text = "\(dict["unit"]as! String)"
        }
        
        var diverted = 0
        var generated = 0
        
        if(dict["waste_diverted"] == nil || dict["waste_diverted"] is NSNull){
            
        }else{
          diverted = dict["waste_diverted"] as! Int
        }
        
        if(dict["waste_generated"] == nil || dict["waste_generated"] is NSNull){
            
        }else{
          generated = dict["waste_generated"] as! Int
        }
        
        cell.wastedata.text = "Waste diverted: \(diverted) \nWaste generated: \(generated)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var dict = meters.objectAtIndex(indexPath.row) as! [String:AnyObject]
        if(tableView == tableview){
            let favorite = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
                let alertController = UIAlertController(title: "Delete reading", message: "Would you like to delete this reading?", preferredStyle: .Alert)
                
                let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: {
                    action in
                    dispatch_async(dispatch_get_main_queue(),{
                        self.spinner.hidden = false
                        self.view.userInteractionEnabled = false
                        self.deletereading(dict["id"] as! Int, row: indexPath.row)
                    })
                    
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
                self.row = indexPath.row
                self.adding = 0
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.performSegueWithIdentifier("gotodetail", sender: nil)
            }
            share.backgroundColor = UIColor.blueColor()
            return [share, favorite]
        }
        
        return nil
    }
    
    
    func deletereading(readingID: Int, row: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/waste/ID:%d/?recompute_score=1",credentials().domain_url,leedid,readingID))
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
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
                            self.meters.removeObjectAtIndex(row)
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                            self.tableview.reloadData()
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
    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = true
                self.view.userInteractionEnabled = true
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
            return 0.12 * UIScreen.mainScreen().bounds.size.height;
        }
        return 0.12 * UIScreen.mainScreen().bounds.size.width;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*adding = 0
        row = indexPath.row
        self.performSegueWithIdentifier("gotodetail", sender: nil)*/
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gotodetail"){
            var v = segue.destinationViewController as! wastereadingdetail
            v.meters = meters
            v.adding = adding
            v.row = row
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Waste readings"
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
