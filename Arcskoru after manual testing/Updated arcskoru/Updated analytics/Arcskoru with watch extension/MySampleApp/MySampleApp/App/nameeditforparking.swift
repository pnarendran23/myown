//

//  nameedit.swift
//  Arcskoru
//
//  Created by Group X on 07/02/17.
//
//

import UIKit

class nameeditforparking: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITabBarDelegate {
    @IBOutlet weak var txtfld: UITextField!
    var name = ""
    var download_requests = [URLSession]()
    var currenttitle = ""
    var data_dict = NSMutableDictionary()
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var token = UserDefaults.standard.object(forKey: "token") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        self.titlefont()
        txtfld.text = name
        context.text = currenttitle
        self.spinner.isHidden = true
        self.spinner.layer.cornerRadius = 5
        txtfld.delegate = self
        self.tabbar.delegate = self
        self.tabbar.items![0].title = "Manage project"
        self.tabbar.items![1].title = "Billing"
        self.tabbar.selectedItem = self.tabbar.items![0]
        txtfld.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        txtfld.becomeFirstResponder()
        let plaque = UIImage.init(named: "score")
        let credits = UIImage.init(named: "Menu_icon")
        let analytics = UIImage.init(named: "chart")
        let more = UIImage.init(named: "more")
        //self.tabbar.setItems([UITabBarItem.init(title: "Score", image: plaque, tag: 0),UITabBarItem.init(title: "Credits/Actions", image: credits, tag: 1),UITabBarItem.init(title: "Analytics", image: analytics, tag: 2),UITabBarItem.init(title: "More", image: more, tag: 3)], animated: false)
        
        //self.tabbar.selectedItem = self.tabbar.items![3]
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
        
        if(self.currenttitle == "Name"){
            txtfld.keyboardType = .default
        }else if(self.currenttitle == "Number of parking spaces"){
            txtfld.keyboardType = .numberPad
        }else if(self.currenttitle == "How many levels in your parking structure?"){
            txtfld.keyboardType = .numberPad
        }else if(self.currenttitle == "Project Website"){
            txtfld.keyboardType = .default
        }
        savebtn.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.title == "Manage project"){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"parkmanage"])
        }else{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"parkbilling"])
        }
    }
    
    func textChanged(_ sender : UITextField){
        if(sender.text!.characters.count > 0){
            savebtn.isEnabled = true
        }else{
            savebtn.isEnabled = false
        }
    }
    
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var context: UILabel!
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.navigationController?.navigationBar.backItem?.title = "Manage project"
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /*(data_dict["name"] != nil || (data_dict["name"] as? String)?.characters.count > 0) && (data_dict["rating_system"] != nil || (data_dict["rating_system"] as? String)?.characters.count > 0) && (data_dict["unitType"] != nil || (data_dict["unitType"] as? String)?.characters.count > 0) && (data_dict["organization"] != nil || (data_dict[""] as? String)?.characters.count > 0) && (data_dict["owner_email"] != nil || (data_dict[""] as? String)?.characters.count > 0) && (data_dict["country"] != nil || (data_dict["country"] as? String)?.characters.count > 0) && (data_dict["gross_area"] != nil || (data_dict["gross_area"] as? String)?.characters.count > 0) && (data_dict["confidential"] != nil || (data_dict["confidential"] as? String)?.characters.count > 0) && (data_dict["occupancy"] != nil || (data_dict["occupancy"] as? String)?.characters.count > 0) && (data_dict["street"] != nil || (data_dict["street"] as? String)?.characters.count > 0) && (data_dict["city"] != nil || (data_dict["city"] as? String)?.characters.count > 0) && (data_dict["zip_code"] != nil || (data_dict["zip_code"] as? String)?.characters.count > 0) */
    
    @IBOutlet weak var savebtn: UIBarButtonItem!
    @IBAction func save(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.name = self.txtfld.text!
            if(self.currenttitle == "Name"){
                self.data_dict["name"] = self.name
            }else if(self.currenttitle == "Number of parking spaces"){
                self.data_dict["noOfParkingSpace"] = self.name
            }else if(self.currenttitle == "How many levels in your parking structure?"){
                self.data_dict["noOfParkingLevels"] = self.name
            }else if(self.currenttitle == "Project Website"){
                self.data_dict["projectWebsite"] = self.name
            }
            
            self.navigationController?.popViewController(animated: true)
            //self.saveproject(0)
        })
        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is manageparking){
            let v = viewController as! manageparking
            v.temp_dict = data_dict
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        //self.navigationController?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        txtfld.resignFirstResponder()
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(context.text == "Name" || context.text == "Project Website"){
            return true
        }
        let aSet = CharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if(string != numberFiltered){
            shakeit()
        }
        return string == numberFiltered
        
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
    
    @IBAction func saveproject(_ selected: Int) {
        
        
        
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
        })
        
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
