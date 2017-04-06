//
//  instructions.swift
//  LEEDOn
//
//  Created by Group X on 29/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class plaque: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITabBarDelegate {
    var indicator = UIPageControl()
    var currentindex = 0
    var localavgdict = [String:AnyObject]()
    var globalavgdict = [String:AnyObject]()
    var performance_data = [String:AnyObject]()
    var pageTitles = ["Explore buildings","Analysing projects","Astonishing performance scores animation","Calculating scores", "Organize submission data","Activity feed"]
    @IBOutlet weak var nav: UINavigationBar!
    
    var contentarray = ["Access and get information about any of your building in a finger tip from anywhere","Get the LEED performance score of the building which you want","Analyse your building performance score to get a better score and also to know, what's really affecting your score.","Calculate your emissions and their scores relfection in a single move.","Check who does that and who needs to do what for your building","Check for the status of the submitted data", "Get instant notifications about your building about its data and certification."]
    var imgarray = [UIImage(named: ("list of buildings")),UIImage(named: ("plaque")),UIImage(named: ("analytics")),UIImage(named: ("calculate")),UIImage(named: ("organize")), UIImage(named: ("notifications"))]
    var innerdict = [String:AnyObject]()
    var middledict = [String:AnyObject]()
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        indicator = self.view.viewWithTag(90) as! UIPageControl
        pgctrl.numberOfPages = 6
        pgctrl.userInteractionEnabled = false
        wedid()
        return [.Portrait ,.LandscapeLeft,.LandscapeRight]
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Projects"
    }
    
    override func viewWillDisappear(animated: Bool) {        
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
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

    
    
    var pageviewcontroller = UIPageViewController()
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(pageViewController.viewControllers?.first is overallplaque){
            let p = pageViewController.viewControllers?.first as! overallplaque
            currentindex = p.pageIndex
            print("Presented index",p.pageIndex)
            pgctrl.currentPage = p.pageIndex
        }else if(pageViewController.viewControllers?.first is individualplaque){
            let p = pageViewController.viewControllers?.first as! individualplaque
            print("Presented index",p.pageIndex)
            currentindex = p.pageIndex
            pgctrl.currentPage = p.pageIndex
        }else{
            pgctrl.currentPage = 0
        }
        
        if(currentindex == 0){
            pgctrl.currentPageIndicatorTintColor = UIColor.blackColor()
        }else if(currentindex == 1){
             pgctrl.currentPageIndicatorTintColor = UIColor(red:0.776, green: 0.858, blue:0.124, alpha:1)
        }else if(currentindex == 2){
            pgctrl.currentPageIndicatorTintColor = UIColor(red:0.323, green: 0.755, blue:0.93, alpha:1)
        }else if(currentindex == 3){
            pgctrl.currentPageIndicatorTintColor = UIColor(red:0.465, green: 0.756, blue:0.629, alpha:1)
        }else if(currentindex == 4){
            pgctrl.currentPageIndicatorTintColor = UIColor(red:0.573, green: 0.557, blue:0.498, alpha:1)
        }else if(currentindex == 5){
            pgctrl.currentPageIndicatorTintColor =  UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1)
        }
        
    }
    
    @IBOutlet weak var pgctrl: UIPageControl!
    
    func wedid(){
        pgctrl.currentPage = 0
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        
        localavgdict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("local_comparable_data") as! NSData) as! [String:AnyObject]
        
        globalavgdict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("comparable_data") as! NSData) as! [String:AnyObject]
        
        performance_data = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("performance_data") as! NSData) as! [String:AnyObject]
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("inner_data") != nil){
                innerdict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("inner_data") as! NSData) as! [String:AnyObject]
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("middle_data") != nil){
                middledict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("middle_data") as! NSData) as! [String:AnyObject]
        }
        
        
        print("global local",globalavgdict,localavgdict)
        
        assetname.text = dict["name"] as? String
        pageviewcontroller = self.storyboard?.instantiateViewControllerWithIdentifier("plaquepagevc") as! UIPageViewController
        pageviewcontroller.delegate = self
        pageviewcontroller.dataSource = self
        let startviewcontroller = self.viewcontrolleratIndex(currentindex)
        let viewcontrollers = [startviewcontroller]
        pageviewcontroller.setViewControllers(viewcontrollers, direction: .Forward , animated: false, completion: nil)
        pageviewcontroller.view.frame.origin.x = 0
        pageviewcontroller.view.frame.origin.y = self.nav.frame.origin.y + self.nav.frame.size.height
        pageviewcontroller.view.frame.size.width = self.view.frame.size.width
        pageviewcontroller.view.frame.size.height = pgctrl.frame.origin.y
            //pageviewcontroller.view.frame.size.height - (pgctrl.frame.size.height +
        //self.view.frame.size.height - (0.13*self.view.frame.size.width)
        self.addChildViewController(pageviewcontroller)
        self.view.addSubview(pageviewcontroller.view)
        self.view.bringSubviewToFront(pgctrl)
        self.view.bringSubviewToFront(topview)
        self.view.bringSubviewToFront(nav)
        self.view.bringSubviewToFront(self.tabbar)
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        tabbar.delegate = self
        self.navigationItem.title = dict["name"] as? String
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .Bordered, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        pageviewcontroller.didMoveToParentViewController(self)
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.tabbar.selectedItem = self.tabbar.items![0]
    }
    @IBOutlet weak var assetname: UILabel!
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var tabbar: UITabBar!
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])   
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()        
        wedid()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goback(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = 0
        if(viewController is overallplaque){
         index = (viewController as! overallplaque).pageIndex
        }else{
         index = (viewController as! individualplaque).pageIndex
        }
        if(index == NSNotFound){
            return nil
        }
        index = index + 1
        if(index == pageTitles.count){
            index = 0
        }
        if(index > 0){
            return individualviewcontrolleratIndex(index)
        }
        return viewcontrolleratIndex(index)
        
        
    }
    
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = 0
        if(viewController is overallplaque){
            index = (viewController as! overallplaque).pageIndex
        }else{
            index = (viewController as! individualplaque).pageIndex
        }
        
        if(index == NSNotFound){
            return nil
        }
        index = index - 1
        if(index < 0){
            index = pageTitles.count-1
        }
        if(index == 0){
            return viewcontrolleratIndex(index)
        }
        return individualviewcontrolleratIndex(index)
        
    }
    
    func viewcontrolleratIndex(index:Int) -> overallplaque {
        
        let overvall = self.storyboard?.instantiateViewControllerWithIdentifier("overallplaque") as! overallplaque
        overvall.pageIndex = index
        //print(imgarray[index])
        overvall.energyscorevalue = 14
        overvall.energymaxscorevalue = 20
        overvall.waterscorevalue = 12
        overvall.watermaxscorevalue = 20
        overvall.wastescorevalue = 1
        overvall.wastemaxscorevalue = 20
        overvall.transportscorevalue = 0
        overvall.transportmaxscorevalue = 20
        overvall.humanscorevalue = 17
        overvall.humanmaxscorevalue = 20
        var dict = performance_data
        if(dict["scores"] != nil){
            if(dict["scores"]!["energy"] != nil){
                if(dict["scores"]!["energy"] is NSNull){
                    overvall.energyscorevalue = 0
                }else{
                    overvall.energyscorevalue = dict["scores"]!["energy"] as! Int
                }
                
            }else{
                overvall.energyscorevalue = 0
            }
        }else{
            overvall.energyscorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["water"] != nil){
                if(dict["scores"]!["water"] is NSNull){
                    overvall.waterscorevalue = 0
                }else{
                    overvall.waterscorevalue = dict["scores"]!["water"] as! Int
                }
            }else{
                overvall.waterscorevalue = 0
            }
        }else{
            overvall.waterscorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["waste"] != nil){
                if(dict["scores"]!["waste"] is NSNull){
                    overvall.wastescorevalue = 0
                }else{
                    overvall.wastescorevalue = dict["scores"]!["waste"] as! Int
                }
            }else{
                overvall.wastescorevalue = 0
            }
        }else{
            overvall.wastescorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["transport"] != nil){
                if(dict["scores"]!["transport"] is NSNull){
                    overvall.transportscorevalue = 0
                }else{
                    overvall.transportscorevalue = dict["scores"]!["transport"] as! Int
                }
            }else{
                overvall.transportscorevalue = 0
            }
        }else{
            overvall.transportscorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["human_experience"] != nil){
                if(dict["scores"]!["human_experience"] is NSNull){
                    overvall.humanscorevalue = 0
                }else{
                    overvall.humanscorevalue = dict["scores"]!["human_experience"] as! Int
                }
            }else{
                overvall.humanscorevalue = 0
            }
        }else{
            overvall.humanscorevalue = 0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["energy"] != nil){
                if(dict["maxima"]!["energy"] is NSNull){
                    overvall.energymaxscorevalue = 15
                }else{
                    overvall.energymaxscorevalue = dict["maxima"]!["energy"] as! Int
                }
            }else{
                overvall.energymaxscorevalue = 15
            }
        }else{
            overvall.energymaxscorevalue = 15
        }
        
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["water"] != nil){
                if(dict["maxima"]!["water"] is NSNull){
                    overvall.watermaxscorevalue = 15
                }else{
                    overvall.watermaxscorevalue = dict["maxima"]!["water"] as! Int
                }
            }else{
                overvall.watermaxscorevalue = 15
            }
        }else{
            overvall.watermaxscorevalue = 15
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["waste"] != nil){
                if(dict["maxima"]!["waste"] is NSNull){
                    overvall.wastemaxscorevalue = 15
                }else{
                    overvall.wastemaxscorevalue = dict["maxima"]!["waste"] as! Int
                }
            }else{
                overvall.wastemaxscorevalue = 15
            }
        }else{
            overvall.wastemaxscorevalue = 15
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["transport"] != nil){
                if(dict["maxima"]!["transport"] is NSNull){
                    overvall.transportmaxscorevalue = 15
                }else{
                    overvall.transportmaxscorevalue = dict["maxima"]!["transport"] as! Int
                }
            }else{
                overvall.transportmaxscorevalue = 15
            }
        }else{
            overvall.transportmaxscorevalue = 15
        }
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["human_experience"] != nil){
                if(dict["maxima"]!["human_experience"] is NSNull){
                    overvall.humanmaxscorevalue = 15
                }else{
                    overvall.humanmaxscorevalue = dict["maxima"]!["human_experience"] as! Int
                }
            }else{
                overvall.humanmaxscorevalue = 15
            }
        }else{
            overvall.humanmaxscorevalue = 15
        }
        
        
        //pgctrl.currentPage = presentationIndexForPageViewController(self.pageviewcontroller)
        return overvall
        
    }
    
    func individualviewcontrolleratIndex(index:Int) -> individualplaque {
        
        let overvall = self.storyboard?.instantiateViewControllerWithIdentifier("individualplaque") as! individualplaque
        overvall.pageIndex = index
        overvall.localavgscorevalue = 20
        overvall.globalavgscorevalue = 20
        overvall.outerscorevalue = 10
        overvall.outermaxscorevalue = 30
        overvall.middlescorevalue = 15
        overvall.middlemaxscorevalue = 20
        overvall.innerscorevalue = 0
        overvall.innermaxscorevalue = 20
        var dict = performance_data
        if(index == 1){
            overvall.innerstroke = UIColor(red:0.898, green: 0.931, blue:0.56, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " Electricity \n Gas \n Smart meters \n Load schedule"
            overvall.plaqueimg = UIImage.init(named: "edited_energy")!
            overvall.strokecolor =  UIColor(red:0.776, green: 0.858, blue:0.124, alpha:1)
            overvall.titlevalue = "\nCURRENT ENERGY"
            if(dict["scores"] != nil){
                if(dict["scores"]!["energy"] != nil){
                    if(dict["scores"]!["energy"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["energy"] as! Int
                    }
                    
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }
            
            print(middledict)
            if(middledict["scores"] != nil){
                if(middledict["scores"]!["energy"] != nil){
                    if(middledict["scores"]!["energy"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["energy"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["energy"] != nil){
                    if(innerdict["scores"]!["energy"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["energy"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            
            overvall.localavgscorevalue = 0
            overvall.globalavgscorevalue = 0
            if(globalavgdict["energy_avg"] == nil || globalavgdict["energy_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["energy_avg"] as! Int
            }
            if(localavgdict["energy_avg"] == nil || localavgdict["energy_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["energy_avg"] as! Int
            }
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["energy"] != nil){
                    if(dict["maxima"]!["energy"] is NSNull){
                        overvall.outermaxscorevalue = 33
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["energy"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 33
                }
            }else{
                overvall.outermaxscorevalue = 33
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["energy"] != nil){
                    if(middledict["maxima"]!["energy"] is NSNull){
                        overvall.middlemaxscorevalue = 33
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["energy"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 33
                }
            }else{
                overvall.middlemaxscorevalue = 33
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["energy"] != nil){
                    if(innerdict["maxima"]!["energy"] is NSNull){
                        overvall.innermaxscorevalue = 33
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["energy"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 33
                }
            }else{
                overvall.innermaxscorevalue = 33
            }
        }else if(index == 2){
            overvall.innerstroke =  UIColor(red:0.703, green: 0.909, blue:0.989, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " Water consumption"
            overvall.plaqueimg = UIImage.init(named: "edited_water")!
            overvall.strokecolor = UIColor(red:0.323, green: 0.755, blue:0.93, alpha:1)
            overvall.titlevalue = "\nCURRENT WATER"
            if(middledict["scores"] != nil){
                if(middledict["scores"]!["water"] != nil){
                    if(middledict["scores"]!["water"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["water"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["water"] != nil){
                    if(innerdict["scores"]!["water"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["water"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            
            if(dict["scores"] != nil){
                if(dict["scores"]!["water"] != nil){
                    if(dict["scores"]!["water"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["water"] as! Int
                    }
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }

            overvall.localavgscorevalue = 0
            if(localavgdict["water_avg"] == nil || localavgdict["water_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["water_avg"] as! Int
            }
            overvall.globalavgscorevalue = 0
            if(globalavgdict["water_avg"] == nil || globalavgdict["water_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["water_avg"] as! Int
            }
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["water"] != nil){
                    if(dict["maxima"]!["water"] is NSNull){
                        overvall.outermaxscorevalue = 15
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["water"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 15
                }
            }else{
                overvall.outermaxscorevalue = 15
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["water"] != nil){
                    if(middledict["maxima"]!["water"] is NSNull){
                        overvall.middlemaxscorevalue = 15
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["water"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 15
                }
            }else{
                overvall.middlemaxscorevalue = 15
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["water"] != nil){
                    if(innerdict["maxima"]!["water"] is NSNull){
                        overvall.innermaxscorevalue = 15
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["water"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 15
                }
            }else{
                overvall.innermaxscorevalue = 15
            }
            
        }else if(index == 3){
            
            overvall.innerstroke = UIColor(red:0.797, green: 0.919, blue:0.87, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " Waste generated \n Waste diverted"
            overvall.plaqueimg = UIImage.init(named: "edited_waste")!
            overvall.strokecolor =  UIColor(red:0.465, green: 0.756, blue:0.629, alpha:1)
            overvall.titlevalue = "\nCURRENT WASTE"
            if(middledict["scores"] != nil){
                if(middledict["scores"]!["waste"] != nil){
                    if(middledict["scores"]!["waste"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["waste"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["waste"] != nil){
                    if(innerdict["scores"]!["waste"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["waste"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            

            
            if(dict["scores"] != nil){
                if(dict["scores"]!["waste"] != nil){
                    if(dict["scores"]!["waste"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["waste"] as! Int
                    }
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }

            overvall.localavgscorevalue = 0
            if(localavgdict["waste_avg"] == nil || localavgdict["waste_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["waste_avg"] as! Int
            }
            overvall.globalavgscorevalue = 0
            if(globalavgdict["waste_avg"] == nil || globalavgdict["waste_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["waste_avg"] as! Int
            }
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["waste"] != nil){
                    if(dict["maxima"]!["waste"] is NSNull){
                        overvall.outermaxscorevalue = 8
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["waste"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 8
                }
            }else{
                overvall.outermaxscorevalue = 8
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["waste"] != nil){
                    if(middledict["maxima"]!["waste"] is NSNull){
                        overvall.middlemaxscorevalue = 8
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["waste"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 8
                }
            }else{
                overvall.middlemaxscorevalue = 8
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["waste"] != nil){
                    if(innerdict["maxima"]!["waste"] is NSNull){
                        overvall.innermaxscorevalue = 8
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["waste"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 8
                }
            }else{
                overvall.innermaxscorevalue = 8
            }
            
        }else if(index == 4){
            overvall.innerstroke = UIColor(red:0.716, green: 0.7, blue:0.629, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " Occupant travel"
            overvall.plaqueimg = UIImage.init(named: "edited_transport")!
            overvall.strokecolor = UIColor(red:0.573, green: 0.557, blue:0.498, alpha:1)
            overvall.titlevalue = "\nCURRENT TRANSPORTATION"
            if(middledict["scores"] != nil){
                if(middledict["scores"]!["transport"] != nil){
                    if(middledict["scores"]!["transport"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["transport"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["transport"] != nil){
                    if(innerdict["scores"]!["transport"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["transport"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            

            
            if(dict["scores"] != nil){
                if(dict["scores"]!["transport"] != nil){
                    if(dict["scores"]!["transport"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["transport"] as! Int
                    }
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }
            overvall.localavgscorevalue = 0
            if(localavgdict["transport_avg"] == nil || localavgdict["transport_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["water_avg"] as! Int
            }
            overvall.globalavgscorevalue = 0
            if(globalavgdict["transport_avg"] == nil || globalavgdict["transport_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["transport_avg"] as! Int
            }
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["transport"] != nil){
                    if(dict["maxima"]!["transport"] is NSNull){
                        overvall.outermaxscorevalue = 14
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["transport"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 14
                }
            }else{
                overvall.outermaxscorevalue = 14
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["transport"] != nil){
                    if(middledict["maxima"]!["transport"] is NSNull){
                        overvall.middlemaxscorevalue = 14
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["transport"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 14
                }
            }else{
                overvall.middlemaxscorevalue = 14
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["transport"] != nil){
                    if(innerdict["maxima"]!["transport"] is NSNull){
                        overvall.innermaxscorevalue = 14
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["transport"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 14
                }
            }else{
                overvall.innermaxscorevalue = 14
            }
            
        }else if(index == 5){
            
            overvall.innerstroke = UIColor(red:0.98, green: 0.842, blue:0.614, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " CO2 levels \n VOC levels \n Occupant satisfaction"
            overvall.plaqueimg = UIImage.init(named: "edited_human")!
            overvall.strokecolor = UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1)
            overvall.titlevalue = "\nCURRENT HUMAN\n EXPERIENCE"
            if(middledict["scores"] != nil){
                if(middledict["scores"]!["human_experience"] != nil){
                    if(middledict["scores"]!["human_experience"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["human_experience"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["human_experience"] != nil){
                    if(innerdict["scores"]!["human_experience"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["human_experience"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            

            
            if(dict["scores"] != nil){
                if(dict["scores"]!["human_experience"] != nil){
                    if(dict["scores"]!["human_experience"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["human_experience"] as! Int
                    }
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }
            overvall.localavgscorevalue = 0
            if(localavgdict["human_experience_avg"] == nil || localavgdict["human_experience_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["human_experience_avg"] as! Int
            }
            overvall.globalavgscorevalue = 0
            if(globalavgdict["human_experience_avg"] == nil || globalavgdict["human_experience_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["human_experience_avg"] as! Int
            }
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["human_experience"] != nil){
                    if(dict["maxima"]!["human_experience"] is NSNull){
                        overvall.outermaxscorevalue = 20
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["human_experience"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 20
                }
            }else{
                overvall.outermaxscorevalue = 20
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["human_experience"] != nil){
                    if(middledict["maxima"]!["human_experience"] is NSNull){
                        overvall.middlemaxscorevalue = 20
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["human_experience"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 20
                }
            }else{
                overvall.middlemaxscorevalue = 20
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["human_experience"] != nil){
                    if(innerdict["maxima"]!["human_experience"] is NSNull){
                        overvall.innermaxscorevalue = 20
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["human_experience"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 20
                }
            }else{
                overvall.innermaxscorevalue = 20
            }
        }
        
        //pgctrl.currentPage = presentationIndexForPageViewController(self.pageviewcontroller)
        return overvall
        
    }
    
    
    @IBOutlet weak var skipbtn: UIButton!
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
