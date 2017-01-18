//
//  manage.swift
//  LEEDOn
//
//  Created by Group X on 07/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class manage: UIViewController,UITableViewDelegate,UITableViewDataSource, UITabBarDelegate {
    @IBOutlet weak var assetname: UILabel!
    @IBOutlet weak var tabbar: UITabBar!
    
var categoryarr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        tabbar.selectedItem = self.tabbar.items![3]
        assetname.text = dict["name"] as? String
        categoryarr = ["Project","Team","Certifications","Billing","Settings"]
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var backbtn: UIButton!
    
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
        return categoryarr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = categoryarr.objectAtIndex(indexPath.row) as? String
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0){            
            self.performSegueWithIdentifier("gotoproject", sender: nil)
        }else if(indexPath.row == 1){
            self.performSegueWithIdentifier("gototeam", sender: nil)
        }else if(indexPath.row == 2){
            self.performSegueWithIdentifier("gotocertifications", sender: nil)
        }else if(indexPath.row == 3){
            self.performSegueWithIdentifier("gotobilling", sender: nil)
        }else if(indexPath.row == 4){
            self.performSegueWithIdentifier("gotosettings", sender: nil)
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
