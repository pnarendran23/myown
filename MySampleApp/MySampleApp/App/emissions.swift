//
//  emissions.swift
//  Arcskoru
//
//  Created by Group X on 17/01/17.
//
//

import UIKit

class emissions: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
var leftarr = NSArray()
var rightarr = NSArray()
    var sectiontitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        self.tableview.tableFooterView = UIView(frame: CGRectZero)
        self.tableview.tableFooterView?.hidden = true
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return title
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftarr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! UITableViewCell
        cell.detailTextLabel?.text = rightarr.objectAtIndex(indexPath.row) as! String
        cell.textLabel?.text = leftarr.objectAtIndex(indexPath.row) as! String        
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

}
