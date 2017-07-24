//
//  settings.swift
//  LEEDOn
//
//  Created by Group X on 09/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class settings: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate {
    @IBOutlet weak var tableview: UITableView!
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var token = UserDefaults.standard.object(forKey: "token") as! String
    
    @IBOutlet weak var tabbar: UITabBar!
    
    @IBOutlet weak var assetname: UILabel!
    
    @IBOutlet weak var spinner: UIView!
    
    var sectiontitles = NSArray()
    var valuearr = NSArray()
    var dict = NSDictionary()
    var tempdict = NSMutableDictionary()
    var email_subscription = false 
    var tempsubscrptiondata = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        let notificationsarr = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "notifications") as! Data) as! NSArray
        let plaque = UIImage.init(named: "score")
        let credits = UIImage.init(named: "Menu_icon")
        let analytics = UIImage.init(named: "chart")
        let more = UIImage.init(named: "more")
        self.tabbar.setItems([UITabBarItem.init(title: "Score", image: plaque, tag: 0),UITabBarItem.init(title: "Credits/Actions", image: credits, tag: 1),UITabBarItem.init(title: "Analytics", image: analytics, tag: 2),UITabBarItem.init(title: "More", image: more, tag: 3)], animated: false)
        if(notificationsarr.count > 0 ){

        self.tabbar.items![3].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![3].badgeValue = nil
        }
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        self.view.isUserInteractionEnabled = true
        valuearr = ["Lobby survey","Make LEED score public", "Receive email only when your score changes"]
        sectiontitles = ["Conduct a Lobby survey to gather Human experience data from people in your building","Selecting 'Yes' will show the plaque animation on the LEED Dynamic Plaque app. By selecting 'No,' the plaque animation will not be visible on the LEED Dynamic Plaque app.","Get a detailed report on every score change."]
        self.tableview.register(UINib.init(nibName: "settingscell", bundle: nil), forCellReuseIdentifier: "cell")
        
        dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        if(dict["project_type"] as! String == "city" || dict["project_type"] as! String == "community"){
            valuearr = ["Make LEED score public", "Receive email only when your score changes"]
        }
        assetname.text = dict["name"] as? String
        self.navigationItem.title = dict["name"] as? String
        tempdict = NSMutableDictionary.init(dictionary: dict)
        print(tempdict)
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            self.updateproject()
            self.getemailsubscriptionstatus()
        })        
        self.tabbar.selectedItem = self.tabbar.items![3]
        self.view.bringSubview(toFront: nav)
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Manage", style: .plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.navigationController?.navigationBar.backItem?.title = "Manage"
    }
    
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"manage"])
    }
    
    
    
    @IBOutlet weak var nav: UINavigationBar!
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.title == "Score"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"totalanalysis"])
        }else if(item.title == "Manage"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"manage"])
        }else if(item.title == "More"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"listofactions"])
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "settings"
    }
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
    func getemailsubscriptionstatus(){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/subscriptions/",credentials().domain_url,leedid))
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
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = true
                    self.spinner.isHidden = true
                })
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                
                
                do {
                        var jsonDictionary : NSDictionary
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    self.tempsubscrptiondata = jsonDictionary.mutableCopy() as! NSMutableDictionary
                    //print(self.tempsubscrptiondata)
                    if(jsonDictionary["score_change_notification"] is Bool){
                        self.email_subscription = jsonDictionary["score_change_notification"] as! Bool
                    }else if(jsonDictionary["score_change_notification"] is NSNull){
                        self.email_subscription = false
                    }else if(jsonDictionary["score_change_notification"] is Int){
                        self.email_subscription = Bool(jsonDictionary["score_change_notification"] as! NSNumber)
                    }
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                    })
                    DispatchQueue.main.async(execute: {
                        self.tableview.reloadData()
                    })
                    
                    
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                    })
                }
            }
            
        }) 
        task.resume()

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valuearr.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
            return 0.081 * UIScreen.main.bounds.size.height;
        }
        return 0.081 * UIScreen.main.bounds.size.width;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! settingscell
        cell.lbl.text = valuearr.object(at: indexPath.row) as? String
        cell.enableswitch.tag = indexPath.row
        cell.enableswitch.addTarget(self, action: #selector(settings.switchused(_:)), for: UIControlEvents.valueChanged)
        if(dict["project_type"] as! String == "city" || dict["project_type"] as! String == "community"){
            if(indexPath.row == 0){
                cell.enableswitch.isOn = tempdict["leed_score_public"] as! Bool
            }else{
                cell.enableswitch.isOn = email_subscription
            }
        }else{
        if(indexPath.row == 0){
        cell.enableswitch.isOn = tempdict["lobby_survey_status"] as! Bool
        }else if(indexPath.row == 1){
        cell.enableswitch.isOn = tempdict["leed_score_public"] as! Bool
        }else{
        cell.enableswitch.isOn = email_subscription
        }
        }
        return cell
    }
    
    func switchused(_ sender:UISwitch){
        _ = sender
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let cell = tableview.cellForRow(at: indexPath) as! settingscell
        
        if(dict["project_type"] as! String == "city" || dict["project_type"] as! String == "community"){
          if(indexPath.row == 0){
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = false
                    if(cell.enableswitch.isOn){
                        self.tempdict.setValue(true, forKey: "leed_score_public")
                    }else{
                        self.tempdict.setValue(false, forKey: "leed_score_public")
                    }
                    self.saveproject()
                })
            }else{
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = false
                })
                
                if(cell.enableswitch.isOn == true){
                    email_subscription = true
                }else{
                    email_subscription = false
                }
                if(email_subscription == false){
                }else{
                    tempsubscrptiondata.setValue("email", forKey: "stype")
                }
                tempsubscrptiondata.setValue(email_subscription, forKey: "score_change_notification")
                //print(tempsubscrptiondata)
                updatesubscription()
            }

            
            
        }else{
        if(indexPath.row == 0){
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                if(cell.enableswitch.isOn){
                    self.tempdict.setValue(true, forKey: "lobby_survey_status")
                }else{
                    self.tempdict.setValue(false, forKey: "lobby_survey_status")
                }
                self.saveproject()
            })
            
        }else if(indexPath.row == 1){
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                if(cell.enableswitch.isOn){
                    self.tempdict.setValue(true, forKey: "leed_score_public")
                }else{
                    self.tempdict.setValue(false, forKey: "leed_score_public")
                }
                self.saveproject()
            })
        }else{
            DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false              
            })
            
            if(cell.enableswitch.isOn == true){
            email_subscription = true
            }else{
                email_subscription = false
            }
            if(email_subscription == false){
            }else{
                tempsubscrptiondata.setValue("email", forKey: "stype")
            }
            tempsubscrptiondata.setValue(email_subscription, forKey: "score_change_notification")
            //print(tempsubscrptiondata)
            updatesubscription()
        }
        }
        
    }
    
    
    
    func saveproject(){
        let payload = NSMutableString()
        payload.append("{")
        for (key, value) in tempdict {
            if(value is String){
                payload.append("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
                payload.append("\"\(key)\": \(value),")
            }else if(value is Bool){
                payload.append("\"\(key)\": \(value),")
            }
        }
        var str = payload as String
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}")
        str = payload as String
        print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, leedid))
        ////print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        self.view.isUserInteractionEnabled = false
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                self.view.isUserInteractionEnabled = true
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                self.view.isUserInteractionEnabled = true
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.maketoast("Updated successfully", type: "message")
                        self.updateproject()
                        
                    })
                } catch {
                    //print(error)
                }
            }
            
        }) 
        task.resume()
        
    }
    
    
    func updatesubscription(){
        
        
        let payload = NSMutableString()
        //{"destination":"testuser@gmail.com","score_change_notification":false,"stype":"email"}
        
        
        
        payload.append("{")
        /*for (key, value) in tempsubscrptiondata {
         if(value is String){
         payload.appendString("\"\(key)\": \"\(value)\",")
         }else if(value is Int){
         payload.appendString("\"\(key)\": \(value),")
         }
         }*/
        
        
        //payload.appendString(String(format:"\"destination\": \"%@\",",tempsubscrptiondata["destination"] as! String))
        payload.append(String(format:"\"destination\": \"testuser@gmail.com\","))
        payload.append("\"score_change_notification\": \"\(tempsubscrptiondata["score_change_notification"] as! Bool)\",")
        payload.append("\"stype\": \"email\"}")
        
        
        var str = payload as String
        str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/subscriptions/",credentials().domain_url, leedid))
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
        self.view.isUserInteractionEnabled = false
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                self.view.isUserInteractionEnabled = true
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if (httpStatus!.statusCode != 200 && httpStatus!.statusCode != 201) {
                // check for http errors
                //print("statusCode should be 200, but is \(httpStatus!.statusCode)")
                //print("response = \(response)")
                do{
                    let jsonDictionary : NSDictionary
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                }catch{}
                self.view.isUserInteractionEnabled = true
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = true
                    self.tableview.reloadData()
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    DispatchQueue.main.async(execute: {
                        self.tableview.reloadData()
                        self.maketoast("Updated successfully", type: "message")
                        self.view.isUserInteractionEnabled = true
                    })
                } catch {
                    //print(error)
                }
            }
            
        }) 
        task.resume()
    }
    
    
    func updateproject(){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        self.view.isUserInteractionEnabled = false
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                self.view.isUserInteractionEnabled = true
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
            }else{
                
                self.view.isUserInteractionEnabled = true
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                    UserDefaults.standard.set(datakeyed, forKey: "building_details")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(0, forKey: "row")
                    DispatchQueue.main.async(execute: {
                        self.dict = jsonDictionary.mutableCopy() as! NSMutableDictionary
                        self.tempdict = NSMutableDictionary.init(dictionary: self.dict)
                        self.tableview.reloadData()
                        self.spinner.isHidden = true
                    })
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    //print(error)
                }
            }
            
        }) 
        task.resume()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.text = [self.rowNames objectAtIndex:section];
    lblSectionName.textColor = [UIColor lightGrayColor];
    lblSectionName.numberOfLines = 0;
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    lblSectionName.backgroundColor = [UIColor grayColor];
    
    [lblSectionName sizeToFit];*/
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
