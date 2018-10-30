//
//  filtercredits.swift
//  Arcskoru
//
//  Created by Group X on 31/01/17.
//
//

import UIKit

class filtercredits: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
var sectionarr = ["By category","By assignee", "By submission status"]
var rowarr = [["Pre-requisites","Base scores","Data input","All actions"],["To me","To somebody","To None"],["Attempted","Under review","Ready for review"]]
    var delegate:filtersdelegate!
    var firstViewController = listofactions()
    var filterarr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.navigationItem.title = "Filters"
        self.navigationController?.delegate = self
        let navItem = UINavigationItem(title: "Filter");
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let filteritem = UIBarButtonItem(title: "", style: .Plain, target: self, action: #selector(filter(_:)))
        navItem.rightBarButtonItem = filteritem;        
        navItem.rightBarButtonItem?.image = listofactions().imageWithImage(UIImage(named: "filtericon.png")!, scaledToSize: CGSizeMake(32, 32))
        nav.setItems([navItem], animated: false);
        let datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData
        let assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        if(assets["project_type"] as! String == "building" && assets["rating_system"] as! String != "LEED V4 O+M: EB WP"){
            rowarr = [["Data input"],["To me","To somebody","To None"],["Attempted","Under review","ready for review"]]
            self.tableview.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func filter(sender:UIBarButtonItem){
        filterok(UIButton())
    }
    
    @IBAction func filterok(sender: AnyObject) {
        
        firstViewController.filterarr = filterarr
        self.navigationController?.popViewControllerAnimated(true)
       // self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var tableview: UITableView!
    
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if(viewController is listofactions){
            let v = viewController as! listofactions
            v.filterarr = filterarr
        }else if(viewController is gridviewcontroller){
            let v = viewController as! gridviewcontroller
            v.filterarr = filterarr
        }
    }
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    @IBOutlet weak var nav: UINavigationBar!
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionarr[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionarr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let d = rowarr[section]
        return d.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var d = rowarr[indexPath.section]
        cell.textLabel?.text = d[indexPath.row]
        if(filterarr.containsObject(cell.textLabel!.text!)){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.selected = true
            print("Selected ", indexPath.section, indexPath.row)
        }else{
            print("Not Selected ", indexPath.section, indexPath.row)
            cell.selected = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            print(indexPath.section, indexPath.row)
        }
        return cell
    }
    
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let str = cell.textLabel!.text!
        print("Filterarr ",filterarr, str)
        if(filterarr.containsObject(str)){
            let temp = filterarr
            for i in 0..<filterarr.count{
                let tempstr = filterarr.objectAtIndex(i) as! NSString
                if(tempstr == str){
                    temp.replaceObjectAtIndex(i, withObject: "")
                }
            }
            temp.removeObject("")
            filterarr = temp
        }else{
            filterarr.removeAllObjects()
            filterarr.addObject(str)
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        print(filterarr)
        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = UITableViewCellAccessoryType.None
        let str = cell.textLabel!.text! 
        let temp = filterarr
        for i in 0..<filterarr.count{
            let tempstr = filterarr.objectAtIndex(i) as! NSString
            if(tempstr == str){
                temp.replaceObjectAtIndex(i, withObject: "")
            }
        }
        temp.removeObject("")
        filterarr = temp
        print(filterarr)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

protocol filtersdelegate
{
    func sendValue(value : NSString)
}

