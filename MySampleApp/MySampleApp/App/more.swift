//
//  more.swift
//  LEEDOn
//
//  Created by Group X on 28/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class more: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    var notificationsarr = NSArray()
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        tableview.layer.cornerRadius = 10
        self.tabbar.selectedItem = self.tabbar.items![4]
        tableview.registerNib(UINib.init(nibName: "morecell", bundle: nil), forCellReuseIdentifier: "morecell")
        notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        assetname.text = buildingdetails["name"] as? String
        // Do any additional setup after loading the view.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Score"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
        }else if(item.title == "Manage"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
        }else if(item.title == "More"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("morecell")! as! morecell
        cell.badge.hidden = false
        if(indexPath.row == 0){
            cell.title.text = "Notifications"
            cell.badge.setTitle("\(notificationsarr.count)", forState: UIControlState.Normal)
        }else if(indexPath.row == 1) {
            cell.title.text = "Chats"
            cell.badge.setTitle("0", forState: UIControlState.Normal)
        }else {
            cell.title.text = "Profile"
            cell.badge.setTitle("0", forState: UIControlState.Normal)
        }
        
        if(cell.badge.titleLabel?.text == "0"){
            cell.badge.hidden = true
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableview.frame.size.height/3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0){
            self.performSegueWithIdentifier("gotonotifications", sender: nil)
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
