//
//  listall.swift
//  LEEDOn
//
//  Created by Group X on 25/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class listall: UITableViewController, UITabBarDelegate {
    @IBOutlet var tablview: UITableView!
var dataarr = NSMutableArray()
    var selected = 0
    var id = 0
    var selectedarr = [String:AnyObject]()
    @IBAction func addnewreading(sender: AnyObject) {
        print("Add new reading")
    }
    
    override func viewWillAppear(animated: Bool) {
        tablview.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedarr.count>0){
            dataarr.replaceObjectAtIndex(selected, withObject: selectedarr)
        }
        
        tablview.registerNib(UINib.init(nibName: "customreadingcell", bundle: nil), forCellReuseIdentifier: "customreadingcell")
        print("Selected reading", dataarr)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataarr.count
    }
    
    
    
    
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Readings"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if(segue.identifier == "gotoeditreading"){
            var vc = segue.destinationViewController as! readingvc
               vc.dataarr = selectedarr
                vc.currentindex = selected
            vc.addreading = 0
        }else if(segue.identifier == "gotoaddreading"){
            var vc = segue.destinationViewController as! readingvc
            if(dataarr.count>0){
            vc.dataarr = dataarr.objectAtIndex(0) as! [String:AnyObject]
            }
            vc.id = id
            vc.addreading = 1
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customreadingcell") as! customreadingcell
        var dict = dataarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print("dates",dict["start_date"],dict["end_date"])
        var date1 = NSDate()
        var date2 = NSDate()
           date1 = dateFormatter.dateFromString(dict["start_date"] as! String)!
        date2 = dateFormatter.dateFromString(dict["end_date"] as! String)!
        print(date1, date2)
        dateFormatter.dateFormat = "d MMM yyyy"
        cell.durationlbl.text = String(format: "%@ - %@",dateFormatter.stringFromDate(date1),dateFormatter.stringFromDate(date2))
        cell.reading.text = String(format:"%d",dict["reading"] as! Int)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selected = indexPath.section
        selectedarr = dataarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        self.performSegueWithIdentifier("gotoeditreading", sender: nil)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addreadings(sender: AnyObject) {
            self.performSegueWithIdentifier("gotoaddreading", sender: nil)
    }
}
