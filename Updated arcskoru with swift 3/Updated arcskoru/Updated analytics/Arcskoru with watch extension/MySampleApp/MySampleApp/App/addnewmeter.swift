//
//  addnewmeter.swift
//  LEEDOn
//
//  Created by Group X on 05/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class addnewmeter: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var assetname: UILabel!

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var collview: UICollectionView!
    @IBOutlet weak var metertypepicker: UIPickerView!
    @IBOutlet weak var unitspicker: UIPickerView!
    @IBOutlet weak var units: UISegmentedControl!
    @IBOutlet weak var metername: UITextField!
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var token = UserDefaults.standard.object(forKey: "token") as! String
    var currentmeterdata = NSMutableDictionary()
    var electricityarr = NSMutableArray()
    var waterarr = NSMutableArray()
    var othersarr = NSMutableArray()
    var metertype = NSArray()
    var currentunit = NSArray()
    var currentmetertype = NSArray()
    var unitsarr = NSArray()
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentmetertype.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var d = currentmetertype[indexPath.row] as! NSDictionary
        cell.textLabel?.text = d["type"] as! String
        if(d["subtype"] as! String != ""){
            cell.textLabel?.text =  "\(cell.textLabel?.text) (\(d["subtype"] as! String))"
        }
        cell.accessoryType = UITableViewCellAccessoryType.none
        if(cell.textLabel?.text == currenttype){
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentunit.count
    }
    var selected_unit = ""
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collcell", for: indexPath) as! collcell
        cell.lbl.text = currentunit[indexPath.row] as? String
        cell.img.isHidden = true
        if(cell.lbl.text == selected_unit){
        cell.img.isHidden = false
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view1 = typeview
        let view2 = unitview
        let picker1 = typepicker
        let picker2 = unitpicker
        self.typeview.removeFromSuperview()
        self.unitview.removeFromSuperview()
        var vieww = UIView()
        vieww.frame = (view1?.frame)!
        vieww.addSubview(picker1!)
        typetxtfld.inputView = view1
        vieww = UIView()
        vieww.frame = (view2?.frame)!
        vieww.addSubview(picker2!)
        unittype.inputView = vieww
        typepicker = picker1
        unitpicker = picker2
        collview.backgroundColor = UIColor.clear
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4.37,height:UIScreen.main.bounds.size.width/4.37)
        layout.minimumInteritemSpacing = 0//0.03 * UIScreen.mainScreen().bounds.size.width
        layout.minimumLineSpacing = 0.02 * UIScreen.main.bounds.size.width
        collview!.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        collview.layer.frame.size.height = layout.itemSize.height
        collview.register(UINib.init(nibName: "collcell", bundle: nil), forCellWithReuseIdentifier: "collcell")
        self.titlefont()
        metername.delegate = self
        spinner.layer.cornerRadius = 5
        getmetercategories()
        metertype = [["Generated onsite - solar","Purchased from Grid"],["Municipality supplied potable water","Municipality supplied reclaimed water","Reclaimed onsite"],["District Strem","District Hot water","District chilled water (Electric driven chiller)","District chilled water(Absorption chiller using natural gas)","District chilled water(Engine driven chiller using natural gas)","Natural gas","Fuel oil (No.2)","Wood","Propane","Liquid propane","Kerosene","Fuel oil (No.1)","Fuel oil (No.5 & No.6)","Coal (anthracite)","Coal (bituminous)","Coke","Fuel oil (No.4)","Diesel"]]
        
        unitsarr = [["kWh","MWh","MBtu","kBtu","Gj"],["gal","kGal","MGal","cf","ccf","kcf","mcf","I","cu m","gal(UK)","kGal(UK)","kGal(UK)","MGal(UK)"],["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"]]
        if(currentmeterdata.count == 0){
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = metertype[0] as! NSArray
            unitschange(units)
        }
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected_unit = currentunit[indexPath.row] as! String
        collview.reloadData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   var download_requests = [URLSession]()
    
    func getmetercategories(){
        let url = URL.init(string:String(format: "%@fuel/category/?page_size=300",credentials().domain_url))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
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
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                    })
                }else{
                    
                    var jsonDictionary = NSArray()
                    do {
                        var dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(dict["results"] != nil){
                            jsonDictionary = dict["results"] as! NSArray
                        }
                        
                        //print(jsonDictionary)
                        for i in jsonDictionary{
                            let item = i as! NSDictionary
                            if(item["kind"] != nil){
                                if(item["kind"]  as! String == "electricity" && item["include_in_dropdown_list"]  as? Bool == true){
                                    self.electricityarr.add(item)
                                }
                                
                                if(item["kind"]  as! String == "water" && item["include_in_dropdown_list"]  as? Bool == true){
                                    self.waterarr.add(item)
                                    
                                }
                                
                                if((item["kind"]  as! String == "fuel" || item["kind"]  as! String == "Other") && item["include_in_dropdown_list"]  as? Bool == true){
                                     self.othersarr.add(item)
                                }
                            }
                        }
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
                            var tempdict = [
                                "id": 25,
                                "type": "Purchased from Grid",
                                "subtype": "",
                                "kind": "electricity",
                                "include_in_dropdown_list": true,
                                "resource": "Non-Renewable",
                            ] as!  NSDictionary
                            self.electricityarr.insert(tempdict, at: 0)
                            self.spinner.isHidden = true
                            self.units.selectedSegmentIndex = 0
                            self.unitschange(self.units)
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
  
    }
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var typeview: UIView!
    @IBOutlet weak var unitview: UIView!
    @IBOutlet weak var typetxtfld: UITextField!
    @IBOutlet weak var unittype: UITextField!
    @IBOutlet weak var typepicker: UIPickerView!
    @IBOutlet weak var unitpicker: UIPickerView!
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
    
    @IBAction func unitschange(_ sender: AnyObject) {
        currentmetertype = NSArray()
        currentunit = NSArray()
        if(units.selectedSegmentIndex == 0){
            units.tintColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = metertype[0] as! NSArray
            currentmetertype = electricityarr
            unitspicker.reloadAllComponents()
            //metertypepicker.reloadAllComponents()
            collview.reloadData()
            self.tableview.reloadData()
        }else if(units.selectedSegmentIndex == 1){
            units.tintColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
            currentunit = unitsarr[1] as! NSArray
            currentmetertype = metertype[1] as! NSArray
            currentmetertype = waterarr
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
            collview.reloadData()
            self.tableview.reloadData()
        }else{
            units.tintColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            currentunit = unitsarr[2] as! NSArray
            currentmetertype = metertype[2] as! NSArray
            currentmetertype = othersarr
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
            collview.reloadData()
            self.tableview.reloadData()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == typepicker){
            return currentmetertype.count
        }else{
        return currentunit.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = currentmetertype[indexPath.row] as! NSDictionary
        var str  = d["type"] as! String
        if(d["subtype"] as! String != ""){
            str = "\(str) (\(d["subtype"] as! String))"
        }
        currenttype = str
        currentmeter = currentmetertype[indexPath.row] as! NSDictionary
        self.tableview.reloadData()
    }
    
    var currenttype = ""
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == typepicker){
            //return currentmetertype[row]["type"] as? String
            var d = currentmetertype[row] as! NSDictionary
            var str  = d["type"] as! String
            if(d["subtype"] as! String != ""){
                return "\(str) (\(d["subtype"] as! String))"
            }
            return str
        }else{
        return currentunit[row] as? String
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
    @IBAction func addupdate(_ sender: AnyObject) {
     //{"name":"sample_meter","native_unit":"kWh","type":"25"}
        
        if(currentmeter["id"] != nil && metername.text?.characters.count > 0 && selected_unit != ""){
        updatemeter(metername.text!, unit: selected_unit, ID: currentmeter["id"] as! Int)
        }else{
            if(currentmeter["id"] == nil){
                DispatchQueue.main.async(execute: {
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    let alertController = UIAlertController(title: "Error", message: "Please select a valid meter category", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                    alertController.addAction(action)
                    alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
                    self.present(alertController, animated: true, completion: nil)
                })
            }else if(metername.text?.characters.count == 0){
                DispatchQueue.main.async(execute: {
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    let alertController = UIAlertController(title: "Error", message: "Please enter a valid meter name", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                    alertController.addAction(action)
                    alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
                    self.present(alertController, animated: true, completion: nil)
                })
            }else if(selected_unit == ""){
                
                
                DispatchQueue.main.async(execute: {
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    let alertController = UIAlertController(title: "Error", message: "Please select a unit", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                    alertController.addAction(action)
                    alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
                    self.present(alertController, animated: true, completion: nil)
                })
                
                    
                

            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Categories"
    }
    
    var currentmeter = NSDictionary()
    
    func updatemeter(_ name:String, unit: String, ID:Int){
        
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
        })
        
        var payload = NSMutableString()
        payload.append("{")
        
                payload.append("\"name\": \"\(name)\",")
                payload.append("\"native_unit\": \"\(unit)\",")
        payload.append("\"type\": \(ID)}")
        //print(payload)
        var str = payload as String
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}")
        str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/meters/",credentials().domain_url, leedid))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
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
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200 && httpStatus.statusCode != 201){           // check for http errors
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
                            self.navigationController?.popViewController(animated: true)
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
    }

}
