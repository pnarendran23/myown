//
//  more.swift
//  LEEDOn
//
//  Created by Group X on 28/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class more: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UINavigationControllerDelegate {
    var notificationsarr = NSArray()
    @IBOutlet weak var tableview: UITableView!
    var categoryarr = ["Project","Team","Certifications","Billing","Settings"] 
    @IBOutlet weak var nav: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.setAnimationsEnabled(true)
        self.navigationController!.hidesBarsOnTap = false;
        self.navigationController!.hidesBarsOnSwipe = false;
        self.navigationController!.hidesBarsWhenKeyboardAppears = false;
        self.navigationController!.hidesBarsWhenVerticallyCompact = false;
        self.navigationController?.setNavigationBarHidden(false, animated: true)                
        self.titlefont()
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        tableview.layer.cornerRadius = 10
        let plaque = UIImage.init(named: "score")
        let credits = UIImage.init(named: "Menu_icon")
        let analytics = UIImage.init(named: "chart")
        let more = UIImage.init(named: "more")
        self.tabbar.setItems([UITabBarItem.init(title: "Score", image: plaque, tag: 0),UITabBarItem.init(title: "Credits/Actions", image: credits, tag: 1),UITabBarItem.init(title: "Analytics", image: analytics, tag: 2),UITabBarItem.init(title: "More", image: more, tag: 3)], animated: false)
        self.tabbar.selectedItem = self.tabbar.items![3]
        tableview.register(UINib.init(nibName: "managecell", bundle: nil), forCellReuseIdentifier: "managecell")
        tableview.register(UINib.init(nibName: "morecell", bundle: nil), forCellReuseIdentifier: "morecell")
        tableview.register(UINib.init(nibName: "surveycategorytick", bundle: nil), forCellReuseIdentifier: "surveycell")
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        building_dict = buildingdetails as NSDictionary
        assetname.text = buildingdetails["name"] as? String
        self.navigationItem.title = buildingdetails["name"] as? String
        let navItem = UINavigationItem(title: (buildingdetails["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        
        if(UserDefaults.standard.integer(forKey: "survey") == 1){
            self.tabbar.isHidden = true
        }else{
        notificationsarr = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "notifications") as! Data) as! NSArray
        }
        // Do any additional setup after loading the view.
    }
    
    var building_dict = NSDictionary()
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.delegate = nil
        //self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        if(UserDefaults.standard.integer(forKey: "survey") == 1){
        self.navigationController?.navigationBar.backItem?.title = "Login"    
        }else{
        self.navigationController?.navigationBar.backItem?.title = "Projects"
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tableview.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UserDefaults.standard.set(0, forKey: "closeall")
        self.navigationController?.delegate = self
        self.view.alpha = 1
        UIApplication.shared.isStatusBarHidden = false
        /*if((UIDevice.currentDevice().orientation != UIDeviceOrientation.Portrait)&&(UIDevice.currentDevice().orientation != UIDeviceOrientation.PortraitUpsideDown)){
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }*/
        
       /* if((UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait)||(UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown)){
            
            if((UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait)){
                var value = UIInterfaceOrientation.PortraitUpsideDown.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
                value = UIInterfaceOrientation.Portrait.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
            }
            if((UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown)){
                var value = UIInterfaceOrientation.Portrait.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
                value = UIInterfaceOrientation.PortraitUpsideDown.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
            }
            
        }else{
            if((UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft)){
                var value = UIInterfaceOrientation.LandscapeRight.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
                value = UIInterfaceOrientation.LandscapeLeft.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
            }
            if((UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight)){
                var value = UIInterfaceOrientation.LandscapeLeft.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
                value = UIInterfaceOrientation.LandscapeRight.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
            }
        }
        */
        
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsWhenKeyboardAppears = false
        self.navigationController?.hidesBarsWhenVerticallyCompact = false
        self.tableview.reloadData()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController.restorationIdentifier == "smiley" || viewController.restorationIdentifier == "complaint" || viewController.restorationIdentifier == "listroutes" || viewController.restorationIdentifier == "addnewroute"){
            
            if((UIDevice.current.orientation == UIDeviceOrientation.portrait)||(UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown)){
         
            }else{
                let value = UIInterfaceOrientation.portrait.rawValue
                //UIDevice.currentDevice().setValue(value, forKey: "orientation")
            }
            
        }else{
            UIView.setAnimationsEnabled(true)
        }
    }
    
    
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"listofassets"])
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
         return 2
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
        return 1
        }
        if(section == 1){
            return 5
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1){
            return "MANAGE"
        }else if(section == 0){
            return ""
        }
        
        return "OCCUPANT SURVEY"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != 0){
            return 15
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section != 0){
            return 15
        }
        return 15
    }
    
    func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 1){
        let c = tableView.dequeueReusableCell(withIdentifier: "morecell")! as! morecell
        let cell = tableView.dequeueReusableCell(withIdentifier: "managecell")! as! managecell
        //cell.title.text = categoryarr.objectAtIndex(indexPath.row) as? String
        cell.lbl.text = categoryarr[indexPath.row] as! String
            cell.lbl.font = c.title.font
        if(indexPath.row == 0){
            cell.img.image = UIImage(named:"grid.png")
            
        }else if(indexPath.row == 1){
            cell.img.image = UIImage(named:"user.png")
        }else if(indexPath.row == 2){
            cell.img.image = UIImage(named:"certifications.png")            
            //cell.img.image = self.imageWithImage(UIImage(named:"star.png")!, scaledToSize: CGSize(width:30, height: 30))
        }else if(indexPath.row == 3){
            cell.img.image = UIImage.init(named: "creditcard.png")
        }else if(indexPath.row == 4){
            cell.img.image = UIImage.init(named: "gear.png")            
        }
        //cell.badge.hidden = true
        return cell
    }
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "morecell")! as! morecell
            cell.badge.isHidden = false
            if(UserDefaults.standard.integer(forKey: "survey") == 1){
             cell.isUserInteractionEnabled = false
                cell.contentView.alpha = 0.4
            }else{
                cell.isUserInteractionEnabled = true
                cell.contentView.alpha = 1
            }
            
        if(indexPath.row == 0){
            cell.title.text = "Notifications"
            cell.badge.setTitle("\(notificationsarr.count)", for: UIControlState())
        }else {
            cell.title.text = "Profile"
            cell.badge.setTitle("0", for: UIControlState())
        }
        if(cell.badge.titleLabel?.text == "0"){
            cell.badge.isHidden = true
        }
            return cell
        }
        if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "surveycell")! as! surveycategorytick
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            if(indexPath.row == 0){
            cell.label.text = "Plaque animation"
            cell.img.image = UIImage.init(named: "ic_lomobile_login_plaque.png")
            cell.tickimg.isHidden = true
            }
            else if(indexPath.row == 1){
                cell.label.text = "Human experience"
                cell.tickimg.isHidden = true
                
                cell.img.image = UIImage.init(named: "ic_lomobile_navitem_human.png")
                cell.tickimg.isHidden = Bool(UserDefaults.standard.integer(forKey: "humanhide") as! NSNumber)
                
            }
            else if(indexPath.row == 2){
                cell.label.text = "Transportation"
                cell.tickimg.isHidden = true
                cell.img.image = UIImage.init(named: "ic_lomobile_navitem_transport.png")
                cell.tickimg.isHidden = Bool(UserDefaults.standard.integer(forKey: "transithide") as! NSNumber)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
            return 0.067 * UIScreen.main.bounds.size.height;
        }
        return 0.067 * UIScreen.main.bounds.size.width;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                self.performSegue(withIdentifier: "gotonotifications", sender: nil)
            }
        }else if(indexPath.section == 1){
            tableView.deselectRow(at: indexPath, animated: true)
            if(indexPath.row == 0){
                
                var temp = ""
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
                if((dict["project_type"] as! String).lowercased() == "city" || (dict["project_type"] as! String).lowercased() == "community"){
                    temp = "manageacity"
                }else{
                    temp = "gotoproject"
                }
                self.performSegue(withIdentifier: temp, sender: nil)
            }else if(indexPath.row == 1){
                self.performSegue(withIdentifier: "gototeam", sender: nil)
            }else if(indexPath.row == 2){
                self.performSegue(withIdentifier: "gotocertifications", sender: nil)
            }else if(indexPath.row == 3){
                self.performSegue(withIdentifier: "gotobilling", sender: nil)
            }else if(indexPath.row == 4){
                self.performSegue(withIdentifier: "gotosettings", sender: nil)
            }
        }else{
            if(indexPath.row == 1){
                self.performSegue(withIdentifier: "gotohuman", sender: nil)
            }else if (indexPath.row == 2){
                //print("Mut is ",UserDefaults.standard.object(forKey: "mainarray"))
                let mut = NSMutableArray.init(array: UserDefaults.standard.object(forKey: "mainarray") as! NSArray).mutableCopy()
                if((mut as AnyObject).count == 0){
                    self.performSegue(withIdentifier: "transit", sender: nil)
                }else{
                    UserDefaults.standard.set(0, forKey: "added")
                    self.performSegue(withIdentifier: "listofroutes", sender: nil)
                }     
            }else if(indexPath.row == 0){
                self.view.alpha = 0.0
                UIApplication.shared.isStatusBarHidden = true
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.performSegue(withIdentifier: "dynamicplaque", sender: nil)
            }
        }
    }
    @IBOutlet weak var assetname: UILabel!
    
    @IBOutlet weak var tabbar: UITabBar!
  
    @IBOutlet weak var backbtn: UIButton!
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
