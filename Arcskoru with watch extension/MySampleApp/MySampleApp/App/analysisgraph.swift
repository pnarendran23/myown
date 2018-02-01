//
//  analysisgraph.swift
//  LEEDOn
//
//  Created by Group X on 22/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class analysisgraph: UIViewController {
    @IBOutlet weak var graphview: actualgraph!
    @IBOutlet weak var backbtn: UIButton!
    var sortedArray = NSArray()
    @IBOutlet weak var str2lbl: UILabel!
    @IBOutlet weak var str1lbl: UILabel!
    @IBOutlet weak var str2value: UILabel!
    @IBOutlet weak var str1value: UILabel!
    @IBOutlet weak var segctrl: UISegmentedControl!
    @IBOutlet weak var vv: UIView!
    var mttitlearr = NSArray()
    var str1 = ""
    var str2 = ""
    var type = String()
    var reportedscores = NSMutableArray()
    @IBOutlet weak var maxlbl: UILabel!
    @IBOutlet weak var last12lbl: UILabel!
    @IBOutlet weak var zerolbl: UILabel!
    var startcolor = UIColor()
    var endcolor = UIColor()
    @IBOutlet weak var scoreslbl: UILabel!
    
    @IBOutlet weak var reportingperiod: UILabel!
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    func adjustwidth(){
        
        reportedscores = sortedArray.mutableCopy() as! NSMutableArray
        
        self.view.bringSubviewToFront(self.backbtn)
        var temp = UIView()
        temp.frame = graphview.frame
        print(vv.frame.size.width, vv.frame.size.height)
        self.graphview.frame = CGRect(x: vv.layer.frame.origin.x ,y:temp.layer.frame.origin.y,width:vv.layer.frame.size.width,height:vv.layer.frame.size.height)
        
        var data = [Int]()
        graphview.layer.cornerRadius = 10
        graphview.layer.masksToBounds = true
        graphview.graphPoints = [0,0,0]
        for dict in reportedscores{
            print(dict["scores"])
            if let scores = dict["scores"] as? [String:AnyObject] {
                // action is not nil, is a String type, and is now stored in actionString
                if(scores[type] is NSNull){
                    data.append(0)
                }else{
                    data.append(scores[type] as! Int)
                }
            } else {
                data.append(0)
                // action was either nil, or not a String type
            }
            
        }
        var num = 0
        if(data.count == 0){
            data = [0,0,0]
        }
        graphview.graphPoints = data
        if(data.count >= 0 && data.count <= 10){
            num = 10
        }else{
            let mod = (data.maxElement()! % 10)
            if(mod == 0){
                num = data.maxElement()!
            }else{
                num = 10 * ((data.maxElement()!/10)+1)
            }
        }
        
        print(num)
        if(mttitlearr.count > 0){
            str1lbl.adjustsFontSizeToFitWidth = true
            str1lbl.text = mttitlearr.objectAtIndex(0) as? String
            str1lbl.text = mttitlearr.objectAtIndex(1) as? String
            print("str1 str2",str1,str2)
            str1value.text = str1
            str2value.text = str2
            str1value.adjustsFontSizeToFitWidth = true
            str2value.adjustsFontSizeToFitWidth = true
        }else{
            self.vv.hidden = true
        }
        var l1 = UILabel()
        var l2 = UILabel()
        var l3 = UILabel()
        var l4 = UILabel()
        var l5 = UILabel()
        l1 = self.maxlbl
        self.vv.layer.cornerRadius = 10
        l2 = self.last12lbl
        l3 = self.zerolbl
        graphview.startColor = startcolor
        graphview.endColor = endcolor
        self.segctrl.tintColor = endcolor
        self.str1value.textColor = endcolor
        self.str2value.textColor = endcolor
        l4 = self.scoreslbl
        l5 = self.reportingperiod
        self.view.bringSubviewToFront(self.backbtn)
        self.graphview.bringSubviewToFront(reportingperiod)        
        
        l1.text = String(format: "%d",num)
        self.view.bringSubviewToFront(self.vv)
      //  self.view.addSubview(graphy)
         self.view.bringSubviewToFront(self.graphview)
        self.view.bringSubviewToFront(self.topview)
        self.view.bringSubviewToFront(self.tabbar)
        
       // graphview.hidden = true
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        backbtn.hidden = true
        //self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.adjustwidth), name: UIDeviceOrientationDidChangeNotification, object: nil)
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        assetname.text = buildingdetails["name"] as? String
        self.tabbar.selectedItem = self.tabbar.items![2]
        
        segctrl.setTitle("Per year", forSegmentAtIndex: 0)
        segctrl.setTitle("Per month", forSegmentAtIndex: 1)
        print(type, reportedscores)
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let tempArray: NSMutableArray = NSMutableArray()
        for i in 0..<reportedscores.count{
            let dic: NSMutableDictionary = reportedscores[i].mutableCopy() as! NSMutableDictionary
            print(dic)
            if(dic["effective_at"] is String){
                print("String",dic["effective_at"])
            }else{
                print("date")
            }
            if(dic["effective_at"] != nil){
            let dateConverted: NSDate = dateFormatter.dateFromString(dic["effective_at"] as! String)!
            dic["effective_at"] = dateConverted
            tempArray.addObject(dic)
            }else{
                dic["effective_at"] = NSDate()
                tempArray.addObject(dic)
            }
        }
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "effective_at", ascending: true)
        let descriptors: NSArray = [descriptor]
        sortedArray = tempArray.sortedArrayUsingDescriptors(descriptors as! [NSSortDescriptor])
        NSLog("%@", sortedArray)
        reportedscores = sortedArray.mutableCopy() as! NSMutableArray
        adjustwidth()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
    
    
    @IBOutlet weak var topview: UIView!

    @IBOutlet weak var assetname: UILabel!
    @IBOutlet weak var tabbar: UITabBar!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valuechange(sender: AnyObject) {
        if(segctrl.selectedSegmentIndex == 0){
            str1value.text = str1
            str2value.text = str2
        }else{
            var f1 = Float()
            var f2 = Float()
            f1 = 0
            f2 = 0
            f1 = Float(str1)!
            f2 = Float(str2)!
            f1 = f1/30.0
            f2 = f2/30.0
                str1value.text = "0.000"
            str2value.text = "0.000"
            if(f1 != 0){
            str1value.text = String(format: "%.5f",f1)
            }
            if(f2 != 0){
                str2value.text = String(format: "%.5f",f2)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = "Back"
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gobacktoanalysis"){
            var nav = segue.destinationViewController as! UINavigationController
            let vc = nav.viewControllers[0] as! totalanalytics
            vc.callrequest = 0
        }
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
