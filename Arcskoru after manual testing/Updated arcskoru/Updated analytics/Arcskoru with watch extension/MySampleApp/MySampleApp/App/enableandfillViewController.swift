//
//  enableandfillViewController.swift
//  Arcskoru
//
//  Created by Group X on 08/02/17.
//
//

import UIKit

class enableandfillViewController: UIViewController, UITextFieldDelegate, UITabBarDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var spinner: UIView!
    var download_requests = [URLSession]()
    var enabled = Bool()
    var context = String()
    var prodid = String()
    var data_dict = NSMutableDictionary()
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")    
    var token = UserDefaults.standard.object(forKey: "token") as! String
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.navigationController?.navigationBar.backItem?.title = "Manage project"
    }
    
    func rightbuttonclick(_ sender : UIBarButtonItem){
        if(context == "Previously LEED Certified?"){
            data_dict["PrevCertProdId"] = nil
            if(switchh.isOn){
                if(s == "ldp_old"){
                data_dict[s] = 1
                }else{
                    data_dict[s] = true
                }
                data_dict["PrevCertProdId"]  = txtfld.text
            }else{
                if(s == "ldp_old"){
                data_dict[s] = 0
                }else{
                    data_dict[s] = false
                }
                data_dict["PrevCertProdId"]  = ""
            }
        }else if(context == "Contains residential units?"){
            if(switchh.isOn){
                data_dict["IsResidential"] = 1
                data_dict["noOfResUnits"] = Int(txtfld.text!)!
            }else{
                data_dict["IsResidential"] = 0
                data_dict["noOfResUnits"] = nil
                data_dict["noOfResUnits"] = ""
            }
            
        }else if(context == "Project affiliated?"){
            if(switchh.isOn){
                data_dict["AffiliatedHigherEduIns"] = 1
                data_dict["nameOfSchool"] = txtfld.text
            }else{
                data_dict["AffiliatedHigherEduIns"] = 0
                data_dict["nameOfSchool"] = nil
                data_dict["nameOfSchool"] = ""
                
            }
            
        }
            self.navigationController?.popViewController(animated: true)        

    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(context == "Previously LEED Certified?" || context == "Contains residential units?"){
            let textString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            print(numberFiltered)
            if(string != numberFiltered){
                self.shakeit()
            }
            return (string == numberFiltered)
        }
        return true
    }
    
    func shakeit(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: txtfld.center.x - 10, y: txtfld.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: txtfld.center.x + 10, y: txtfld.center.y))
        txtfld.layer.add(animation, forKey: "position")
    }
    
    func textChanged(_ sender: UITextField){
        if(switchh.isOn && sender.text!.characters.count > 0){
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else if(switchh.isOn && sender.text!.characters.count == 0){
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is manageproj){
            let v = viewController as! manageproj
            v.data_dict = data_dict
        }
    }
    var s = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
        self.titlefont()
        txtfld.delegate = self
        let rightButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.rightbuttonclick(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
        txtfld.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        
        lbl.text = context
        if(lbl.text == "Project affiliated?"){
            lbl.text = "Is project affiliated with a higher education institute?"
        }
        self.spinner.isHidden = true
        self.spinner.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        if(context == "Previously LEED Certified?"){
            txtfld.keyboardType = .numberPad
            txtfld.placeholder = "Enter your previous LEED ID"
            
            if(buildingdetails["project_type"] as! String != "parksmart"){
                s = "ldp_old"
            }else{
                s = "IsLovRecert"
            }
            
            if(data_dict[s] is NSNull){
                switchh.isOn = false
            }else{
                if(data_dict[s] as? Int == 1){
                    switchh.isOn = true
                    if let s = data_dict["PrevCertProdId"] as? String{
                        txtfld.text = s
                    }else if let s = data_dict["PrevCertProdId"] as? Int{
                        txtfld.text = "\(s)"
                    }else{
                    }
                }else if(data_dict[s] as? Bool == true){
                    switchh.isOn = true
                    if let s = data_dict["PrevCertProdId"] as? String{
                        txtfld.text = s
                    }else if let s = data_dict["PrevCertProdId"] as? Int{
                        txtfld.text = "\(s)"
                    }else{
                    }
                }else{
                    switchh.isOn = false
                }
            }
        }else if(context == "Contains residential units?"){
            txtfld.placeholder = "Enter number of residential units"
            txtfld.keyboardType = .numberPad
            if(data_dict["IsResidential"] is NSNull){
                switchh.isOn = false
            }else{
                if(data_dict["IsResidential"] as? Bool == true){
                    switchh.isOn = true
                    if let s = data_dict["noOfResUnits"] as? String{
                        txtfld.text = s
                    }else if let s = data_dict["noOfResUnits"] as? Int{
                        txtfld.text = "\(s)"
                    }else{
                        txtfld.text = "\(data_dict["noOfResUnits"])"
                    }
                }else{
                    switchh.isOn = false
                }
            }
        }else if(context == "Project affiliated?"){
            txtfld.placeholder = "Enter name of the school"
            
            if(data_dict["AffiliatedHigherEduIns"] is NSNull){
                switchh.isOn = false
                txtfld.text = ""
            }else{
                if(data_dict["AffiliatedHigherEduIns"] as? Bool == true){
                    switchh.isOn = true
                    if let s = data_dict["nameOfSchool"] as? String{
                        txtfld.text = s
                    }else{
                    }
                }else{
                    switchh.isOn = false
                    txtfld.text = ""
                }
            }
        }
        
               if(switchh.isOn){
            txtfld.isEnabled = true            
            txtfld.becomeFirstResponder()
        }else{
            txtfld.isEnabled = false
        }
        if(buildingdetails["project_type"] as! String != "parksmart"){
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
        }else{
            self.tabbar.setItems([UITabBarItem.init(title: "Score", image: UIImage.init(named: "tile"), tag: 0),UITabBarItem.init(title: "Credits/Actions", image: UIImage.init(named: "card"), tag: 1)], animated: false)
            self.tabbar.items![0].title = "Manage project"
            self.tabbar.items![1].title = "Billing"
            self.tabbar.selectedItem = self.tabbar.items![0]
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
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
            //data_dict[s] = 1
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            txtfld.resignFirstResponder()
            txtfld.isEnabled = false
            txtfld.text = ""
            //data_dict[s] = 0
            //data_dict["PrevCertProdId"] = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        }else if(context == "Contains residential units?"){
            if(switchh.isOn){
                txtfld.isEnabled = true
                txtfld.becomeFirstResponder()
                //data_dict["IsResidential"] = 1
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }else{
                txtfld.resignFirstResponder()
                txtfld.isEnabled = false
                txtfld.text = ""
                //data_dict["IsResidential"] = 0
                //data_dict["noOfResUnits"] = ""
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }else if(context == "Project affiliated?"){
            if(switchh.isOn){
                txtfld.isEnabled = true
                txtfld.becomeFirstResponder()
                //data_dict["AffiliatedHigherEduIns"] = 1
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }else{
                txtfld.resignFirstResponder()
                txtfld.isEnabled = false
                txtfld.text = ""
                //data_dict["AffiliatedHigherEduIns"] = 0
                //data_dict["nameOfSchool"] = ""
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        if(buildingdetails["project_type"] as! String != "parksmart"){
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
        }else{
            if(item.title == "Manage project"){
                NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"parkmanage"])
            }else{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"parkbilling"])
            }
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
        
        //self.navigationController?.delegate = nil
        //stop all download requests        
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
