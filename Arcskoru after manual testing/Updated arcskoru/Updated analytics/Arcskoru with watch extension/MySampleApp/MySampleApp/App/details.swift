//
//  details.swift
//  Analytics
//
//  Created by Group X on 01/06/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit
import Foundation

class details: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tabbar: UITabBar!
    var currentcolor = UIColor()
    var currentscore = Int()
    var details_dict1 = NSArray()
    var details_dict2 = NSArray()
    var currentcategory = ""
    func roundx(x:Int) -> Int{
        var fnum = Double(x)/5.0
        let rnum = Int(ceil(fnum))
        return rnum * 5
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
        let notificationsarr = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "notifications") as! Data) as! NSArray
        let plaque = UIImage.init(named: "score")
        let credits = UIImage.init(named: "Menu_icon")
        let analytics = UIImage.init(named: "chart")
        let more = UIImage.init(named: "more")
        self.tabbar.setItems([UITabBarItem.init(title: "Score", image: plaque, tag: 0),UITabBarItem.init(title: "Credits/Actions", image: credits, tag: 1),UITabBarItem.init(title: "Analytics", image: analytics, tag: 2),UITabBarItem.init(title: "More", image: more, tag: 3)], animated: false)
        self.tabbar.selectedItem = self.tabbar.items![2]
        if(notificationsarr.count > 0 ){
            
            self.tabbar.items![3].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![3].badgeValue = nil
        }

        tableview.register(UINib.init(nibName: "row1", bundle: nil), forCellReuseIdentifier: "row1")
        tableview.register(UINib.init(nibName: "extradetails", bundle: nil), forCellReuseIdentifier: "cell")
        tableview.register(UINib.init(nibName: "totalanalysis3", bundle: nil), forCellReuseIdentifier: "totalanalysis3")
        tableview.register(UINib.init(nibName: "totalanalysis2", bundle: nil), forCellReuseIdentifier: "totalanalysis2")
        var temp = [Int]()
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "effective_at", ascending: true)
        var sortedResults: NSArray = reportedscores.sortedArray(using: [descriptor]) as! NSArray
        reportedscores = sortedResults.mutableCopy() as! NSMutableArray
  
        
        
        for  i  in 0 ..< reportedscores.count{
            let arr = reportedscores[i] as! NSDictionary
            if let v = arr["scores"] as? NSDictionary{
            var a = arr["scores"] as! NSDictionary
            if(currentcategory == "Energy"){
                if(a["energy"] == nil || a["energy"] is NSNull){
                        temp.append(0)
                }else{
                    temp.append(Int(a["energy"] as! Int))
                }
            }else if(currentcategory == "Water"){
                if(a["water"] == nil || a["water"] is NSNull){
                    temp.append(0)
                }else{
                    temp.append(Int(a["water"] as! Int))
                }
            }else if(currentcategory == "Waste"){
                if(a["waste"] == nil || a["waste"] is NSNull){
                    temp.append(0)
                }else{
                    temp.append(Int(a["waste"] as! Int))
                }
            }else if(currentcategory == "Transportation"){
                if(a["transport"] == nil || a["transport"] is NSNull){
                    temp.append(0)
                }else{
                    temp.append(Int(a["transport"] as! Int))
                }
            }else{
                if(a["human_experience"] == nil || a["human_experience"] is NSNull){
                    temp.append(0)
                }else{
                    temp.append(Int(a["human_experience"] as! Int))
                }
            }
            }else{
                temp.append(0)
            }
        }
        //print(percentagearr,reductionarr)
        //print(percentagearr1,reductionarr1)
        var tempdict1 = NSMutableDictionary()
        for item in 0 ..< reductionarr1.count{
            
            let reduction = reductionarr1[item] as! Int
            let percentage = percentagearr1[item] as! Int
            tempdict1.setValue(percentage, forKey: "\(reduction)")
        }
        
        reductionarr1 = NSMutableArray.init(array: (tempdict1.allKeys as! [String]).sorted())
        tempdict = tempdict1
        grapharray = temp
        
        //print(tempdict1, reductionarr1)
        
        
        // Do any additional setup after loading the view.
    }

    var tempdict = NSMutableDictionary()
    var grapharray = [Int]()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(reductionarr.count > 0){
            if(section == 1){
            return "Emissions data"
            }else if(section == 2){
            return "Tools"
            }
        }else{
            if(section == 1){
                if(details_dict2.count > 0){
                    return "Emissions data"
                }
               return "No Emissions data present"
            }
        }
        
        return name
    }
    
    var reportedscores = NSMutableArray()
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        if(indexPath.section == 2){
            if(reductionarr.count > 0 && reductionarr1.count > 0){
                return 0.35 * UIScreen.main.bounds.size.height
            }else if(reductionarr.count > 0 || reductionarr1.count > 0){
                return 0.175 * UIScreen.main.bounds.size.height
            }
            return 0.088 * UIScreen.main.bounds.size.height
        }
        if(indexPath.section == 1){
            
            return 0.105 * UIScreen.main.bounds.size.height
        }
        return 0.316 * UIScreen.main.bounds.size.height
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if(reductionarr.count > 0){
        return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 2){
            if(reductionarr1.count > 0 || percentagearr.count > 0){
            return 1
            }
            return 0
        }
        if(section == 1){
            return details_dict1.count
        }
        
        
        return 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        self.navigationItem.title = dict["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = "Analytics"
    }
    
    
    var name = String()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        if(indexPath.section == 0){
        let cell = tableView.dequeueReusableCell(withIdentifier: "row1", for: indexPath) as! row1
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        if(currentcategory == "Energy"){
            cell.vv.startColorr =   UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            cell.vv.endColorr = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            cell.vv.endColor = UIColor.white//UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            cell.vv.startColor = UIColor.white//UIColor.init(red: 0.860, green: 0.871, blue: 0.734, alpha: 1)
            
        }else if(currentcategory == "Water"){
            //cell.vv.heading.text = String(format:"Meter %d", indexPath.section)            
            cell.vv.startColorr = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
            cell.vv.endColorr = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
            
        }else if(currentcategory == "Waste"){
            
            cell.vv.startColorr = UIColor.init(red: 129/255, green: 205/255, blue: 174/255, alpha: 1)
            cell.vv.endColorr = UIColor.init(red: 129/255, green: 205/255, blue: 174/255, alpha: 1)
        }else if(currentcategory == "Transportation"){
            
            cell.vv.startColorr = UIColor.init(red: 164/255, green: 160/255, blue: 146/255, alpha: 1)
            cell.vv.endColorr = UIColor.init(red: 164/255, green: 160/255, blue: 146/255, alpha: 1)
            
        }else if(currentcategory == "Human Experience"){
            cell.vv.startColorr = UIColor.init(red: 242/255, green: 172/255, blue: 65/255, alpha: 1)
            cell.vv.endColorr = UIColor.init(red: 242/255, green: 172/255, blue: 65/255, alpha: 1)
            
        }
        cell.maxscore.text = "\(roundx(x:currentscore))"
        if(cell.maxscore.text == "0"){
            cell.maxscore.text = "\(roundx(x:currentscore) as! Int)"
        }
        cell.vv.maxscore = roundx(x:currentscore)
        //cell.vv.endColor = cell.vv.endColorr//UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
        //cell.vv.startColor = cell.vv.startColorr        
        cell.contentView.backgroundColor = UIColor.white
        //cell.vv.endColor = UIColor.white
        //cell.vv.startColor = UIColor.white
        print(grapharray)
            if(grapharray.count == 12){
            grapharray[11] = currentscore
            }
        cell.vv.graphPoints = grapharray
        return cell
        }else if(indexPath.section == 2){
            if(reductionarr.count > 0 && reductionarr1.count > 0){
            let energyscoreedata = reductionarr
            let energypercentagedata = percentagearr1
            let cell = tableview.dequeueReusableCell(withIdentifier: "totalanalysis3", for: indexPath) as! totalanalysis3
            let total: Float = 5
            cell.slider1.minimumValue = 0.0
            cell.slider1.tag = 10
                cell.slider2.tag = 20
                cell.l1.tag = 1001
                cell.l2.tag = 1002
                
                cell.l3.tag = 2001
                cell.l4.tag = 2002
                
            var temparr = NSMutableArray()
            var temparr1 = NSMutableArray()
            if(energyscoreedata.count > 0 && energypercentagedata.count > 0){
                temparr1 = energyscoreedata
                temparr = energypercentagedata
            }else if(energyscoreedata.count > 0 && energypercentagedata.count == 0){
                temparr = energyscoreedata
            }else if(energyscoreedata.count == 0 && energypercentagedata.count > 0){
                temparr = energypercentagedata
            }
                
            cell.slider1.maximumValue = Float(temparr1.count-1)
            cell.slider2.maximumValue = Float(temparr.count-1)
            cell.slider2.minimumValue = 0.0
            cell.slider1.value = 0.0
            cell.slider1.setValue(0.0, animated: true)
            cell.slider2.setValue(0.0, animated: true)
                temparr = percentagearr
            var tempstr = "\(temparr.object(at: energy1sel) as! Int)"
            let tempvalue = "\(temparr1.object(at: energy1sel) as! String)"
            tempstr = tempstr.replacingOccurrences(of: "\(name.capitalized) Plaque Score with", with:"")
            tempstr = tempstr.replacingOccurrences(of: "Lower Emissions", with: "")
            tempstr = tempstr.replacingOccurrences(of: " ", with: "")
            cell.l1.text = "If I reduce my emissions by \(tempstr )% of \(currentscore )"
            cell.l2.text = "My new \(name as! String) score will be \(tempvalue)"
            temparr = percentagearr1
            tempstr = tempstr.replacingOccurrences(of: "Percent emissions reduction for a plaque score of", with: "")
            tempstr = tempstr.replacingOccurrences(of: " ", with: "")
            var tempstr1 = "\(temparr1.object(at: energy2sel) as! String)"
            var tempvalue1 = "\(temparr.object(at: energy2sel) as! Int)"
            tempstr1 = tempstr1.replacingOccurrences(of: "\(name.capitalized) Plaque Score with", with: "")
            tempstr1 = tempstr1.replacingOccurrences(of: "Lower Emissions", with: "")
            tempstr1 = tempstr1.replacingOccurrences(of: " ", with: "")
            
            cell.l3.text = "If I want to increase my score to +\(abs(currentscore - (Int(reductionarr1[energy2sel] as! String)!)))"
            cell.l4.text = "I need to reduce my emission by \(tempdict[reductionarr1[energy2sel] as! String] as! Int)% of \(currentscore )"
            cell.contentView.bringSubview(toFront: cell.slider1)
            cell.contentView.bringSubview(toFront: cell.slider2)
            cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), for: UIControlEvents.valueChanged)
            
            cell.slider2.addTarget(self, action: #selector(self.slider2Changed(_:)), for: UIControlEvents.valueChanged)
            cell.slider1.setValue(Float(energy2sel), animated: true)
            cell.slider1.value = Float(energy1sel)
            cell.slider1.setValue(Float(energy1sel), animated: true)
            cell.slider1.value = Float(energy1sel)
                UIView.animate(withDuration: 0.2, animations: {
                    cell.slider1.setValue(0, animated:true)
                })
            //cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
            //cell.typename.text = "ENERGY"
            //cell.outoflbl.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            //cell.typename.textColor = cell.outoflbl.textColor
            
        return cell
            }else if(reductionarr1.count > 0 || reductionarr.count > 0){
                if(reductionarr1.count > 0){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "totalanalysis2", for: indexPath) as! totalanalysis2
                    let total: Float = 5
                    cell.slider.minimumValue = 0.0
                    cell.slider.tag = 20
                    cell.l1.tag = 2001
                    cell.l2.tag = 2002
                    
                    var temparr = NSMutableArray()
                    var temparr1 = NSMutableArray()
                    if(reductionarr1.count > 0 && percentagearr1.count > 0){
                        temparr = percentagearr1
                        temparr1 = reductionarr1
                    }else if(reductionarr1.count > 0 && percentagearr1.count == 0){
                        temparr = reductionarr1
                    }else if(reductionarr1.count == 0 && percentagearr1.count > 0){
                        temparr = percentagearr1
                    }
                    
                    cell.slider.maximumValue = Float(temparr1.count-1)
                    cell.slider.minimumValue = 0.0
                    cell.slider.setValue(0.0, animated: true)
                    var tempstr = "\(temparr.object(at: energy1sel) as! Int)"
                    var tempvalue = "\(temparr1.object(at: energy1sel) as! String)"
                    tempstr = tempstr.replacingOccurrences(of: "Energy Plaque Score with", with:"")
                    tempstr = tempstr.replacingOccurrences(of: "Lower Emissions", with: "")
                    tempstr = tempstr.replacingOccurrences(of: " ", with: "")
                    
                    tempstr = tempstr.replacingOccurrences(of: "Percent emissions reduction for a plaque score of", with: "")
                    tempstr = tempstr.replacingOccurrences(of: " ", with: "")
                    var tempstr1 = "\(temparr1.object(at: energy2sel) as! String)"
                    var tempvalue1 = "\(temparr.object(at: energy2sel) as! Int)"
                    tempstr1 = tempstr1.replacingOccurrences(of: "Energy Plaque Score with", with: "")
                    tempstr1 = tempstr1.replacingOccurrences(of: "Lower Emissions", with: "")
                    tempstr1 = tempstr1.replacingOccurrences(of: " ", with: "")
                    

                    
                    cell.l1.text = "If I want to increase my score to +\(abs(currentscore - (Int(reductionarr1[energy2sel] as! String)!)))"
                    cell.l2.text = "I need to reduce my emission by \(tempdict[reductionarr1[energy2sel] as! String] as! Int)% of \(currentscore )"
                    cell.contentView.bringSubview(toFront: cell.slider)
                    cell.slider.addTarget(self, action: #selector(self.slider2Changed(_:)), for: UIControlEvents.valueChanged)
                    
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "totalanalysis2", for: indexPath) as! totalanalysis2
                    let total: Float = 5
                    cell.slider.minimumValue = 0.0
                    cell.slider.tag = 10
                    cell.l1.tag = 1001
                    cell.l2.tag = 1002
                    
                    var temparr = NSMutableArray()
                    var temparr1 = NSMutableArray()
                    if(reductionarr.count > 0 && percentagearr.count > 0){
                        temparr = percentagearr
                        temparr1 = reductionarr
                    }else if(reductionarr.count > 0 && percentagearr.count == 0){
                        temparr = reductionarr
                    }else if(reductionarr.count == 0 && percentagearr.count > 0){
                        temparr = percentagearr
                    }
                    
                    cell.slider.maximumValue = Float(temparr1.count-1)
                    cell.slider.minimumValue = 0.0
                    cell.slider.setValue(0.0, animated: true)
                    var tempstr = "\(temparr.object(at: energy1sel) as! Int)"
                    let tempvalue = "\(temparr1.object(at: energy1sel) as! String)"
                    tempstr = tempstr.replacingOccurrences(of: "Energy Plaque Score with", with:"")
                    tempstr = tempstr.replacingOccurrences(of: "Lower Emissions", with: "")
                    tempstr = tempstr.replacingOccurrences(of: " ", with: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr )% of \(currentscore )"
                    cell.l2.text = "My new \(name as! String) score will be \(tempvalue)"
                    cell.contentView.bringSubview(toFront: cell.slider)
                    cell.slider.addTarget(self, action: #selector(self.slider1Changed(_:)), for: UIControlEvents.valueChanged)
                    
                    return cell
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! extradetails
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.detailTextLabel?.text = "asda"
            cell.textLabel?.text = details_dict1[indexPath.row] as! String
            cell.detailTextLabel?.text = details_dict2[indexPath.row] as! String
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! extradetails
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.detailTextLabel?.text = "asda"
        cell.textLabel?.text = details_dict1[indexPath.row] as! String
        cell.detailTextLabel?.text = details_dict2[indexPath.row] as! String
        return cell
        
    }
    
    
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
    
    func c(_ sender : AnyObject){
        
    }
    
    var step = Float(1)
    var step1 = Float(1)
    var reductionarr = NSMutableArray()
    var percentagearr = NSMutableArray()
    var reductionarr1 = NSMutableArray()
    var percentagearr1 = NSMutableArray()
    
    func slider1Changed(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        ////print(sender.value,sender.tag)
            //1st energy slider1
            var temparr = NSMutableArray()
            var temparr1 = NSMutableArray()
            if(reductionarr.count > 0 && percentagearr.count > 0){
                temparr = percentagearr
                temparr1 = reductionarr
            }else if(reductionarr.count > 0 && percentagearr.count == 0){
                temparr = reductionarr
            }else if(reductionarr.count == 0 && percentagearr.count > 0){
                temparr = percentagearr
            }
            let cell = tableview.cellForRow(at: IndexPath.init(row: 0, section: 2))
            if(cell is totalanalysis3){
                let c = cell as! totalanalysis3
                var tempstr = "\(temparr.object(at: Int(sender.value)))"
                let tempvalue = "\(temparr1.object(at: Int(sender.value)))"
                tempstr = tempstr.replacingOccurrences(of: "\(name.capitalized) Plaque Score with", with: "")
                tempstr = tempstr.replacingOccurrences(of: "Lower Emissions", with: "")
                tempstr = tempstr.replacingOccurrences(of: " ", with: "")
                c.l1.text = "If I reduce my emissions by \(tempstr )% of \(currentscore )"
                c.l2.text = "My new \(name as! String) score will be \(Int(tempvalue ))"
                (self.view.viewWithTag(1001) as! UILabel).text = "If I reduce my emissions by \(tempstr )% of \(currentscore )"
                (self.view.viewWithTag(1002) as! UILabel).text = "My new \(name as! String) score will be \((tempvalue ))"
                ////print(Int(sender.value))
                ////print(temparr.count)
            }else{
                let c = cell as! totalanalysis2
                var tempstr = "\(temparr.object(at: Int(sender.value)))"
                let tempvalue = "\(temparr1.object(at: Int(sender.value)))"
                tempstr = tempstr.replacingOccurrences(of: "\(name.capitalized) Plaque Score with", with: "")
                tempstr = tempstr.replacingOccurrences(of: "Lower Emissions", with: "")
                tempstr = tempstr.replacingOccurrences(of: " ", with: "")
                c.l1.text = "If I reduce my emissions by \(tempstr )% of \(currentscore )"
                c.l2.text = "My new \(name as! String) score will be \(Int(tempvalue ))"
                (self.view.viewWithTag(1001) as! UILabel).text = "If I reduce my emissions by \(tempstr )% of \(currentscore )"
                (self.view.viewWithTag(1002) as! UILabel).text = "My new \(name as! String) score will be \((tempvalue ))"
            }
            energy1sel = Int(sender.value)
    }

    
    func slider2Changed(_ sender: UISlider) {
        let roundedValue = round(sender.value / step1) * step1
        sender.value = roundedValue
        ////print(sender.value,sender.tag)
        //1st energy slider1
        var temparr = NSMutableArray()
        var temparr1 = NSMutableArray()
        if(reductionarr1.count > 0 && percentagearr1.count > 0){
            temparr = reductionarr1
            temparr1 = percentagearr1
        }else if(reductionarr1.count > 0 && percentagearr1.count == 0){
            temparr = reductionarr1
        }else if(reductionarr1.count == 0 && percentagearr1.count > 0){
            temparr = percentagearr1
        }
        let cell = tableview.cellForRow(at: IndexPath.init(row: 0, section: 2))
        if(cell is totalanalysis3){
            let c = cell as! totalanalysis3
            var tempstr = "\(temparr.object(at: Int(sender.value)))"
            let tempvalue = "\(temparr1.object(at: Int(sender.value)))"
            tempstr = tempstr.replacingOccurrences(of: "\(name.capitalized) Plaque Score with", with: "")
            tempstr = tempstr.replacingOccurrences(of: "Lower Emissions", with: "")
            tempstr = tempstr.replacingOccurrences(of: " ", with: "")
            c.l3.text = "If I want to increase my score to \(tempstr )"
            c.l4.text = "I need to reduce my emission by \(tempvalue )% of \(currentscore )"
            (self.view.viewWithTag(2001) as! UILabel).text = "If I want to increase my score to \(tempstr )"
            (self.view.viewWithTag(2002) as! UILabel).text = "I need to reduce my emission by \(tempvalue )% of \(currentscore )"
            
            
            (self.view.viewWithTag(2001) as! UILabel).text = "If I want to increase my score to +\(abs(currentscore - (Int(reductionarr1[Int(sender.value)] as! String)!)))"
            (self.view.viewWithTag(2002) as! UILabel).text = "I need to reduce my emission by \(tempdict[reductionarr1[Int(sender.value)] as! String] as! Int)% of \(currentscore )"
            
            ////print(Int(sender.value))
            ////print(temparr.count)
        }else{
            let c = cell as! totalanalysis2
            var tempstr = "\(temparr.object(at: Int(sender.value)))"
            let tempvalue = "\(temparr1.object(at: Int(sender.value)))"
            tempstr = tempstr.replacingOccurrences(of: "Energy Plaque Score with", with: "")
            tempstr = tempstr.replacingOccurrences(of: "Lower Emissions", with: "")
            tempstr = tempstr.replacingOccurrences(of: " ", with: "")
            c.l1.text = "If I want to increase my score to \(tempstr )"
            c.l2.text = "I need to reduce my emission by \(tempvalue )% of \(currentscore )"
            (self.view.viewWithTag(2001) as! UILabel).text = "If I want to increase my score to \(tempstr )"
            (self.view.viewWithTag(2002) as! UILabel).text = "I need to reduce my emission by \(tempvalue )% of \(currentscore )"
                        
            (self.view.viewWithTag(2001) as! UILabel).text = "If I want to increase my score to +\(abs(currentscore - (Int(reductionarr1[Int(sender.value)] as! String)!)))"
            (self.view.viewWithTag(2002) as! UILabel).text = "I need to reduce my emission by \(tempdict[reductionarr1[Int(sender.value)] as! String] as! Int)% of \(currentscore )"
        }
        energy2sel = Int(sender.value)
    }

    
    var energy1sel = 0
    var energy2sel = 0
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(reductionarr.count > 0){
            if(section == 2){
                return 10
            }
        }else{
            if(section == 1){
                return 10
            }
        }
        return 1
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
