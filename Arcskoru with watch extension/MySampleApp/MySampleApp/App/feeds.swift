//
//  feeds.swift
//  Arcskoru
//
//  Created by Group X on 24/01/17.
//
//

import UIKit

class feeds: UIViewController, UITableViewDelegate, UITableViewDataSource {
var currentfeeds = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
                let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary            
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .Plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        self.navigationItem.title = dict["name"] as? String
        // Do any additional setup after loading the view.
    }
    
    func sayHello(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentfeeds.count
    }
    
    @IBOutlet weak var nav: UINavigationBar!
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedcell")! 
        
        var dict = currentfeeds.objectAtIndex(indexPath.row) as! [String:AnyObject]
        cell.textLabel?.text = dict["verb"] as? String
        var str = dict["timestamp"] as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let date = formatter.dateFromString(str)! 
        formatter.dateFormat = "MMM dd, yyyy at HH:MM a"
        str = formatter.stringFromDate(date)
        
        cell.detailTextLabel?.text = "on \(str)"
        return cell
    }
    

    @IBOutlet weak var tableview: UITableView!
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

