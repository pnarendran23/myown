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
        tempselected = ["","","","",""]
        filtertable.allowsMultipleSelection = false
        self.titlefont()
        self.navigationController?.delegate = self
        self.navigationItem.title = "Filters"
        print(filterarr)
        print(tobefiltered)
        temptobefiltered = tobefiltered
        filtertable.reloadData()
        for i in 0..<tobefiltered.count{
            let str = tobefiltered.objectAtIndex(i) as! String
            if(str != ""){
                self.tableView(filtertable, didSelectRowAtIndexPath: NSIndexPath.init(forRow: i, inSection: 0))
                break
            }
        }
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var filtertable: UITableView!

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if(viewController is listofassets){
            let v = viewController as! listofassets
            v.filterarr = filterarr
            v.tobefiltered = tobefiltered
        }
        else if(viewController is gridviewcontroller){
            let v = viewController as! gridviewcontroller
            v.filterarr = filterarr
            v.tobefiltered = tobefiltered
        }
    }
    
    
    var tobefiltered = NSMutableArray()
    var temptobefiltered = NSMutableArray()
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temptobefiltered.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if(cell.accessoryType == UITableViewCellAccessoryType.None){
            
            temptobefiltered = NSMutableArray()
            temptobefiltered.addObject("")
            temptobefiltered.addObject("")
            temptobefiltered.addObject("")
            temptobefiltered.addObject("")
            temptobefiltered.addObject("")
            temptobefiltered.replaceObjectAtIndex(indexPath.row, withObject: (cell.textLabel?.text?.lowercaseString)!)
            filtertable.reloadData()
            print(temptobefiltered)
        }
        
    }
    var filterarr = ["Buildings","Cities","Communities","My projects","All"]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.tintColor = UIColor.blueColor()
        if(temptobefiltered.objectAtIndex(indexPath.row) as! String != ""){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        cell.textLabel?.text = filterarr[indexPath.row]
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
