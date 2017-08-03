//
//  billing.swift
//  LEEDOn
//
//  Created by Group X on 09/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class parkbilling: UIViewController, UITabBarDelegate,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var tabbar: UITabBar!
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var token = UserDefaults.standard.object(forKey: "token") as! String
    @IBOutlet weak var assetname: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var billingarr = NSArray()
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.title == "Manage project"){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"parkmanage"])
        }else{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"parkbilling"])
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.delegate = self
        self.tabbar.items![0].title = "Manage project"
        self.tabbar.items![1].title = "Billing"
        self.tabbar.selectedItem = self.tabbar.items![1]
        self.titlefont()
        self.spinner.layer.cornerRadius = 5
        /*let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
                    let plaque = UIImage.init(named: "score")
        let credits = UIImage.init(named: "Menu_icon")
        let analytics = UIImage.init(named: "chart")
        let more = UIImage.init(named: "more")
        self.tabbar.setItems([UITabBarItem.init(title: "Score", image: plaque, tag: 0),UITabBarItem.init(title: "Credits/Actions", image: credits, tag: 1),UITabBarItem.init(title: "Analytics", image: analytics, tag: 2),UITabBarItem.init(title: "More", image: more, tag: 3)], animated: false)
        self.tabbar.items![3].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![3].badgeValue = nil
        }*/
        
        
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        //print(dict)
        self.tabbar.selectedItem = self.tabbar.items![1]
        assetname.text = dict["name"] as? String
        self.navigationItem.title = dict["name"] as? String
        self.view.bringSubview(toFront: nav)
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
        let doneItem = UIBarButtonItem(title: "< Manage", style: .plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
        })
        getbillingdetails()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Projects";
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "BILLING"
        }
        return ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    
    @IBOutlet weak var nav: UINavigationBar!
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"manage"])
    }
    
    func getbillingdetails(){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/payments/order/",credentials().domain_url,leedid))
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
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                        //print(jsonDictionary)
                        if(jsonDictionary["ItOrders"] is NSArray){
                            self.billingarr = jsonDictionary["ItOrders"] as! NSArray
                        }else{
                            let temp = NSArray.init(object: jsonDictionary["ItOrders"] as! NSDictionary)
                            self.billingarr = temp
                        }
                        
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.view.isUserInteractionEnabled = true
                            self.spinner.isHidden = true
                            self.tableview.reloadData()
                        })
                        
                        
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        })
                        DispatchQueue.main.async(execute: {
                            self.view.isUserInteractionEnabled = true
                            self.spinner.isHidden = true
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return billingarr.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.selectionStyle = .none
        let dict = billingarr.object(at: indexPath.section) as!NSDictionary
        if(indexPath.row == 0){
            cell.textLabel?.text = "Date"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var date = NSDate()
            
            if(dict["Erdat"] is NSNull || dict["Erdat"] == nil){
                cell.detailTextLabel?.text = ""
            }else{
                if(date == nil){
                    cell.detailTextLabel?.text = ""
                }else{
                    print(dict["created_at"])
                    if(formatter.date(from: dict["Erdat"] as! String) != nil){
                        date =  formatter.date(from: dict["Erdat"] as! String)! as NSDate
                    }else{
                        formatter.dateFormat = credentials().milli_secs
                        date =  formatter.date(from: dict["Erdat"] as! String)! as NSDate
                    }
                    formatter.dateFormat = "MMM dd, yyyy"
                    cell.detailTextLabel?.text = formatter.string(from: date as Date)
                }
            }
        }else if(indexPath.row == 1){
            cell.textLabel?.text = "Order ID"
            if(dict["Vbeln"] is NSNull || dict["Vbeln"] == nil){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = dict["Vbeln"] as! String
            }
        }else if(indexPath.row == 2){
            cell.textLabel?.text = "Order Type"
            if(dict["OrderType"] is NSNull || dict["OrderType"] == nil){
                cell.detailTextLabel?.text = ""
            }else{
                var s = ""
                s = (dict["OrderType"] as! String).uppercased()
                if(s == "SCORECARD"){
                    if(dict["certification_type"] is NSNull || dict["certification_type"] == nil){
                        cell.detailTextLabel?.text = ""
                    }else{
                        s = "\(s as! String) - \(dict["certification_type"] as! String)"
                    }
                }else if(s == "PERFORMANCE SCORE"){
                    if(dict["certification_type"] is NSNull || dict["certification_type"] == nil){
                        cell.detailTextLabel?.text = ""
                    }else{
                        s = "\(s as! String) - \(dict["certification_type"] as! String)"
                    }
                }
                cell.detailTextLabel?.text = s
            }
        }else if(indexPath.row == 3){
            cell.textLabel?.text = "Total"
            if(dict["Netwr"] is NSNull || dict["Netwr"] == nil){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = String(format:"$ %.2f",Float(dict["Netwr"] as! String)!)
            }
        }else if(indexPath.row == 4){
            cell.textLabel?.text = "Status"
            if(dict["OrderStatus"] is NSNull || dict["OrderStatus"] == nil){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = (dict["OrderStatus"] as! String).capitalized
                if(cell.detailTextLabel?.text == "Payment Cleared"){
                    cell.detailTextLabel?.text = "Completed"
                }else{
                    cell.detailTextLabel?.text = "Pending"
                }
            }
        }
        
        
        return cell

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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
