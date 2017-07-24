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
    var godirectly = 0
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var token = UserDefaults.standard.object(forKey: "token") as! String
    var row = 0
    @IBOutlet weak var tableview: UITableView!
    var meters = NSMutableArray()
    var currentarr = NSMutableDictionary()
    override func viewDidLoad() {
        self.titlefont()
        super.viewDidLoad()
        let datakeyed = UserDefaults.standard.object(forKey: "currentcategory") as! Data
        let currentcategory = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSArray).mutableCopy() as! NSMutableArray
        let current = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        //print("aarra", currentcategory)
        currentarr = (currentcategory[current] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        tableview.tableFooterView = UIView()
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        tableview.register(UINib.init(nibName: "wastereadingscell", bundle: nil), forCellReuseIdentifier: "cell")
        //print(meters)
        let Nam2BarBtnVar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        self.navigationItem.setRightBarButtonItems([Nam2BarBtnVar], animated: true)        
        // Do any additional setup after loading the view.
    }
    
     var enddatearr = NSMutableArray()
    
    @IBOutlet weak var spinner: UIView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func add(_ sender: UIBarButtonItem){
        adding = 1        
        self.performSegue(withIdentifier: "gotodetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meters.count
    }
        
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.tableview.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")! as! wastereadingscell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var dict = (meters.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let str1 = format.date(from: dict["start_date"] as! String)
        let str2 = format.date(from: dict["end_date"] as! String)
        format.dateFormat = "MMM dd,yyyy"
        let startdate = format.string(from: str1!)
        let enddate = format.string(from: str2!)
        //print(startdate,enddate)
        cell.textLabel?.text = "\(startdate) - \(enddate)"
        var t = ""
        if(dict["unit"] == nil || dict["unit"] is NSNull){
            
            t = "N/A"
        }else{
            t = "\(dict["unit"]as! String)"
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
        
        cell.detailTextLabel?.text = "Waste generated: \(generated) | Waste diverted: \(diverted)(\(t as! String))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var dict = (meters.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        if(tableView == tableview){
            let favorite = UITableViewRowAction(style: .default, title: "Delete") { action, index in
                let alertController = UIAlertController(title: "Delete reading", message: "Would you like to delete this reading?", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    DispatchQueue.main.async(execute: {
                        if let creditDescription = self.currentarr["CreditStatus"] as? String{
                            if(creditDescription.lowercased() == "under review"){
                                self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                            }else{
                        self.spinner.isHidden = false
                        self.view.isUserInteractionEnabled = false
                        self.deletereading(dict["id"] as! Int, row: indexPath.row)
                            }
                        }
                    })
                    
                    }
                )
                alertController.addAction(yesAction)
                
                let noaction = UIAlertAction(title: "No", style: .cancel, handler: {
                    action in
                    
                    }
                )
                alertController.addAction(noaction)
                alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
                self.present(alertController, animated: true, completion: nil)
            }
            
            let share = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
                self.row = indexPath.row
                self.adding = 0
                tableView.deselectRow(at: indexPath, animated: true)
                self.performSegue(withIdentifier: "gotodetail", sender: nil)
            }
            share.backgroundColor = UIColor.init(red: 0.756, green: 0.756, blue: 0.756, alpha: 1)
            favorite.backgroundColor = UIColor.init(red: 0.858, green: 0.211, blue: 0.196, alpha: 1)
            return [share, favorite]
        }
        
        
        return nil
    }
    
    
    func deletereading(_ readingID: Int, row: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/waste/ID:%d/?recompute_score=1",credentials().domain_url,leedid,readingID))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "DELETE"
        var httpbody = "{}"
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
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
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                    
                    do {
                        DispatchQueue.main.async(execute: {
                            self.meters.removeObject(at: row)
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            self.tableview.reloadData()
                        })
                        
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
            return 0.05 * UIScreen.main.bounds.size.height;
        }
        return 0.05 * UIScreen.main.bounds.size.width;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*adding = 0
        row = indexPath.row
        self.performSegueWithIdentifier("gotodetail", sender: nil)*/
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotodetail"){
            let v = segue.destination as! wastereadingdetail
            v.meters = meters
            v.adding = adding
            v.row = row
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            if(headerView.textLabel?.text?.lowercased() == "no readings found"){
                headerView.textLabel?.textAlignment = .center
            }else{
                headerView.textLabel?.textAlignment = .left
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(meters.count > 0){
        return "Swipe left to edit/delete the reading"
        }
        
        return "No readings found"
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
