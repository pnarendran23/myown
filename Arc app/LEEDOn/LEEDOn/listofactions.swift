//
//  listofactions.swift
//  MySampleApp
//
//  Created by Group X on 08/11/16.
//
//

import UIKit

class listofactions: UIViewController,UITableViewDelegate,UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var segmentedctrl: UISegmentedControl!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var buildingname: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var currentarr = NSMutableArray()
    var allactionsarr = NSMutableArray()
    var pre_requisitesactionsarr = NSMutableArray()
    var data_input = NSMutableArray()
    var base_scores = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        var segmented_titles = ["All actions","Pre-requisites","Data input","Base scores"]
        
        for  i in 0  ..< segmented_titles.count {
        segmentedctrl.setTitle(segmented_titles[i] as? String, forSegmentAtIndex: i)
        }
        
        var font = UIFont.boldSystemFontOfSize(9.0)
        var attributes = NSDictionary.init(object: font, forKey: NSFontAttributeName)        
        segmentedctrl.setTitleTextAttributes(attributes as [NSObject : AnyObject], forState: UIControlState.Normal )
        
        
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        self.tableview.registerNib(UINib.init(nibName: "customcellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        var datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData
        var assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        print(assets)
        self.buildingname.text = String(format: "%@",assets["name"] as! String)
        datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("actions_data") as! NSData
        assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        currentarr = assets["EtScorecardList"]!.mutableCopy() as! NSMutableArray
        allactionsarr = currentarr
        print("Action count ",currentarr)
        
        for i in 0 ..< currentarr.count {
            var tempdict = currentarr[i] as! [String:AnyObject]
            if(tempdict["Mandatory"] as! String == "X"){
                pre_requisitesactionsarr.addObject(tempdict)
            }
        }
        for i in 0 ..< currentarr.count {
            var tempdict = currentarr[i] as! [String:AnyObject]
            if(tempdict["CreditcategoryDescrption"] as! String == "Performance"){
                data_input.addObject(tempdict)
            }
        }
        for i in 0 ..< currentarr.count {
            var tempdict = currentarr[i] as! [String:AnyObject]
            if((tempdict["Mandatory"] as! String != "X") && (tempdict["CreditcategoryDescrption"] as! String != "Performance")){
                base_scores.addObject(tempdict)
            }
        }
        
        
        print("BAse scre",base_scores)
        print("data input",data_input)
        print("pre_requisitesactionsarr",pre_requisitesactionsarr)
        
        // Do any additional setup after loading the view.
    }

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Plaque"){
            goback("hello")
        }else if(item.title == "Analytics"){
            self.performSegueWithIdentifier("gotoanalysis", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentarr.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBAction func filterme(sender: AnyObject) {
        var segmentedControl = sender as! UISegmentedControl
        var selectedsegment = segmentedControl.selectedSegmentIndex
        if(selectedsegment == 0 ){
            currentarr = allactionsarr
            tableview.reloadData()
        }else if (selectedsegment == 1){
            currentarr = pre_requisitesactionsarr
            tableview.reloadData()
        }else if (selectedsegment == 2){
            currentarr =  data_input
            tableview.reloadData()
        }else{
            currentarr = base_scores
            tableview.reloadData()
        }        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! customcellTableViewCell
        //CreditDescription, AssignedTo // first_name
        var linkTextWithColor = ""
        var text = ""
        var arr = currentarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        if let creditDescription = arr["CreditDescription"] as? String{
            text  = creditDescription + " assigned to"
            if let assignedto = arr["AssignedTo"] as? [String:AnyObject]{
                var temp = assignedto
                if let firstname = temp["first_name"] as? String{
                    text += " " + firstname.capitalizedString
                    
                }
            }else{
                text += " None"
            }
            linkTextWithColor = "assigned to"
            let range = (text as NSString).rangeOfString(linkTextWithColor)
            
            let attributedString = NSMutableAttributedString(string:text)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor() , range: range)
            cell.namelbl.attributedText = attributedString
            
        }
        
        
        
        if let creditstatus = arr["CreditStatus"] as? String{
            cell.creditstatus.text = String(format: "%@",creditstatus.capitalizedString)
            if(cell.creditstatus.text == ""){
                cell.creditstatus.text = "Not available"
            }
        }
        
        
        
        
        
        return cell
    }
    
    func checkcredit_type(tempdict:[String:AnyObject]) -> String {
        var temp = ""
        if((tempdict["Mandatory"] as! String != "X") && (tempdict["CreditcategoryDescrption"] as! String != "Performance")){
            temp = "Base scores"
        }
        else if(tempdict["CreditcategoryDescrption"] as! String == "Performance"){
            temp = "Data input"
        }else if(tempdict["Mandatory"] as! String == "X"){
            temp = "Pre-requisites"
        }
        
        return temp
    }
    
    @IBAction func goback(sender: AnyObject) {
        self.performSegueWithIdentifier("gotodashboard", sender: nil)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var arr = currentarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        print("The category is", checkcredit_type(arr))
        if(checkcredit_type(arr) == "Pre-requisites" || checkcredit_type(arr) == "Base scores"){
            var data = NSKeyedArchiver.archivedDataWithRootObject(currentarr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentcategory")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.section, forKey: "selected_action")
            self.performSegueWithIdentifier("prerequisites", sender: nil)
        }else if(checkcredit_type(arr) == "Data input"){
            var data = NSKeyedArchiver.archivedDataWithRootObject(currentarr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentcategory")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.section, forKey: "selected_action")
            if((arr["CreditDescription"] as! String).lowercaseString == "energy" || (arr["CreditDescription"] as! String).lowercaseString == "water"){
            self.performSegueWithIdentifier("datainput", sender: nil)
            }else if((arr["CreditDescription"] as! String).lowercaseString == "waste" || (arr["CreditDescription"] as! String).lowercaseString == "transportation" || (arr["CreditDescription"] as! String).lowercaseString == "human experience"){
            self.performSegueWithIdentifier("gotowaste", sender: nil)
            }
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
