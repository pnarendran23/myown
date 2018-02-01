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
        self.tabbar.selectedItem = self.tabbar.items![4]
        
        tableview.registerNib(UINib.init(nibName: "morecell", bundle: nil), forCellReuseIdentifier: "morecell")
        tableview.registerNib(UINib.init(nibName: "surveycategorytick", bundle: nil), forCellReuseIdentifier: "surveycell")
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        assetname.text = buildingdetails["name"] as? String
        self.navigationItem.title = buildingdetails["name"] as? String
        let navItem = UINavigationItem(title: (buildingdetails["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .Plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("survey") == 1){
            self.tabbar.hidden = true
        }else{
        notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    override func viewDidDisappear(animated: Bool) {
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.delegate = nil
        //self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        if(NSUserDefaults.standardUserDefaults().integerForKey("survey") == 1){
        self.navigationController?.navigationBar.backItem?.title = "Login"    
        }else{
        self.navigationController?.navigationBar.backItem?.title = "Projects"
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tableview.reloadData()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.delegate = self
        self.view.alpha = 1
        UIApplication.sharedApplication().statusBarHidden = false
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
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if(viewController.restorationIdentifier == "smiley" || viewController.restorationIdentifier == "complaint" || viewController.restorationIdentifier == "listroutes" || viewController.restorationIdentifier == "addnewroute"){
            
            if((UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait)||(UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown)){
         
            }else{
                let value = UIInterfaceOrientation.Portrait.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
            }
            
        }else{
            UIView.setAnimationsEnabled(true)
        }
    }
    
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Score"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"totalanalysis"])
        }else if(item.title == "Manage"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"manage"])
        }else if(item.title == "More"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"listofactions"])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
        return 2
        }
        
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return ""
        }
        
        return "OCCUPANT SURVEY"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("morecell")! as! morecell
            cell.badge.hidden = false
            if(NSUserDefaults.standardUserDefaults().integerForKey("survey") == 1){
             cell.userInteractionEnabled = false
                cell.contentView.alpha = 0.4
            }else{
                cell.userInteractionEnabled = true
                cell.contentView.alpha = 1
            }
            
        if(indexPath.row == 0){
            cell.title.text = "Notifications"
            cell.badge.setTitle("\(notificationsarr.count)", forState: UIControlState.Normal)
        }else {
            cell.title.text = "Profile"
            cell.badge.setTitle("0", forState: UIControlState.Normal)
        }
        if(cell.badge.titleLabel?.text == "0"){
            cell.badge.hidden = true
        }
            return cell
        }
        if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("surveycell")! as! surveycategorytick
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            if(indexPath.row == 0){
            cell.label.text = "Dynamic Plaque"
            cell.tickimg.hidden = true
            }
            else if(indexPath.row == 1){
                cell.label.text = "Human experience"
                cell.tickimg.hidden = true
                cell.tickimg.hidden = Bool(NSUserDefaults.standardUserDefaults().integerForKey("humanhide"))
                
            }
            else if(indexPath.row == 2){
                cell.label.text = "Transportation"
                cell.tickimg.hidden = true
                cell.tickimg.hidden = Bool(NSUserDefaults.standardUserDefaults().integerForKey("transithide"))
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
            return 0.067 * UIScreen.mainScreen().bounds.size.height;
        }
        return 0.067 * UIScreen.mainScreen().bounds.size.width;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                self.performSegueWithIdentifier("gotonotifications", sender: nil)
            }
        }else{
            if(indexPath.row == 1){
                self.performSegueWithIdentifier("gotohuman", sender: nil)
            }else if (indexPath.row == 2){
                print("Mut is ",NSUserDefaults.standardUserDefaults().objectForKey("mainarray"))
                let mut = NSMutableArray.init(array: NSUserDefaults.standardUserDefaults().objectForKey("mainarray") as! NSArray).mutableCopy()
                if(mut.count == 0){
                    self.performSegueWithIdentifier("transit", sender: nil)
                }else{
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "added")
                    self.performSegueWithIdentifier("listofroutes", sender: nil)
                }     
            }else if(indexPath.row == 0){
                self.view.alpha = 0.0
                UIApplication.sharedApplication().statusBarHidden = true
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.performSegueWithIdentifier("dynamicplaque", sender: nil)
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
