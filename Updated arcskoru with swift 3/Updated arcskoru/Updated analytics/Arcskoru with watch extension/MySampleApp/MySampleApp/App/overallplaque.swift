//
//  ContentViewController.swift
//  LEEDOn
//
//  Created by Group X on 29/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class overallplaque: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var pageIndex = 0
    var titleText = "123"
    var contexts = "asd"
    var energyscorevalue = 0, waterscorevalue = 0, wastescorevalue = 0, transportscorevalue = 0, humanscorevalue = 0
    var basescorevalue = 0
    var energymaxscorevalue = 0, watermaxscorevalue = 0, wastemaxscorevalue = 0, transportmaxscorevalue = 0, humanmaxscorevalue = 10
    var w = 0.8 * UIScreen.main.bounds.size.width
    var colorarr = [UIColor.red,UIColor.orange,UIColor.blue,UIColor.white,UIColor.brown,UIColor.darkGray]
    var performance_data = NSMutableDictionary()
    var strokecolor = UIColor.blue
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        if(UserDefaults.standard.object(forKey: "performance_data") != nil){
        performance_data = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "performance_data") as! Data) as! NSMutableDictionary
        }
        tableview.register(UINib.init(nibName: "progresscell", bundle: nil), forCellReuseIdentifier: "progresscell")
        self.titlefont()
        //print("Size",w,0.8 * UIScreen.main.bounds.size.height)
        self.view.backgroundColor = UIColor.white
        self.vv.backgroundColor = UIColor.clear
        self.vv.setNeedsDisplay()
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
        let v = UIScreen.main.bounds.size.width
        self.vv.frame.size.height = v
        self.vv.frame.size.width = v
        }else{
            let v = UIScreen.main.bounds.size.height
            self.vv.frame.size.height = v
            self.vv.frame.size.width = v
        }
        sview.isScrollEnabled = true
        self.vv.center = CGPoint(x: UIScreen.main.bounds.size.width/2,y: UIScreen.main.bounds.size.height/3.6);
        self.tableview.frame.origin.y = self.vv.center.y 
        self.tableview.center = CGPoint(x: UIScreen.main.bounds.size.width/2,y: self.vv.center.y + (self.vv.frame.size.height * 0.8));
        self.tableview.frame.size.height = 7 * (0.095 * self.view.frame.size.height)
        sview.contentSize =  CGSize(width: UIScreen.main.bounds.size.width, height: self.vv.layer.frame.size.height + self.tableview.layer.frame.size.height)
        self.tableview.isScrollEnabled = false
        vv.energyscorevalue = energyscorevalue
        vv.energymaxscorevalue = energymaxscorevalue
        vv.waterscorevalue = waterscorevalue
        vv.watermaxscorevalue = watermaxscorevalue
        vv.wastescorevalue = wastescorevalue
        vv.wastemaxscorevalue = wastemaxscorevalue
        vv.transportscorevalue = transportscorevalue
        vv.transportmaxscorevalue = transportmaxscorevalue
        vv.humanscorevalue = humanscorevalue
        vv.basescorevalue = basescorevalue
        vv.humanmaxscorevalue = humanmaxscorevalue
        
        vv.addUntitled1Animation()
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 4){
            //return 4
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "progresscell", for: indexPath) as! progresscell        
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

        
        if(indexPath.section == 0){
            cell.img.image = UIImage.init(named: "energy")
            strokecolor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            cell.vv.strokecolor = strokecolor
            if(performance_data["energy"] == nil || performance_data["energy"] is NSNull){
                cell.vv.strokevalue = 0.0
                cell.percentagelbl.text = "0"
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Energy score (Out of 100)"
            }else{
                cell.vv.strokevalue = Double(performance_data["energy"] as! Float)/100.0
                //print(performance_data["energy"])
                cell.percentagelbl.text = String(format: "%d",Int(performance_data["energy"] as! Float))
                cell.contextlbl.text = "\(cell.percentagelbl.text! )% of Energy score (Out of 100)"
            }
            cell.contextlbl.text = "ENERGY"
        }else if(indexPath.section == 1){
            cell.img.image = UIImage.init(named: "water")
            strokecolor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
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
        else if(indexPath.section == 2){
            cell.img.image = UIImage.init(named: "waste")
            strokecolor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
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
        }else if(indexPath.section == 3){
            cell.img.image = UIImage.init(named: "transport")
            strokecolor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
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
        }else if(indexPath.section == 4){
            cell.img.image = UIImage.init(named: "human")
            strokecolor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
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
            }
            cell.contextlbl.text = "HUMAN EXPERIENCE"
        }
        cell.vv.addUntitled1Animation()
        return cell

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showanalysis", sender: nil)
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
                                if(self.convertStringToDictionary(tempdata) != nil){
                                var d = json["Human Experience Subscores (out of 100, weighted equally)"] as! NSDictionary
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

    
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var sview: UIScrollView!
    
    @IBOutlet weak var vv: dashboardview!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getanalysis(UserDefaults.standard.integer(forKey: "leed_id"), token: UserDefaults.standard.object(forKey: "token") as! String)
    }
    
    @IBOutlet weak var cc: UIView!
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
   
    
}
