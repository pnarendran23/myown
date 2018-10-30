//
//  enableandfillViewController.swift
//  Arcskoru
//
//  Created by Group X on 08/02/17.
//
//

import UIKit

class enableandfillViewControllertoadd: UIViewController, UITextFieldDelegate, UITabBarDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var spinner: UIView!
    var download_requests = [URLSession]()
    var enabled = Bool()
    var context = String()
    var prodid = String()
    var data_dict = NSMutableDictionary()
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")    
    var token = UserDefaults.standard.object(forKey: "token") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        txtfld.delegate = self
        lbl.text = context
        if(lbl.text == "Project affiliated?"){
            lbl.text = "Is project affiliated with a higher education institute?"
        }
        self.spinner.isHidden = true
        self.spinner.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        if(context == "Previously LEED Certified?"){
            txtfld.placeholder = "Enter your previous LEED ID"
            if(data_dict["ldp_old"] is NSNull || data_dict["ldp_old"] == nil){
                switchh.isOn = false
            }else{
                if(data_dict["ldp_old"] as! Int == 1){
                    switchh.isOn = true
                    if let s = data_dict["PrevCertProdId"] as? String{
                        txtfld.text = s
                    }else{
                    }
                }else{
                    switchh.isOn = false
                }
            }
        }else if(context == "Contains residential units?"){
            txtfld.placeholder = "Enter number of residential units"
            if(data_dict["IsResidential"] is NSNull || data_dict["IsResidential"] == nil){
                switchh.isOn = false
            }else{
                if(data_dict["IsResidential"] == nil){
                    
                }else{
                if(data_dict["IsResidential"] as! Int == 1){
                    switchh.isOn = true
                    if let s = data_dict["noOfResUnits"] as? String{
                        txtfld.text = s
                    }else{
                    }
                }else{
                    switchh.isOn = false
                }
                }
            }
        }else if(context == "Project affiliated?"){
            txtfld.placeholder = "Enter name of the school"
            if(data_dict["AffiliatedHigherEduIns"] is NSNull || data_dict["AffiliatedHigherEduIns"] == nil){
                switchh.isOn = false
            }else{
                if(data_dict["AffiliatedHigherEduIns"] as! Int == 1){
                    switchh.isOn = true
                    if let s = data_dict["nameOfSchool"] as? String{
                        txtfld.text = s
                    }else{
                    }
                }else{
                    switchh.isOn = false
                }
            }
        }
        
               if(switchh.isOn){
            txtfld.isEnabled = true
            txtfld.text = prodid
            txtfld.becomeFirstResponder()
        }else{
            txtfld.isEnabled = false
        }
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
        self.tabbar.selectedItem = self.tabbar.items![3]
        self.tabbar.isHidden = true
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? addnewproject {
            controller.data_dict = data_dict    // Here you pass the data back to your original view controller
        }
    }
    
    @IBOutlet weak var lbl: UILabel!

    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var txtfld: UITextField!
    @IBOutlet weak var switchh: UISwitch!
    @IBAction func yesno(_ sender: AnyObject) {
        if(context == "Previously LEED Certified?"){
        if(switchh.isOn){
            txtfld.isEnabled = true
            txtfld.becomeFirstResponder()
            data_dict["ldp_old"] = 1
        }else{
            txtfld.resignFirstResponder()
            txtfld.isEnabled = false
            txtfld.text = ""
            data_dict["ldp_old"] = 0
            data_dict["PrevCertProdId"] = ""
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                self.view.isUserInteractionEnabled = false
                //self.saveproject(0)
                self.navigationController?.popViewController(animated: true)
            })
        }
        }else if(context == "Contains residential units?"){
            if(switchh.isOn){
                txtfld.isEnabled = true
                txtfld.becomeFirstResponder()
                data_dict["IsResidential"] = 1
            }else{
                txtfld.resignFirstResponder()
                txtfld.isEnabled = false
                txtfld.text = ""
                data_dict["IsResidential"] = 0
                data_dict["noOfResUnits"] = ""
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    //self.saveproject(0)
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }else if(context == "Project affiliated?"){
            if(switchh.isOn){
                txtfld.isEnabled = true
                txtfld.becomeFirstResponder()
                data_dict["AffiliatedHigherEduIns"] = 1
            }else{
                txtfld.resignFirstResponder()
                txtfld.isEnabled = false
                txtfld.text = ""
                data_dict["AffiliatedHigherEduIns"] = 0
                data_dict["nameOfSchool"] = ""
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    //self.saveproject(0)
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.navigationController?.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(context == "Previously LEED Certified?"){
            data_dict["PrevCertProdId"] = txtfld.text
        }else if(context == "Contains residential units?"){
            data_dict["noOfResUnits"] = txtfld.text
        }else if(context == "Project affiliated?"){
            data_dict["nameOfSchool"] = txtfld.text
        }
        
             
                DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
            //self.saveproject(0)
            self.navigationController?.popViewController(animated: true)
        })
        
        return true
    }
    
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            // self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
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
    
    @IBAction func saveproject(_ selected: Int) {
        
        
        
        //print(data_dict)
        var payload = NSMutableString()
        payload.append("{")
        
        
        for (key, value) in data_dict {
            if(value is String){
                payload.append("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
                payload.append("\"\(key)\": \(value),")
            }
        }
        var str = payload as String
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}")
        str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, leedid))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        var task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                    })
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
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
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.navigationController?.delegate = nil
        //stop all download requests
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
    }
    
    func updateproject(){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        var task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                    })
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        var datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "building_details")
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.set(0, forKey: "row")
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            self.navigationController?.popViewController(animated: true)
                        })
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                        })
                    }
            }
            
        }) 
        task.resume()
        
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
