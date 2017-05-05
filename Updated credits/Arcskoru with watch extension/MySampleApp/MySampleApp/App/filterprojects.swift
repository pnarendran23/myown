//
//  filterprojects.swift
//  Arcskoru
//
//  Created by Group X on 07/03/17.
//
//

import UIKit

class filterprojects: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
var tempselected = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()        
        tempselected = [[""],[""],["",""],[""],["all"]]
        filtertable.allowsMultipleSelection = false
        self.titlefont()
        self.navigationController?.delegate = self
        self.navigationItem.title = "Filters"
        print("Filter arr === = == = =",filterarr)
        print("tobefiltered == == = == =",tobefiltered)
        temptobefiltered = tobefiltered
        filtertable.reloadData()
        for i in 0..<tobefiltered.count{
            print(tobefiltered.objectAtIndex(i))
            let arr = tobefiltered.objectAtIndex(i).mutableCopy() as! NSMutableArray
            for j in 0..<arr.count{
            let str = arr.objectAtIndex(j) as! String
            if(str != ""){
                self.tableView(filtertable, didSelectRowAtIndexPath: NSIndexPath.init(forRow: j, inSection: i))
                break
            }
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var filtertable: UITableView!

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        print(tobefiltered)
        print(filterarr)
        
        if(viewController is listofassets){
            let v = viewController as! listofassets
            v.filterarr = filterarr
            v.tobefiltered = tobefiltered
        }
        else if(viewController is gridviewcontroller){
            let v = viewController as! gridviewcontroller
            //v.filterarr = filterarr            
            v.tobefiltered = tobefiltered
            v.filterarr = filterarr
        }
        
        
        
    }
    
    
    var tobefiltered = NSMutableArray()
    var temptobefiltered = NSMutableArray()
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return temptobefiltered.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temptobefiltered.objectAtIndex(section).count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if(cell.accessoryType == UITableViewCellAccessoryType.None){
            var arr = NSMutableArray()
            temptobefiltered = NSMutableArray()
            temptobefiltered = [[""],[""],["",""],[""],[""]]
            arr = temptobefiltered.objectAtIndex(indexPath.section).mutableCopy() as! NSMutableArray
            print(temptobefiltered,arr)
            arr.replaceObjectAtIndex(indexPath.row, withObject: (cell.textLabel?.text?.lowercaseString)!)
            temptobefiltered = NSMutableArray()
            temptobefiltered = [[""],[""],["",""],[""],[""]]
            temptobefiltered.replaceObjectAtIndex(indexPath.section, withObject: arr)
            filtertable.reloadData()
            print(temptobefiltered)
        }
        
    }
    
    var titlearr = ["","","Transportation","Buildings",""]
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titlearr[section]
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2 || section == 3){
        return 25
        }
        return 15
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    var filterarr = [["My cities"] as! NSArray,["My communities"] as! NSArray,["My Transit","My parking"] as! NSArray,["My buildings"] as! NSArray,["All"] as! NSArray] as! NSMutableArray
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.tintColor = UIColor.blueColor()
        if(temptobefiltered.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! String != ""){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        let arr = filterarr[indexPath.section] as! NSArray
        cell.textLabel?.text = arr[indexPath.row] as? String
        return cell
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
    @IBAction func filterbtn(sender: AnyObject) {
        tobefiltered = temptobefiltered
     self.navigationController?.popViewControllerAnimated(true)
    }

    
    
}
