//
//  individualanalysis.swift
//  LEEDOn
//
//  Created by Group X on 06/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class individualanalysis: UIViewController,UITabBarDelegate {
    @IBOutlet weak var text2: UILabel!

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var assetname: UILabel!
    var text1arr = NSMutableArray()
    var navigate = 0
    var text2arr = NSMutableArray()
    @IBAction func goback(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        assetname.text = dict["name"] as! String        
        text1arr = ["mtCO2e/occupant", "gallons/occupant","Generated Waste"]
        text2arr = ["mtCO2e/square foot","gallons/square foot","Undiverted Waste/lbs/occupant"]
        self.tabbar.selectedItem = self.tabbar.items![2]
        text2.hidden = false
        text1.hidden = false
        titlelbl.text = "Energy"
        text1.text = String(format:"%@ : 0",text1arr.objectAtIndex(navigate) as! String)
        text2.text = String(format:"%@ : 0",text2arr.objectAtIndex(navigate) as! String)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Plaque"){
            self.performSegueWithIdentifier("gotoplaque", sender: nil)
        }else if(item.title == "Manage" ){
            self.performSegueWithIdentifier("gotomanage", sender: nil)
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
    @IBAction func next(sender: AnyObject) {
        if(navigate<5){
            if(navigate == 4){
                
            }else{
                navigate=navigate+1
            }
            if(navigate == 0){
                text2.hidden = false
                text1.hidden = false
                titlelbl.text = "Energy"
                text1.text = String(format:"%@ : 0",text1arr.objectAtIndex(navigate) as! String)
                text2.text = String(format:"%@ : 0",text2arr.objectAtIndex(navigate) as! String)
            }else if(navigate == 1){
                titlelbl.text = "Water"
                text2.hidden = false
                text1.hidden = false
                text1.text = String(format:"%@ : 0",text1arr.objectAtIndex(navigate) as! String)
                text2.text = String(format:"%@ : 0",text2arr.objectAtIndex(navigate) as! String)
            }else if(navigate == 2){
                titlelbl.text = "Waste"
                text2.hidden = false
                text1.hidden = false
                text1.text = String(format:"%@ : 0",text1arr.objectAtIndex(navigate) as! String)
                text2.text = String(format:"%@ : 0",text2arr.objectAtIndex(navigate) as! String)
            }else if(navigate == 3){
                titlelbl.text = "Transport"
                text2.hidden = true
                text1.hidden = true
            }else if(navigate == 4){
                titlelbl.text = "Human experience"
                text2.hidden = true
                text1.hidden = true
            }
        }
        print(navigate)
        
    }
    
    @IBAction func previous(sender: AnyObject) {
        if(navigate>=0){
            if(navigate == 0){
                self.performSegueWithIdentifier("gotototal", sender: nil)
            }else{
                navigate=navigate-1
            }

            if(navigate == 0){
                titlelbl.text = "Energy"
                text2.hidden = false
                text1.hidden = false
                text1.text = String(format:"%@ : 0",text1arr.objectAtIndex(navigate) as! String)
                text2.text = String(format:"%@ : 0",text2arr.objectAtIndex(navigate) as! String)
                
            }else if(navigate == 1){
                titlelbl.text = "Water"
                text2.hidden = false
                text1.hidden = false
                text1.text = String(format:"%@ : 0",text1arr.objectAtIndex(navigate) as! String)
                text2.text = String(format:"%@ : 0",text2arr.objectAtIndex(navigate) as! String)
            }else if(navigate == 2){
                titlelbl.text = "Waste"
                text2.hidden = false
                text1.hidden = false
                text1.text = String(format:"%@ : 0",text1arr.objectAtIndex(navigate) as! String)
                text2.text = String(format:"%@ : 0",text2arr.objectAtIndex(navigate) as! String)
                
            }else if(navigate == 3){
                titlelbl.text = "Transport"
                text2.hidden = true
                text1.hidden = true
            }else if(navigate == 4){
                titlelbl.text = "Human experience"
                text2.hidden = true
                text1.hidden = true
            }
            
            
        }
        
        print(navigate)
    }

}
