//
//  editwater.swift
//  Arcskoru
//
//  Created by Group X on 31/07/17.
//
//

import UIKit

class editwater: UIViewController, UITableViewDataSource,UITableViewDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    var d = NSMutableDictionary()
    var download_requests = [URLSession]()
    var durationarr = ["Per Year","Per Month","Per Week","Per Day"]
    var unitarr = ["Gallons","Litres"]
    var selected = 0
    override func viewDidDisappear(_ animated: Bool) {
        
        //self.navigationController?.delegate = nil
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is yearlydata){
            var v = viewController as! yearlydata
            print(payl)
            payl = (payl_temp as String).replacingOccurrences(of: "\"", with: "'")
            actual_dict["data"] = payl
            var temp = v.actiondata
            temp.replaceObject(at: selected, with: actual_dict)
            print(temp[selected])
            v.actiondata = temp
        }
    }
    var payl = ""
    var actual_dict = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.spinner.layer.masksToBounds = true
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        actual_dict = d
        tableview.tintColor = savebtn.backgroundColor!
        var tempdata = d["data"] as! String
        payl = d["data"] as! String
        payl_temp = NSMutableString.init(string: payl)
        tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
        d["data"] = yearlydata().convertStringToDictionary(tempdata)
        if let json = try? JSONSerialization.data(withJSONObject: d, options: []) {
            // here `json` is your JSON data
            if let jsonDictionary = try? JSONSerialization.jsonObject(with: json, options: JSONSerialization.ReadingOptions()) {
                ////print(jsonDictionary["data"]!!["air_quality_index_num"])
                d = (jsonDictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
        }
        let t = NSMutableDictionary.init(dictionary: d["data"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        
        if let c = t["duration"] as? String{
        sel_duration = c
        }
        
        if let c = t["unit"] as? String{
            sel_unit = c
        }
        
        // Do any additional setup after loading the view.
    }
    func showalert(_ message:String, title:String, action:String){
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.maketoast(message, type: "error")
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Back"
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
    }
    
    func addactiondata(_ subscription_key:String, leedid: Int, ID : String, payload : String){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/data/%@/?recompute_score=1",credentials().domain_url, leedid,ID,d["year"] as! String))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = payload
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
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201{           // check for http errors
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
                            self.maketoast("Reading updated successfully", type: "message")
                            self.navigationController?.popViewController(animated: true)
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        })
        task.resume()
        
        
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var payl_temp = NSMutableString()
    @IBAction func submit(_ sender: Any) {
        
            payl_temp = NSMutableString()
            let tempstring = NSMutableString()
            tempstring.append("{\"data\":\"{")
        payl_temp.append("{")
            let data_dict = (d["data"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            data_dict["unit"] = sel_unit
            data_dict["duration"] = sel_duration
            data_dict.removeObject(forKey: "water_consumption_num")
            for (item,key) in data_dict{
                tempstring.append("'\(item)':'\(key)',")
                payl_temp.append("'\(item)':'\(key)',")
            }


        
        
        if let t = (d["data"] as? NSDictionary)?.mutableCopy() as? NSMutableDictionary{
            if(t["duration"] == nil){
                t["duration"] = "Per Year"
            }
            if(t["unit"] == nil){
                t["unit"] = "Gallon"
            }
            if let s = t["water_consumption_num"] as? Float{
                var value = Float(self.getvalue(key: "water_consumption_num", d: t.mutableCopy() as! NSMutableDictionary))!
                if(t["unit"] as! String == "Gallons")
                {
                    //no conversion for unit
                }
                if(sel_duration as! String == "Per Day")
                {
                    //no conversion for duration
                }
                
                if(sel_unit as! String == "Litres")
                {
                    value = value * 0.264172;
                }
                
                if(sel_duration as! String == "Per Year")
                {
                    value = value / Float(365.0);
                }
                else if(sel_duration as! String == "Per Week")
                {
                    value = value / Float(7.0)
                }
                else if(sel_duration as! String == "Per Month")
                {
                    value = value / 31.0
                }
                value = value / Float(1000.0)
                print(String(format:"%f",value))
                payl_temp.append("'water_consumption_num':'\(String(format:"%f",value))',")
                tempstring.append("'water_consumption_num':'\(String(format:"%f",value))',")
                var str = tempstring as String
                tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                str = payl_temp as String
                payl_temp.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                payl_temp.append("}")
                tempstring.append("}\"}")
                print(tempstring)
                payl = tempstring as String
                self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: shortID, payload: tempstring as String)
            }else
            if let s = t["water_consumption_num"] as? Double{
                var value = Float(self.getvalue(key: "water_consumption_num", d: t.mutableCopy() as! NSMutableDictionary))!
                if(t["unit"] as! String == "Gallons")
                {
                    //no conversion for unit
                }
                if(sel_duration as! String == "Per Day")
                {
                    //no conversion for duration
                }
                
                if(sel_unit as! String == "Litres")
                {
                    value = value * 0.264172;
                }
                
                if(sel_duration as! String == "Per Year")
                {
                    value = value / Float(365.0);
                }
                else if(sel_duration as! String == "Per Week")
                {
                    value = value / Float(7.0)
                }
                else if(sel_duration as! String == "Per Month")
                {
                    value = value / 31.0
                }
                value = value / Float(1000.0)
                print(String(format:"%f",value))
                payl_temp.append("'water_consumption_num':'\(String(format:"%f",value))',")
                tempstring.append("'water_consumption_num':'\(String(format:"%f",value))',")
                var str = tempstring as String
                tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                str = payl_temp as String
                payl_temp.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                tempstring.append("}\"}")
                payl_temp.append("}")
                print(tempstring)
                payl = tempstring as String
                self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: shortID, payload: tempstring as String)
            }else if let s = t["water_consumption_num"] as? Int{
                var value = Float(self.getvalue(key: "water_consumption_num", d: t.mutableCopy() as! NSMutableDictionary))!
                if(t["unit"] as! String == "Gallons")
                {
                    //no conversion for unit
                }
                if(sel_duration as! String == "Per Day")
                {
                    //no conversion for duration
                }
                
                if(sel_unit as! String == "Litres")
                {
                    value = value * 0.264172;
                }
                
                if(sel_duration as! String == "Per Year")
                {
                    value = value / Float(365.0);
                }
                else if(sel_duration as! String == "Per Week")
                {
                    value = value / Float(7.0)
                }
                else if(sel_duration as! String == "Per Month")
                {
                    value = value / 31.0
                }
                value = value / Float(1000.0)
                print(String(format:"%f",value))
                payl_temp.append("'water_consumption_num':'\(String(format:"%f",value))',")
                tempstring.append("'water_consumption_num':'\(String(format:"%f",value))',")
                var str = tempstring as String
                tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                str = payl_temp as String
                payl_temp.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                tempstring.append("}\"}")
                payl_temp.append("}")
                print(tempstring)
                payl = tempstring as String
                self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: shortID, payload: tempstring as String)
                
            }else if let s = t["water_consumption_num"] as? String{
                if(Float(s) != nil){
                    if(Float(s)! >= 0){
                        var value = Float(self.getvalue(key: "water_consumption_num", d: t.mutableCopy() as! NSMutableDictionary))!
                        if(t["duration"] == nil){
                            t["duration"] = "Per Year"
                        }
                        if(t["unit"] == nil){
                            t["unit"] = "Gallon"
                        }
                        if(t["unit"] as! String == "Gallons")
                        {
                            //no conversion for unit
                        }
                        if(sel_duration as! String == "Per Day")
                        {
                            //no conversion for duration
                        }
                        
                        if(sel_unit as! String == "Litres")
                        {
                            value = value * 0.264172;
                        }
                        
                        if(sel_duration as! String == "Per Year")
                        {
                            value = value / Float(365.0);
                        }
                        else if(sel_duration as! String == "Per Week")
                        {
                            value = value / Float(7.0)
                        }
                        else if(sel_duration as! String == "Per Month")
                        {
                            value = value / 31.0
                        }
                        value = value / Float(1000.0)
                        print(String(format:"%f",value))
                        tempstring.append("'water_consumption_num':'\(String(format:"%f",value))',")
                        payl_temp.append("'water_consumption_num':'\(String(format:"%f",value))',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        str = payl_temp as String
                        payl_temp.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        print(tempstring)
                        payl_temp.append("}")
                        payl = tempstring as String
                        self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: shortID, payload: tempstring as String)
                    }
                }
                
            }
               }
        
        
    }
    var shortID = ""
    func getvalue(key:String,d:NSMutableDictionary) -> String{
        if(d["duration"] == nil){
            d["duration"] = "Per Year"
        }
        if(d["unit"] == nil){
            d["unit"] = "Gallon"
        }
        var str = "0.00"
            print(d["duration"])
            if let s = d[key] as? Float{
                var value = s
                
                value *= 1000.0
                if(d["unit"] as! String == "Litres")
                {
                    value /= 0.264172;
                }
                
                if(d["duration"] as! String == "Per Year")
                {
                    value *= 365.0;
                }
                if(d["duration"] as! String == "Per Week")
                {
                    value *= 7.0
                }
                if(d["duration"] as! String == "Per Month")
                {
                    value *= 31.0
                }
                str = String(format:"%.2f",value)
            }else if let s = d[key] as? Int{
                var value = Float(s)
                value *= 1000.0
                if(d["unit"] as! String == "Litres")
                {
                    value /= 0.264172;
                }
                
                if(d["duration"] as! String == "Per Year")
                {
                    value *= 365.0;
                }
                else if(d["duration"] as! String == "Per Week")
                {
                    value *= 7.0
                }
                else if(d["duration"] as! String == "Per Month")
                {
                    value *= 31.0
                }
                str = String(format:"%.2f",value)
            }else if let s = d[key] as? Float{
                var value = s
                value *= 1000.0
                if(d["unit"] as! String == "Litres")
                {
                    value /= 0.264172;
                }
                
                if(d["duration"] as! String == "Per Year")
                {
                    value *= 365.0;
                }
                else if(d["duration"] as! String == "Per Week")
                {
                    value *= 7.0
                }
                else if(d["duration"] as! String == "Per Month")
                {
                    value *= 31.0
                }
                str = String(format:"%.2f",value)
            }else if let s = d[key] as? String{
                print(s)
                if(Float(s) != nil){
                    if(Float(s)! >= 0){
                        var value = Float(s)!
                        value *= 1000.0
                        if(d["unit"] as! String == "Litres")
                        {
                            value /= 0.264172;
                        }
                        
                        if(d["duration"] as! String == "Per Year")
                        {
                            value *= 365.0;
                        }
                        else if(d["duration"] as! String == "Per Week")
                        {
                            value *= 7.0
                        }
                        else if(d["duration"] as! String == "Per Month")
                        {
                            value *= 31.0
                        }
                        str = String(format:"%.2f",value)
                    }
                }
            }
            return str
        
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 2
        }else if(section == 1){
            return 2
        }else if(section == 2){
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Water consumption"
        }else if(section == 1){
            return "Unit"
        }else if(section == 2){
            return "Duration"
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.accessoryType = .none
            if(indexPath.row == 0){
                cell.textLabel?.text = "Year"
                cell.detailTextLabel?.text = d["year"] as! String
            }else if(indexPath.row == 1){
                cell.textLabel?.text = "Reading"
                let t = NSMutableDictionary.init(dictionary: d["data"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(t["duration"] == nil){
                    t["duration"] = "Per Year"
                }
                if(t["unit"] == nil){
                    d["unit"] = "Gallon"
                }
                    cell.detailTextLabel?.text = self.getvalue(key: "water_consumption_num", d: t)
            }
            return cell
        }else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            cell.selectionStyle = .none
            if(indexPath.row == 0){
                cell.textLabel?.text = unitarr[indexPath.row] as! String
                if(sel_unit == "Gallons" || sel_unit == "Gallon"){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
                cell.detailTextLabel?.text = d["year"] as! String
            }else if(indexPath.row == 1){
                cell.textLabel?.text = unitarr[indexPath.row] as! String
                if(sel_unit == "Litres" || sel_unit == "Litre"){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            cell.selectionStyle = .none
            if(indexPath.row == 0){
                cell.textLabel?.text = durationarr[indexPath.row] as! String
                if(sel_duration == "Per Year"){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }else if(indexPath.row == 1){
                cell.textLabel?.text = durationarr[indexPath.row] as! String
                if(sel_duration == "Per Month"){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }else if(indexPath.row == 2){
                cell.textLabel?.text = durationarr[indexPath.row] as! String
                if(sel_duration == "Per Week"){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }else if(indexPath.row == 3){
                cell.textLabel?.text = durationarr[indexPath.row] as! String
                if(sel_duration == "Per Day"){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            sel_unit = unitarr[indexPath.row] as! String
        }else if(indexPath.section == 2){            
            sel_duration = durationarr[indexPath.row] as! String
        }
        self.tableview.reloadData()
    }
    
    
    var sel_unit = "Gallons"
    var sel_duration = "Per Year"
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
