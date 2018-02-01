//
//  selectvalue.swift
//  Arcskoru
//
//  Created by Group X on 08/02/17.
//
//

import UIKit

class selectvaluetoadd: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITabBarDelegate, UINavigationControllerDelegate  {
    var PICKER_MAX = 2017
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var token = UserDefaults.standard.object(forKey: "token") as! String
    var PICKER_MIN = 1900
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var switchh: UISwitch!
    var download_requests = [URLSession]()
    var currentvalue = ""
    var currenttitle = String()
    var data_dict = NSMutableDictionary()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.navigationController?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.delegate = nil
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? addnewproject {
            controller.data_dict = data_dict    // Here you pass the data back to your original view controller
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        //print("No of floors",self.data_dict["noOfFloors"])
        self.spinner.layer.cornerRadius = 5
self.spinner.isHidden = true
        picker.delegate = self
        picker.dataSource = self
        let filteritem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(done(_:)))
        self.navigationItem.rightBarButtonItem = filteritem
        self.navigationItem.setRightBarButton(filteritem, animated: true)
        lbl.text = currenttitle
        if(currenttitle == "Year built"){
            switchh.isHidden = true
            //print(currentvalue)
            if(self.data_dict["year_constructed"] != nil){
                currentvalue = data_dict["year_constructed"] as! String
            }
            if(currentvalue != ""){
                picker.selectRow((PICKER_MAX - PICKER_MIN) -  (PICKER_MAX - Int(currentvalue)!), inComponent: 0, animated: true)
            }else{
                picker.selectRow(0, inComponent: 0, animated: true)
            }
        }else if(currenttitle == "Floors above grounds"){
            switchh.isHidden = true
            if(self.data_dict["noOfFloors"] != nil){
                currentvalue = data_dict["noOfFloors"] as! String
            }
            if(currentvalue != ""){
                picker.selectRow((PICKER_MAX - PICKER_MIN) -  (PICKER_MAX - Int(currentvalue)!), inComponent: 0, animated: true)
            }else{
                picker.selectRow(0, inComponent: 0, animated: true)
            }
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
        //nav.setItems([navItem], animated: false);
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var tabbar: UITabBar!
    
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
    @IBOutlet weak var picker: UIPickerView!
    
    func done(_ sender: UIBarButtonItem){
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
            //self.saveproject(0)
            if(self.currenttitle == "Year built"){
                self.data_dict["year_constructed"] = self.currentvalue
            }else if(self.currenttitle == "Floors above grounds"){
                self.data_dict["noOfFloors"] = self.currentvalue
            }
            self.navigationController?.popViewController(animated: true)
        })
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (PICKER_MAX - PICKER_MIN + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + PICKER_MIN)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentvalue = "\(row + PICKER_MIN)"
        //print(currentvalue)
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
