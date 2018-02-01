//
//  listall.swift
//  LEEDOn
//
//  Created by Group X on 25/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class listall: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tablview: UITableView!
var dataarr = NSMutableArray()
    var selected = 0
    var id = 0
    var selectedarr = NSMutableDictionary()
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var token = UserDefaults.standard.object(forKey: "token") as! String
    @IBAction func addnewreading(_ sender: AnyObject) {
        //print("Add new reading")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        if(self.dataarr.count > 0){
        var  sortDescriptor = NSSortDescriptor.init(key: "end_date", ascending: true)
        self.dataarr.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
        print(self.dataarr.lastObject)
        let dict = (self.dataarr.lastObject as! NSDictionary)["meter"] as! NSDictionary
        self.navigationItem.title = dict["name"] as! String
        }
        self.navigationItem.title = meter_name
        self.navigationController?.navigationBar.backItem?.title = (currentarr["CreditDescription"] as! String).capitalized
        self.tablview.reloadData()
    }
    @IBAction func closeit(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var nav: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        //dataarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("selreading") as! NSData)?.mutableCopy() as! NSMutableArray
        //id = NSUserDefaults.standardUserDefaults().integerForKey("meterID")
        tablview.reloadData()
    }
    
    var currentarr = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!, NSForegroundColorAttributeName : UIColor.white]
        tablview.register(UINib.init(nibName: "customreadingcell", bundle: nil), forCellReuseIdentifier: "customreadingcell")
        let datakeyed = UserDefaults.standard.object(forKey: "currentcategory") as! Data
        let currentcategory = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSArray).mutableCopy() as! NSMutableArray
        let current = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        //print("aarra", currentcategory)
        currentarr = (currentcategory[current] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.titlefont()
        //if(selectedarr.count>0){
          //  dataarr.replaceObjectAtIndex(selected, withObject: selectedarr)
        //}
     //   dataarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("selreading") as! NSData)?.mutableCopy() as! NSMutableArray
       // id = NSUserDefaults.standardUserDefaults().integerForKey("meterID")
        tablview.register(UINib.init(nibName: "customreadingcell", bundle: nil), forCellReuseIdentifier: "customreadingcell")
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        //print("Selected reading", dataarr)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        if(dataarr.count == 0){
            return "No readings found"
        }
        return "Swipe left to edit/delete the reading"
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataarr.count
    }
    var meter_name = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = meter_name
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if(segue.identifier == "gotoeditreading"){
            let vc = segue.destination as! readingvc
               vc.dataarr = selectedarr
                vc.currentindex = selected
            vc.addreading = 0
        }else if(segue.identifier == "gotoaddreading"){
            //let vc = segue.destinationViewController as! readingvc
            //vc.id = id
            //vc.addreading = 1
            let vc = segue.destination as! readingvc
                vc.listofreadings = dataarr
            vc.id = id
            vc.addreading = 1
        }

    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var dict = (dataarr.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        if(tableView == tablview){
         let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            let alertController = UIAlertController(title: "Delete reading", message: "Would you like to delete this reading?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
                action in
                if let creditDescription = self.currentarr["CreditStatus"] as? String{
                    if(creditDescription.lowercased() == "under review"){
                        self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                    }else{
                    self.deletereading(indexPath.row, readingID: dict["id"] as! Int)
                    }
                }
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
         let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.selected = indexPath.row
            self.selectedarr = (self.dataarr.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            tableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: "gotoeditreading", sender: nil)
         }
            delete.backgroundColor = UIColor.init(red: 0.858, green: 0.211, blue: 0.196, alpha: 1)
            edit.backgroundColor = UIColor.init(red: 0.756, green: 0.756, blue: 0.756, alpha: 1)
         return [edit, delete]
         }
        return nil
    }
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true            
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            // self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func deletereading(_ row:Int, readingID:Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/ID:%d/?recompute_score=1",credentials().domain_url,leedid,id,readingID))
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
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
                return
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
                            self.dataarr.removeObject(at: row)
                            self.tablview.reloadData()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customreadingcell") as! customreadingcell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var dict = (dataarr.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = credentials().micro_secs
        //print("dates",dict["start_date"],dict["end_date"])
        var date1 = Date()
        var date2 = Date()
           date1 = dateFormatter.date(from: dict["start_date"] as! String)!
        date2 = dateFormatter.date(from: dict["end_date"] as! String)!
        //print(date1, date2)
        let calendar = Calendar.current
        let twoDaysAgo = (calendar as NSCalendar).date(byAdding: .day, value: 0, to: date2, options: [])!
        dateFormatter.dateFormat = "d MMM yyyy"
        cell.durationlbl.text = String(format: "%@ - %@",dateFormatter.string(from: date1),dateFormatter.string(from: twoDaysAgo))
        cell.reading.text = String(format:"%d",dict["reading"] as! Int)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = (dataarr.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        //print(dict["id"])
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addreadings(_ sender: AnyObject) {
            self.performSegue(withIdentifier: "gotoaddreading", sender: nil)
    }
}
