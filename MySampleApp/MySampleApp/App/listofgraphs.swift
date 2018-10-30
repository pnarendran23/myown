//
//  listofgraphs.swift
//  split
//
//  Created by Group X on 11/01/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class listofgraphs: UITableViewController, UISplitViewControllerDelegate {
var label = ""
    var currentpts = [Int]()
    var currentperformancescore = [String:AnyObject]()
    var performancescoresarr = NSMutableArray()
    var allptsarr = [[1],[3,1],[5,3],[5,3,1,5,6,8],[10,1,0,2]]
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "effective_at", ascending: true)
        let descriptors: NSArray = [descriptor]
        let sortedArray: NSArray = performancescoresarr.sortedArrayUsingDescriptors(descriptors as! [NSSortDescriptor])
        performancescoresarr = sortedArray.mutableCopy() as! NSMutableArray 
  
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.adjustwidth), name: UIDeviceOrientationDidChangeNotification, object: nil)
self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        tableView.registerNib(UINib.init(nibName: "customcellwithgraph", bundle: nil), forCellReuseIdentifier: "cell")
                tableView.registerNib(UINib.init(nibName: "monthlycell", bundle: nil), forCellReuseIdentifier: "monthcell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
        if(UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft || UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight){
            if(performancescoresarr.count > 0){
        tableView(tableView, didSelectRowAtIndexPath: NSIndexPath.init(forRow: 0, inSection: 0))
            }
        }
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            if(performancescoresarr.count > 0){
        tableView(tableView, didSelectRowAtIndexPath: NSIndexPath.init(forRow: 0, inSection: 0))
            }
        }
        
        print("performance scores arr ", performancescoresarr, performancescoresarr.count )
        
        
    }
    
    
    
    func adjustwidth(){
        //super.view.layoutSubviews()
        //super.view.setNeedsLayout()
        //super.view.setNeedsDisplay()
        //tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 185
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return performancescoresarr.count
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        label = "Selected row \(indexPath.section)"        
        currentperformancescore = performancescoresarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("monthcell",forIndexPath: indexPath) as! monthlycell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let dict = performancescoresarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        if(dict["scores"] != nil){
            if(dict["scores"]!["energy"] != nil){
                if(dict["scores"]!["energy"] is NSNull){
                    cell.vv.energyscore = 0.0
                }else{
                    cell.vv.energyscore = Double(dict["scores"]!["energy"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.energyscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["water"] != nil){
                if(dict["scores"]!["water"] is NSNull){
                    cell.vv.waterscore = 0.0
                }else{
                    cell.vv.waterscore = Double(dict["scores"]!["water"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.waterscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["waste"] != nil){
                if(dict["scores"]!["waste"] is NSNull){
                    cell.vv.wastescore = 0.0
                }else{
                    cell.vv.wastescore = Double(dict["scores"]!["waste"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.wastescore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["transport"] != nil){
                if(dict["scores"]!["transport"] is NSNull){
                    cell.vv.transportscore = 0.0
                }else{
                    cell.vv.transportscore = Double(dict["scores"]!["transport"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.transportscore = 0.0
        }
        
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["human_experience"] != nil){
                if(dict["scores"]!["human_experience"] is NSNull){
                    cell.vv.humanscore = 0.0
                }else{
                    cell.vv.humanscore = Double(dict["scores"]!["human_experience"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.humanscore = 0.0
        }
        
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["energy"] != nil){
                if(dict["maxima"]!["energy"] is NSNull){
                    cell.vv.maxenergyscore = 0.0
                }else{
                    cell.vv.maxenergyscore = Double(dict["maxima"]!["energy"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxenergyscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["water"] != nil){
                if(dict["maxima"]!["water"] is NSNull){
                    cell.vv.maxwaterscore = 0.0
                }else{
                    cell.vv.maxwaterscore = Double(dict["maxima"]!["water"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxwaterscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["waste"] != nil){
                if(dict["maxima"]!["waste"] is NSNull){
                    cell.vv.maxwastescore = 0.0
                }else{
                    cell.vv.maxwastescore = Double(dict["maxima"]!["waste"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxwastescore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["transport"] != nil){
                if(dict["maxima"]!["transport"] is NSNull){
                    cell.vv.maxtransportscore = 0.0
                }else{
                    cell.vv.maxtransportscore = Double(dict["maxima"]!["transport"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxtransportscore = 0.0
        }
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["human_experience"] != nil){
                if(dict["maxima"]!["human_experience"] is NSNull){
                    cell.vv.maxhumanscore = 0.0
                }else{
                    cell.vv.maxhumanscore = Double(dict["maxima"]!["human_experience"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxhumanscore = 0.0
        }
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var str = "Not available"
        if(dict["effective_at"] != nil){
            let dateConverted: NSDate = dateFormatter.dateFromString(dict["effective_at"] as! String)!
            print(dateConverted)
            dateFormatter.dateFormat = "MMM yyyy"
            str = dateFormatter.stringFromDate(dateConverted)
            print(str)
        }
        cell.vv.datetext = str


        cell.vv.addUntitled1Animation()
        /*let cview = actualgraph()
        cview.frame = cell.graphviews.frame
        cview.startColor = UIColor.init(red: 0.860, green: 0.871, blue: 0.734, alpha: 1)
        cview.endColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
        cview.graphPoints = [1]
        var label = UILabel()
        label = cell.heading
        label.frame = cell.heading.frame
        cell.addSubview(label)
        
        label = cell.v1
        label.frame = cell.v1.frame
        cell.addSubview(label)
        
        label = cell.startscore
        label.frame = cell.startscore.frame
        cell.addSubview(label)
        
        label = cell.maxscore
        label.frame = cell.maxscore.frame
        cell.addSubview(label)
        
        cview.tag = indexPath.section
        cell.contentView.addSubview(cview)*/
    
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("monthcell",forIndexPath: indexPath) as! monthlycell
        
        let dict = performancescoresarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        if(dict["scores"] != nil){
            if(dict["scores"]!["energy"] != nil){
                if(dict["scores"]!["energy"] is NSNull){
                    cell.vv.energyscore = 0.0
                }else{
                    cell.vv.energyscore = Double(dict["scores"]!["energy"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.energyscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["water"] != nil){
                if(dict["scores"]!["water"] is NSNull){
                    cell.vv.waterscore = 0.0
                }else{
                    cell.vv.waterscore = Double(dict["scores"]!["water"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.waterscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["waste"] != nil){
                if(dict["scores"]!["waste"] is NSNull){
                   cell.vv.wastescore = 0.0
                }else{
                    cell.vv.wastescore = Double(dict["scores"]!["waste"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.wastescore = 0.0
        }
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var str = "Not available"
        if(dict["effective_at"] != nil){
            let dateConverted: NSDate = dateFormatter.dateFromString(dict["effective_at"] as! String)!
            print(dateConverted)
            dateFormatter.dateFormat = "MMM yyyy"
            str = dateFormatter.stringFromDate(dateConverted)
            print(str)
        }
        cell.vv.datetext = str
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["transport"] != nil){
                if(dict["scores"]!["transport"] is NSNull){
                    cell.vv.transportscore = 0.0
                }else{
                    cell.vv.transportscore = Double(dict["scores"]!["transport"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.transportscore = 0.0
        }
        
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["human_experience"] != nil){
                if(dict["scores"]!["human_experience"] is NSNull){
                    cell.vv.humanscore = 0.0
                }else{
                    cell.vv.humanscore = Double(dict["scores"]!["human_experience"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.humanscore = 0.0
        }
        
        
    
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["energy"] != nil){
                if(dict["maxima"]!["energy"] is NSNull){
                    cell.vv.maxenergyscore = 0.0
                }else{
                    cell.vv.maxenergyscore = Double(dict["maxima"]!["energy"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxenergyscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["water"] != nil){
                if(dict["maxima"]!["water"] is NSNull){
                    cell.vv.maxwaterscore = 0.0
                }else{
                    cell.vv.maxwaterscore = Double(dict["maxima"]!["water"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxwaterscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["waste"] != nil){
                if(dict["maxima"]!["waste"] is NSNull){
                    cell.vv.maxwastescore = 0.0
                }else{
                    cell.vv.maxwastescore = Double(dict["maxima"]!["waste"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxwastescore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["transport"] != nil){
                if(dict["maxima"]!["transport"] is NSNull){
                    cell.vv.maxtransportscore = 0.0
                }else{
                    cell.vv.maxtransportscore = Double(dict["maxima"]!["transport"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxtransportscore = 0.0
        }
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["human_experience"] != nil){
                if(dict["maxima"]!["human_experience"] is NSNull){
                    cell.vv.maxhumanscore = 0.0
                }else{
                    cell.vv.maxhumanscore = Double(dict["maxima"]!["human_experience"]!! as! Int) as! Double
                }
                
            }
        }else{
            cell.vv.maxhumanscore = 0.0
        }
        cell.vv.addUntitled1Animation()
      /*  let cell = tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! customcellwithgraph
        let cview = actualgraph()
        cview.frame = cell.graphviews.frame
        cview.startColor = UIColor.init(red: 0.860, green: 0.871, blue: 0.734, alpha: 1)
        cview.endColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
        cview.graphPoints = [1,2,3,4,5]
        cview.tag = indexPath.section
    */
        

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail"{
            let nav = segue.destinationViewController as! UINavigationController
            let vc  = nav.viewControllers[0] as! DetailViewController
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(currentpts), forKey: "ptsdata")
            vc.currentperformancescore = currentperformancescore
            vc.ptsdata = currentpts
            vc.labeltext = label
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dict = performancescoresarr.objectAtIndex(section) as! [String:AnyObject]
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var str = "Not available"
        if(dict["effective_at"] != nil){
            let dateConverted: NSDate = dateFormatter.dateFromString(dict["effective_at"] as! String)!
            print(dateConverted)
            dateFormatter.dateFormat = "MMM yyyy"
            str = dateFormatter.stringFromDate(dateConverted)
            print(str)
        }
        
        return str
        
    }
    
    
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }

    
}
