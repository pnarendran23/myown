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
    @IBOutlet weak var nav: UINavigationBar!
    
    @IBOutlet weak var tableview: UITableView!
var categoryarr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        tableview.registerNib(UINib.init(nibName: "managecell", bundle: nil), forCellReuseIdentifier: "managecell")
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        let plaque = UIImage.init(named: "score")
        let credits = UIImage.init(named: "Menu_icon")
        let analytics = UIImage.init(named: "chart")
        let more = UIImage.init(named: "more")
        self.tabbar.setItems([UITabBarItem.init(title: "Score", image: plaque, tag: 0),UITabBarItem.init(title: "Credits/Actions", image: credits, tag: 1),UITabBarItem.init(title: "Analytics", image: analytics, tag: 2),UITabBarItem.init(title: "More", image: more, tag: 3)], animated: false)
        if(notificationsarr.count > 0 ){
        self.tabbar.items![3].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![3].badgeValue = nil
        }
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        tabbar.selectedItem = self.tabbar.items![3]
        self.navigationItem.title = dict["name"] as? String
        assetname.text = dict["name"] as? String
        
        categoryarr = ["Project","Team","Certifications","Billing","Settings"]
        self.view.bringSubviewToFront(nav)
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .Plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Manage"
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Projects"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height = UIScreen.mainScreen().bounds.size.height
        return 0.038 * height
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height = UIScreen.mainScreen().bounds.size.height
        return 0.038 * height
    }
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
    }

    @IBOutlet weak var backbtn: UIButton!
    
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryarr.count
    }
    
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("managecell")! as! managecell
        //cell.title.text = categoryarr.objectAtIndex(indexPath.row) as? String
        cell.lbl.text = categoryarr.objectAtIndex(indexPath.row) as? String
        if(indexPath.row == 0){
            cell.img.image = self.imageWithImage(UIImage(named:"project.png")!, scaledToSize: CGSize(width:30, height: 30))
            
        }else if(indexPath.row == 1){
            cell.img.image = self.imageWithImage(UIImage(named:"user.png")!, scaledToSize: CGSize(width:30, height: 30))
        }else if(indexPath.row == 2){            
            cell.img.image = self.imageWithImage(UIImage(named:"certifications.png")!, scaledToSize: CGSize(width:30, height: 30))
            //cell.img.image = self.imageWithImage(UIImage(named:"star.png")!, scaledToSize: CGSize(width:30, height: 30))
        }else if(indexPath.row == 3){
            cell.img.image = UIImage.init(named: "creditcard")
            cell.img.image = self.imageWithImage(UIImage(named:"creditcard.png")!, scaledToSize: CGSize(width:30, height: 30))
        }else if(indexPath.row == 4){
            cell.img.image = UIImage.init(named: "gear")
            cell.img.image = self.imageWithImage(UIImage(named:"gear.png")!, scaledToSize: CGSize(width:30, height: 30))
        }
        //cell.badge.hidden = true
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0){
            
            var temp = ""
            let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
            if((dict["project_type"] as! String).lowercaseString == "city" || (dict["project_type"] as! String).lowercaseString == "community"){
                temp = "manageacity"
            }else{
                temp = "gotoproject"
            }
            self.performSegueWithIdentifier(temp, sender: nil)
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
