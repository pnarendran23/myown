//
//  listofassets.swift
//  MySampleApp
//
//  Created by Group X on 03/11/16.
//
//

import Foundation
import UIKit

class listofassets: UIViewController, UITableViewDataSource,UITableViewDelegate {
    var assets = NSMutableDictionary()
    var token = ""
    var domain_url = ""
    var task = NSURLSessionTask()
    var timer = NSTimer()
    var isloading = false
    @IBOutlet weak var tableview: UITableView!
    var buildingarr = NSMutableArray()
    override func viewDidLoad() {
           tableview.registerNib(UINib.init(nibName: "buildingcell", bundle: nil), forCellReuseIdentifier: "assetcell")
            var datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("assetdata") as! NSData
            assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
            buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
            print("Buildings arr",buildingarr)
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return buildingarr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var currentbuilding = buildingarr[indexPath.section] as! [String:AnyObject]
        var dte = NSDate()
        var dateformat = NSDateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        var datee = dateformat.stringFromDate(dte)
        print(datee)
        
        //https://api.usgbc.org/leed/assets/LEED:1000137566/scores/?at=2016-11-07
        var currentleedid = currentbuilding["leed_id"] as! Int
        NSUserDefaults.standardUserDefaults().setInteger(currentleedid, forKey: "leed_id")
        var c = credentials()
        domain_url = c.domain_url
        self.getperformancedata(c.subscription_key, leedid: currentleedid, date: datee)
        
        
        
    }
    
    
    func getperformancedata(subscription_key:String, leedid: Int, date : String){
        var url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/",domain_url,leedid))
        print(url?.absoluteURL)
        var request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
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
                    var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "performance_data")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.buildingdetails(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()

    }
    func getcomparablesdata(subscription_key:String, leedid: Int){
        var url = NSURL.init(string: String(format: "%@comparables/",domain_url))
        print(url?.absoluteURL)
        var request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
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
                    var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "comparable_data")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }

    func getlocalcomparablesdata(subscription_key:String, leedid: Int, state: String){
        var url = NSURL.init(string:String(format: "%@comparables/?building_state=%@",domain_url,state))
        print(url?.absoluteURL)
        var request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
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
                    var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.getcomparablesdata(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }

    
    
    func buildingdetails(subscription_key:String, leedid: Int){
        var url = NSURL.init(string: String(format: "%@assets/LEED:%d/",domain_url,leedid))
        print(url?.absoluteURL)
        var request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
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
                    var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                    if let s = jsonDictionary["state"] as? String{
                    self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: s)
                    }
                    
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("assetcell", forIndexPath: indexPath) as! buildingcell        
        var arr = buildingarr[indexPath.section] as! [String:AnyObject]
        cell.leedidlbl.text = String(format: "%d",arr["leed_id"] as! Int)
        cell.namelbl.text = String(format: "%@",arr["name"] as! String)
     
        if let update = arr["updated_at"] as? String {
        var updatedate = arr["updated_at"] as! String
        var dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        var dte = dateFormat.dateFromString(updatedate)
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm"
     //  print(dateFormat.stringFromDate(dte!))
        cell.lastupdatedlbl.text = String(format: "Updated on %@",dateFormat.stringFromDate(dte!))
        }else{
            cell.lastupdatedlbl.text = "Not available"
        }
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if let date = assets["next"] as? String {
                if(isloading == false){
                var c = credentials()
            loadMoreDataFromServer(assets["next"] as! String, subscription_key: c.subscription_key)
            self.tableview.reloadData()
                }
        }
        }
    }
    
    
    func loadMoreDataFromServer(URL:String, subscription_key:String){
        var url = NSURL.init(string: URL)
        var request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        isloading = true
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                self.isloading = false
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [String:AnyObject]
                    self.assets = jsonDictionary.mutableCopy() as! NSMutableDictionary
                    var temparr = self.assets["results"] as! NSArray
                    var tempbuilding = [] as! NSMutableArray
                    for i in 0..<self.buildingarr.count {
                        tempbuilding.addObject(self.buildingarr.objectAtIndex(i))
                    }
                    for i in 0..<temparr.count {
                        tempbuilding.addObject(temparr.objectAtIndex(i))
                    }
                    self.buildingarr = tempbuilding.mutableCopy() as! NSMutableArray
                    
                    print("JSON data is",jsonDictionary)
                    self.isloading = false
                } catch {
                    print(error)
                    self.isloading = false
                }
            }
            
        }
        task.resume()

    }
    
    

    func buildingactions(subscription_key:String, leedid: Int){
        var url = NSURL.init(string: String(format: "%@assets/LEED:%d/actions/",domain_url,leedid))
        print(url?.absoluteURL)
        var request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
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
                    var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("gotodashboard", sender: nil)
                    })
                    
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    
    func checktoken(){
        if(NSUserDefaults.standardUserDefaults().objectForKey("username") != nil && NSUserDefaults.standardUserDefaults().objectForKey("password") != nil){
            var username = NSUserDefaults.standardUserDefaults().objectForKey("username")
            var password = NSUserDefaults.standardUserDefaults().objectForKey("password")
            username = "testuser@gmail.com"
            password = "initpass"
            var credential = credentials()
            var domain_url = ""
            domain_url=credential.domain_url
            print("subscription key of LEEDOn ",credential.subscription_key)
            var url = NSURL.init(string: String(format: "%@auth/login/",domain_url))
            var request = NSMutableURLRequest.init(URL: url!)
            request.HTTPMethod = "POST"
            request.addValue(credential.subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
            request.addValue("application/json", forHTTPHeaderField:"Content-type" )
            var httpbody = String(format: "{\"username\":\"%@\",\"password\":\"%@\"}",username as! String,password as! String)
            request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
            print("HEadre is ",httpbody)
            print(request.allHTTPHeaderFields)
            
            task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
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
                        print("JSON data is",jsonDictionary)
                        if(jsonDictionary.valueForKey("token_type") as! String == "Bearer"){
                            NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                            NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
                            NSUserDefaults.standardUserDefaults().setObject(jsonDictionary.valueForKey("authorization_token") as! String, forKey: "token")
                            UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
                            self.timer  = NSTimer.scheduledTimerWithTimeInterval(1800.0, target: self, selector: #selector(self.checktoken), userInfo: nil, repeats: true)
                            NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
                        }
                    } catch {
                        print(error)
                    }
                }
                
            }
            task.resume()
        }else{
            timer.invalidate()
        }
    }

    @IBAction func logout(sender: AnyObject) {
        timer.invalidate()
        self.performSegueWithIdentifier("gotologin", sender: nil)
    }
    
}
