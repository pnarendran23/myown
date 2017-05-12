//
//  pickerviewcontroller.swift
//  Arcskoru
//
//  Created by Group X on 23/02/17.
//
//

import UIKit

class pickerviewcontroller: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UITabBarDelegate {
    @IBOutlet weak var picker: UIPickerView!
var dict = NSMutableDictionary()
    var data_dict = NSMutableDictionary()
var countriesarr = NSArray()
    
    @IBOutlet weak var tabbar: UITabBar!
var statesarr  = NSArray()
    var currentcountry = ""
    var currentstate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("countries") as! NSData)?.mutableCopy() as! NSMutableDictionary
        countriesarr = (dict["countries"] as! NSDictionary).allValues
        let sortedNames = countriesarr.sort { $0.localizedCaseInsensitiveCompare($1 as! String) == NSComparisonResult.OrderedAscending }
        countriesarr = sortedNames as NSArray
        
        let filteritem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(done(_:)))
        self.navigationItem.rightBarButtonItem = filteritem
        self.navigationItem.setRightBarButtonItem(filteritem, animated: true)
        if(data_dict.allKeys.count == 0 ){
            self.tabbar.hidden = true
        }else{
            self.tabbar.hidden = false
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
            self.tabbar.selectedItem = self.tabbar.items![3]
            
        }
        // Do any additional setup after loading the view.
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.delegate = nil
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? addnewproject {
            controller.data_dict = data_dict    // Here you pass the data back to your original view controller
        }else if let controller = viewController as? managecity {
            var tempstring = NSMutableString.init(string: self.currentstate)
            var temp = ""
            temp = tempstring.stringByReplacingOccurrencesOfString(self.currentcountry, withString: "")
            self.currentstate = temp
            controller.building_dict["state"] = self.currentstate
            controller.building_dict["country"] = self.currentcountry
            
        }else if let controller = viewController as? newproject {
            var tempstring = NSMutableString.init(string: self.currentstate)
            var temp = ""
            temp = tempstring.stringByReplacingOccurrencesOfString(self.currentcountry, withString: "")
            self.currentstate = temp
            controller.building_dict["state"] = self.currentstate
            controller.building_dict["country"] = self.currentcountry
            
        }
        else if let controller = viewController as? manageacity {
            var tempstring = NSMutableString.init(string: self.currentstate)
            var temp = ""
            temp = tempstring.stringByReplacingOccurrencesOfString(self.currentcountry, withString: "")
            self.currentstate = temp
            
            // 6 - country, 12 - state, 12 - country 22 - state, 23 - country
            if(indx == 6 || indx == 12){
            controller.building_dict["state"] = self.currentstate
            controller.building_dict["country"] = self.currentcountry
            }else if(indx == 22 || indx == 23){
                controller.building_dict["manageEntityState"] = self.currentstate
                controller.building_dict["manageEntityCountry"] = self.currentcountry
            }
        }
    }
    
    var indx = 0
    
    func done(sender: UIBarButtonItem){
        dispatch_async(dispatch_get_main_queue(), {
            var datef = NSDateFormatter()
            self.view.userInteractionEnabled = false
            //self.saveproject(0)
            self.data_dict["country"] = self.currentcountry
            self.data_dict["state"] = self.currentstate
            self.navigationController?.popViewControllerAnimated(true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
        return countriesarr.count
        }
        
        return statesarr.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(component == 0){
            return countriesarr[row] as! String
        }
        
        return statesarr[row] as! String
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            var shortnameofcountry = ""
            var temp = dict["countries"] as! NSDictionary
            var temparray = NSArray()
            for (key,value) in temp{
                if(value as! String == countriesarr[row] as! String){
                    shortnameofcountry = key as! String
                    break
                }
            }
            currentcountry = shortnameofcountry
            print(shortnameofcountry)
            temp = dict["divisions"] as! NSDictionary
            if(temp[shortnameofcountry] != nil){
            temparray = (temp[shortnameofcountry] as! NSDictionary).allValues
            let sortedNames = temparray.sort { $0.localizedCaseInsensitiveCompare($1 as! String) == NSComparisonResult.OrderedAscending }
            statesarr = sortedNames as NSArray
            }else{
                var a = NSArray()
                statesarr = a
            }
            pickerView.reloadComponent(1)
        }else{
            var shortnameforstate = ""
            currentstate = ""
            var temp = dict["divisions"] as! NSDictionary
            if(temp[currentcountry] != nil){
                var a = temp[currentcountry] as! NSDictionary
                for (key,value) in a{
                    if(value as! String == statesarr[row] as! String){
                        shortnameforstate = key as! String
                        break
                    }
                }
            }
            currentstate = "\(currentcountry)\(shortnameforstate)"
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
