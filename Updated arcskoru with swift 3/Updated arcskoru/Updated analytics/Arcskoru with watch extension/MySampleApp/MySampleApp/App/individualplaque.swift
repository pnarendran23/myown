//
//  ViewController.swift
//  dashboard
//
//  Created by Group X on 19/01/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class individualplaque: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var localavgscorevalue = 0
    var globalavgscorevalue = 0
    var outerscorevalue = 0
    var innerstroke = UIColor.white
    var pageIndex = 0
    var outermaxscorevalue = 0
    var middlescorevalue = 0
    var middlemaxscorevalue = 0
    var innerscorevalue = 0
    var innermaxscorevalue = 0
    var titlevalue = ""
    var context1value = ""
    var context2value = ""
    var strokecolor = UIColor.white
    var plaqueimg = UIImage.init(named: "energy")!
    var w = 0.8 * UIScreen.main.bounds.size.width
    var performance_data = NSMutableDictionary()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        self.titlefont()
        tableview.register(UINib.init(nibName: "progresscell", bundle: nil), forCellReuseIdentifier: "progresscell")
       /* //print("Two")
        //print(UIScreen.mainScreen().bounds.size.width)
        var v = UIScreen.mainScreen().bounds.size.width
        self.vv.frame.size.height = v
        self.vv.frame.size.width = v
        vv.localavgscorevalue = 32
        vv.globalavgscorevalue = 22
        vv.outerscorevalue = 31
        vv.outermaxscorevalue = 33        
        self.vv.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2,UIScreen.mainScreen().bounds.size.height/2);
        sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
        vv.setNeedsDisplay()
        vv.removeAllAnimations()
        vv.addUntitled1Animation()
         */
        performance_data = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "performance_data") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.view.backgroundColor = UIColor.black
        self.vv.backgroundColor = UIColor.clear
        self.vv.setNeedsDisplay()
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
            var v = UIScreen.main.bounds.size.width
            self.vv.frame.size.height = v
            self.vv.frame.size.width = v
        }else{
            var v = UIScreen.main.bounds.size.height
            self.vv.frame.size.height = v
            self.vv.frame.size.width = v
        }
       
        
        
        sview.isScrollEnabled = true
        self.vv.center = CGPoint(x: UIScreen.main.bounds.size.width/2,y: UIScreen.main.bounds.size.height/2);
        sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        self.vv.center = CGPoint(x: UIScreen.main.bounds.size.width/2,y: UIScreen.main.bounds.size.height/3.6);
        //self.tableview.frame.origin.y = 1.3 * (self.vv.center.y + self.vv.frame.size.height)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            self.tableview.center = CGPoint(x: UIScreen.main.bounds.size.width/2,y: 1.5 * (self.vv.frame.origin.y + (self.vv.frame.size.height * 1)));
            break
        case .pad:
           self.tableview.center = CGPoint(x: UIScreen.main.bounds.size.width/2,y: 1.45 * (self.vv.frame.origin.y + (self.vv.frame.size.height * 1)));
            // It's an iPad
            
            break
        case .unspecified:
            self.tableview.center = CGPoint(x: UIScreen.main.bounds.size.width/2,y: 1.5 * (self.vv.frame.origin.y + (self.vv.frame.size.height * 1)));
            break
            
        default :
            self.tableview.center = CGPoint(x: UIScreen.main.bounds.size.width/2,y: 1.5 * (self.vv.frame.origin.y + (self.vv.frame.size.height * 1)));
            // Uh, oh! What could it be?
        }
        self.tableview.frame.size.height = 3 * (0.095 * self.view.frame.size.height)
        if(titlevalue.lowercased().contains("human")){
        self.tableview.frame.size.height = 6 * (0.095 * self.view.frame.size.height)
        }
        sview.contentSize =  CGSize(width: UIScreen.main.bounds.size.width, height: (self.vv.frame.size.height + self.tableview.frame.size.height ))
        self.tableview.isScrollEnabled = false
        
        
        vv.localavgscorevalue = localavgscorevalue
        vv.globalavgscorevalue = globalavgscorevalue
        vv.outermaxscorevalue = outermaxscorevalue
        vv.outerscorevalue = outerscorevalue
        vv.middlescorevalue = middlescorevalue
        vv.middlemaxscorevalue = middlemaxscorevalue
        vv.innerscorevalue = innerscorevalue
        vv.titlevalue = titlevalue
        vv.innerstrokes = innerstroke
        vv.context1value = context1value
        vv.context2value = context2value
        vv.strokecolor = strokecolor
        vv.categoryimg = plaqueimg
        vv.innermaxscorevalue = innermaxscorevalue
        vv.removeAllAnimations()
        vv.addUntitled1Animation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.055 * self.view.frame.size.height
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0.067 * self.view.frame.size.height
        }
        return 0.020 * self.view.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.006 * self.view.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "category scores"
        }
        return ""
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {       
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "progresscell", for: indexPath) as! progresscell
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            cell.percentagelbl.frame.origin.y = cell.contextlbl.frame.origin.y
            cell.img.frame.origin.y = 0.2 * cell.contextlbl.frame.size.height
            cell.img.frame.size.width = 0.6 * cell.contextlbl.frame.size.height
            cell.img.frame.size.height = 0.6 * cell.contextlbl.frame.size.height
            break
        case .pad:
            cell.percentagelbl.frame.origin.y = cell.contextlbl.frame.origin.y
            cell.img.frame.origin.y = 0.3 * cell.contextlbl.frame.size.height
            cell.img.frame.size.width = 0.45 * cell.contextlbl.frame.size.height
            cell.img.frame.size.height = 0.45 * cell.contextlbl.frame.size.height
            cell.img.frame.origin.x = 0.04 * cell.contentView.frame.size.width
            cell.contextlbl.frame.origin.x = (cell.img.frame.origin.x + cell.img.frame.size.width)
            // It's an iPad
            
            break
        case .unspecified:
            cell.percentagelbl.frame.origin.y = cell.contextlbl.frame.origin.y
            cell.img.frame.origin.y = 0.2 * cell.contextlbl.frame.size.height
            cell.img.frame.size.width = 0.6 * cell.contextlbl.frame.size.height
            cell.img.frame.size.height = 0.6 * cell.contextlbl.frame.size.height
            break
            
        default :
            cell.percentagelbl.frame.origin.y = cell.contextlbl.frame.origin.y
            cell.img.frame.origin.y = 0.2 * cell.contextlbl.frame.size.height
            cell.img.frame.size.width = 0.6 * cell.contextlbl.frame.size.height
            cell.img.frame.size.height = 0.6 * cell.contextlbl.frame.size.height
            // Uh, oh! What could it be?
        }

        if(titlevalue.lowercased().contains("energy")){
            cell.img.image = UIImage.init(named: "energy")
            cell.vv.strokecolor = strokecolor
            if(performance_data["energy"] == nil || performance_data["energy"] is NSNull){
                cell.vv.strokevalue = 0.0
                cell.percentagelbl.text = "0"
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Energy score (Out of 100)"
            }else{
            cell.vv.strokevalue = Double(performance_data["energy"] as! Float)/100.0
                cell.percentagelbl.text = String(format: "%d",Int(performance_data["energy"] as! Float))
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Energy score (Out of 100)"
            }
            cell.contextlbl.text = "ENERGY"
        }else if(titlevalue.lowercased().contains("water")){
            cell.img.image = UIImage.init(named: "water")
            cell.vv.strokecolor = strokecolor
            if(performance_data["water"] == nil || performance_data["water"] is NSNull){
                cell.vv.strokevalue = 0.0
                cell.percentagelbl.text = "0"
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Water score (Out of 100)"
            }else{
                cell.vv.strokevalue = Double(performance_data["water"] as! Float)/100.0
                cell.percentagelbl.text = String(format: "%d",Int(performance_data["water"] as! Float))
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Water score (Out of 100)"
            }
            cell.contextlbl.text = "WATER"
        }
        else if(titlevalue.lowercased().contains("waste")){
            cell.img.image = UIImage.init(named: "waste")
            cell.vv.strokecolor = strokecolor
            if(performance_data["waste"] == nil || performance_data["waste"] is NSNull){
                cell.vv.strokevalue = 0.0
                cell.percentagelbl.text = "0"
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Waste score (Out of 100)"
            }else{
                cell.percentagelbl.text = String(format: "%d",Int(performance_data["waste"] as! Float))
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Waste score (Out of 100)"
                cell.vv.strokevalue = Double(performance_data["waste"] as! Double)/100.0
            }
            cell.contextlbl.text = "WASTE"
        }else if(titlevalue.lowercased().contains("transport")){
            cell.img.image = UIImage.init(named: "transport")
            cell.vv.strokecolor = strokecolor
            if(performance_data["transport"] == nil || performance_data["transport"] is NSNull){
                cell.vv.strokevalue = 0.0
                cell.percentagelbl.text = "0"
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Transportation score (Out of 100)"
            }else{
                cell.vv.strokevalue = Double(performance_data["transport"] as! Float)/100.0
                cell.percentagelbl.text = String(format: "%d",Int(performance_data["transport"] as! Float))
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Transportation score (Out of 100)"
            }
            cell.contextlbl.text = "TRANSPORTATION"
        }else if(titlevalue.lowercased().contains("human")){
            cell.img.image = UIImage.init(named: "human")
            if(indexPath.row == 0){
                cell.vv.strokecolor = strokecolor
                if(performance_data["human_experience"] == nil || performance_data["human_experience"] is NSNull){
                    cell.vv.strokevalue = 0.0
                    cell.percentagelbl.text = "0"
                    cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Human experience score (Out of 100)"
                }else{
                    cell.vv.strokevalue = Double(performance_data["human_experience"] as! Float)/100.0
                    cell.percentagelbl.text = String(format: "%d",Int(performance_data["human_experience"] as! Float))
                    cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Human experience score (Out of 100)"
                }
                cell.contextlbl.text = "HUMAN EXPERIENCE"
                cell.vv.addUntitled1Animation()
            }
            else if(indexPath.row == 1){
                cell.img.image = nil
                if(satisfactionlevel == 0){
                    cell.vv.strokevalue = 0.0
                    cell.percentagelbl.text = "0"
                    cell.contextlbl.text = "% of Occupant satisfaction score (Out of 100)"
                }else{
                    cell.vv.strokevalue = Double(satisfactionlevel)/100.0
                    cell.percentagelbl.text = String(format: "%d",Int(satisfactionlevel))
                    cell.contextlbl.text = "% of Occupant satisfaction (Out of 100)"
                }
                cell.contextlbl.text = "OCCUPANT SATISFACTION"
                cell.vv.strokecolor = strokecolor
                cell.vv.addUntitled1Animation()
            }else if(indexPath.row == 2){
                cell.img.image = nil
                cell.vv.strokecolor = strokecolor
                if(co2 == 0){
                    cell.vv.strokevalue = 0.0
                    cell.percentagelbl.text = "0"
                    cell.contextlbl.text = "% of CO2 level score (Out of 100)"
                }else{
                    cell.vv.strokevalue = Double(co2)/100.0
                    cell.percentagelbl.text = String(format: "%d",Int(co2))
                    cell.contextlbl.text = "% of CO2 level score (Out of 100)"
                }
                cell.contextlbl.text = "CO2 LEVEL"
                cell.vv.strokecolor = strokecolor
                cell.vv.addUntitled1Animation()
            }else if(indexPath.row == 3){
                cell.img.image = nil
                cell.vv.strokecolor = strokecolor
                if(voc == 0){
                    cell.vv.strokevalue = 0.0
                    cell.percentagelbl.text = "0"
                    cell.contextlbl.text = "% of Total VOC level score (Out of 100)"
                }else{
                    cell.vv.strokevalue = Double(voc)/100.0
                    cell.percentagelbl.text = String(format: "%d",Int(voc))
                    cell.contextlbl.text = "% of Total VOC level score (Out of 100)"
                }
                cell.contextlbl.text = "VOC LEVEL"
                cell.vv.strokecolor = strokecolor
                cell.vv.addUntitled1Animation()
            }

        }
        cell.vv.addUntitled1Animation()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showanalysis", sender: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.sview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)        
        if(titlevalue.lowercased().contains("human")){
            getanalysis(UserDefaults.standard.integer(forKey: "leed_id"), token: UserDefaults.standard.object(forKey: "token") as! String)
        }else{
        tableview.reloadData()
        }
    }
    
    
    
    
    func getanalysis(_ leedid:Int,token:String){
        let url = URL(string: "\(credentials().domain_url)assets/LEED:\(leedid)/analysis/")
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        
        
        let tasky = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            var taskerror = false
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }else{
                
                
                if error == nil {
                    
                    
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        ////print("Data",jsonDictionary)
                        if(jsonDictionary["human"] == nil || jsonDictionary["human"] is NSNull){
                            
                        }else{
                            var humandict = (jsonDictionary["human"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if(humandict["info_json"] == nil || humandict["info_json"] is NSNull){
                                
                            }else{
                                DispatchQueue.main.async(execute: {
                                    var tempdata = humandict["info_json"] as! String
                                    tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                                    tempdata = tempdata.replacingOccurrences(of: "None", with: "\"None\"")
                                    //print(tempdata)
                                    var json = NSMutableDictionary()
                                    if(self.convertStringToDictionary(tempdata) != nil){
                                        json = self.convertStringToDictionary(tempdata)! as! NSMutableDictionary
                                    }
                                    ////print("Info json",json)
                                    var d = NSDictionary()
                                    
                                    if(json["Human Experience Subscores (out of 100, weighted equally)"] != nil){
                                     d = json["Human Experience Subscores (out of 100, weighted equally)"] as! NSDictionary
                                    }
                                    if(self.convertStringToDictionary(tempdata) != nil){
                                        if(d["occupant_satisfaction"] != nil && d["occupant_satisfaction"] as? String != "None"){
                                            if let date = d["co2"] as? Float {
                                                self.satisfactionlevel = Double(d["occupant_satisfaction"] as! Float)
                                            }
                                            
                                            if let date = d["co2"] as? Int {
                                                self.satisfactionlevel = Double(d["occupant_satisfaction"] as! Int)
                                            }
                                            
                                        }
                                        if(d["co2"] != nil && d["co2"] as? String != "None"){
                                            
                                            if let date = d["co2"] as? String {
                                                
                                            }
                                            if let date = d["co2"] as? Float {
                                                self.co2 = Double(d["co2"] as! Float)
                                            }
                                            
                                            if let date = d["co2"] as? Int {
                                                self.co2 = Double(d["co2"] as! Int)
                                            }
                                        }
                                        if(d["voc"] != nil){
                                            
                                            if let date = d["co2"] as? Float {
                                                self.voc = Double(d["voc"] as! Float)
                                            }
                                            
                                            if let date = d["co2"] as? Int {
                                                self.voc = Double(d["voc"] as! Int)
                                            }
                                            
                                            
                                        }
                                        //print("Info json",json["Human Experience Inputs"]!["voc"],json["Human Experience Inputs"]!["co2"],d["occupant_satisfaction"])
                                    }
                                    
                                    self.tableview.reloadData()
                                })
                            }
                        }
                    } catch {
                        ////print(error)
                    }
                    
                    
                } else {
                    taskerror = true
                }
            }
        })                
        tasky.resume()
    }
    
    func convertStringToDictionary(_ text: String) -> NSMutableDictionary? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = (try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                return json
            } catch {
                //print("Something went wrong")
            }
        }
        return nil
    }
    
    var voc = Double(0)
    var satisfactionlevel = Double(0)
    var co2 = Double(0)
    
    @IBOutlet weak var vv: individual!
    @IBOutlet weak var sview: UIScrollView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

