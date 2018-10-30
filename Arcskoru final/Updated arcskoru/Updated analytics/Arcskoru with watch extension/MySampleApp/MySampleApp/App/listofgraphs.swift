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
    var currentperformancescore = NSMutableDictionary()
    var performancescoresarr = NSMutableArray()
    var allptsarr = [[1],[3,1],[5,3],[5,3,1,5,6,8],[10,1,0,2]]
    
    
    override func viewDidDisappear(_ animated: Bool) {
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        //self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        let current_dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary        
        self.navigationItem.title = current_dict["name"] as? String
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "effective_at", ascending: true)
        let descriptors: NSArray = [descriptor]
        let sortedArray: NSArray = performancescoresarr.sortedArray(using: descriptors as! [NSSortDescriptor]) as! NSArray
        performancescoresarr = sortedArray.mutableCopy() as! NSMutableArray 
  
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustwidth), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        tableView.register(UINib.init(nibName: "customcellwithgraph", bundle: nil), forCellReuseIdentifier: "cell")
                tableView.register(UINib.init(nibName: "monthlycell", bundle: nil), forCellReuseIdentifier: "monthcell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if(UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight){
            if(performancescoresarr.count > 0){
        tableView(tableView, didSelectRowAt: IndexPath.init(row: 0, section: 0))
            }
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad){
            if(performancescoresarr.count > 0){
        tableView(tableView, didSelectRowAt: IndexPath.init(row: 0, section: 0))
            }
        }
        
        //print("performance scores arr ", performancescoresarr, performancescoresarr.count )
        
        
    }
    
    
    
    func adjustwidth(){
        //super.view.layoutSubviews()
        //super.view.setNeedsLayout()
        //super.view.setNeedsDisplay()
        //tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
            return 0.251 * UIScreen.main.bounds.size.height;
        }
        return 0.251 * UIScreen.main.bounds.size.width;
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return performancescoresarr.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        label = "Selected row \(indexPath.section)"        
        currentperformancescore = (performancescoresarr.object(at: indexPath.section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthcell",for: indexPath) as! monthlycell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let dict = (performancescoresarr.object(at: indexPath.section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        var d = dict["scores"] as! NSDictionary
        if(dict["scores"] != nil){
            if(d["energy"] != nil){
                if(d["energy"] is NSNull){
                    cell.vv.energyscore = 0.0
                }else{
                    cell.vv.energyscore = Double(d["energy"]as! Int) 
                }
                
            }
        }else{
            cell.vv.energyscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(d["water"] != nil){
                if(d["water"] is NSNull){
                    cell.vv.waterscore = 0.0
                }else{
                    cell.vv.waterscore = Double(d["water"]as! Int) 
                }
                
            }
        }else{
            cell.vv.waterscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(d["waste"] != nil){
                if(d["waste"] is NSNull){
                    cell.vv.wastescore = 0.0
                }else{
                    cell.vv.wastescore = Double(d["waste"]as! Int) 
                }
                
            }
        }else{
            cell.vv.wastescore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(d["transport"] != nil){
                if(d["transport"] is NSNull){
                    cell.vv.transportscore = 0.0
                }else{
                    cell.vv.transportscore = Double(d["transport"]as! Int) 
                }
                
            }
        }else{
            cell.vv.transportscore = 0.0
        }
        
        
        if(dict["scores"] != nil){
            if(d["human_experience"] != nil){
                if(d["human_experience"] is NSNull){
                    cell.vv.humanscore = 0.0
                }else{
                    cell.vv.humanscore = Double(d["human_experience"]as! Int) 
                }
                
            }
        }else{
            cell.vv.humanscore = 0.0
        }
        
        d = dict["maxima"] as! NSDictionary
        
        if(dict["maxima"] != nil){
            if(d["energy"] != nil){
                if(d["energy"] is NSNull){
                    cell.vv.maxenergyscore = 0.0
                }else{
                    cell.vv.maxenergyscore = Double(d["energy"]as! Int) 
                }
                
            }
        }else{
            cell.vv.maxenergyscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(d["water"] != nil){
                if(d["water"] is NSNull){
                    cell.vv.maxwaterscore = 0.0
                }else{
                    cell.vv.maxwaterscore = Double(d["water"]as! Int) 
                }
                
            }
        }else{
            cell.vv.maxwaterscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(d["waste"] != nil){
                if(d["waste"] is NSNull){
                    cell.vv.maxwastescore = 0.0
                }else{
                    cell.vv.maxwastescore = Double(d["waste"]as! Int) 
                }
                
            }
        }else{
            cell.vv.maxwastescore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(d["transport"] != nil){
                if(d["transport"] is NSNull){
                    cell.vv.maxtransportscore = 0.0
                }else{
                    cell.vv.maxtransportscore = Double(d["transport"]as! Int) 
                }
                
            }
        }else{
            cell.vv.maxtransportscore = 0.0
        }
        
        
        if(dict["maxima"] != nil){
            if(d["human_experience"] != nil){
                if(d["human_experience"] is NSNull){
                    cell.vv.maxhumanscore = 0.0
                }else{
                    cell.vv.maxhumanscore = Double(d["human_experience"]as! Int) 
                }
                
            }
        }else{
            cell.vv.maxhumanscore = 0.0
        }
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = credentials().micro_secs
        var str = "Not available"
        if(dict["effective_at"] != nil){
            let dateConverted: Date = dateFormatter.date(from: dict["effective_at"] as! String)!
            //print(dateConverted)
            dateFormatter.dateFormat = "MMM yyyy"
            str = dateFormatter.string(from: dateConverted)
            //print(str)
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthcell",for: indexPath) as! monthlycell
        
        let dict = (performancescoresarr.object(at: indexPath.section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        var d = dict["scores"] as! NSDictionary
        if(dict["scores"] != nil){
            if(d["energy"] != nil){
                if(d["energy"] is NSNull){
                    cell.vv.energyscore = 0.0
                }else{
                    cell.vv.energyscore = Double(d["energy"]as! Int)
                }
                
            }
        }else{
            cell.vv.energyscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(d["water"] != nil){
                if(d["water"] is NSNull){
                    cell.vv.waterscore = 0.0
                }else{
                    cell.vv.waterscore = Double(d["water"]as! Int) 
                }
                
            }
        }else{
            cell.vv.waterscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(d["waste"] != nil){
                if(d["waste"] is NSNull){
                   cell.vv.wastescore = 0.0
                }else{
                    cell.vv.wastescore = Double(d["waste"]as! Int) 
                }
                
            }
        }else{
            cell.vv.wastescore = 0.0
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = credentials().micro_secs
        var str = "Not available"
        if(dict["effective_at"] != nil){
            let dateConverted: Date = dateFormatter.date(from: dict["effective_at"] as! String)!
            //print(dateConverted)
            dateFormatter.dateFormat = "MMM yyyy"
            str = dateFormatter.string(from: dateConverted)
            //print(str)
        }
        cell.vv.datetext = str
        
        if(dict["scores"] != nil){
            if(d["transport"] != nil){
                if(d["transport"] is NSNull){
                    cell.vv.transportscore = 0.0
                }else{
                    cell.vv.transportscore = Double(d["transport"]as! Int) 
                }
                
            }
        }else{
            cell.vv.transportscore = 0.0
        }
        
        
        if(dict["scores"] != nil){
            if(d["human_experience"] != nil){
                if(d["human_experience"] is NSNull){
                    cell.vv.humanscore = 0.0
                }else{
                    cell.vv.humanscore = Double(d["human_experience"]as! Int) 
                }
                
            }
        }else{
            cell.vv.humanscore = 0.0
        }
        
        d = dict["maxima"] as! NSDictionary
    
        
        
        if(dict["maxima"] != nil){
            if(d["energy"] != nil){
                if(d["energy"] is NSNull){
                    cell.vv.maxenergyscore = 0.0
                }else{
                    cell.vv.maxenergyscore = Double(d["energy"]as! Int) 
                }
                
            }
        }else{
            cell.vv.maxenergyscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(d["water"] != nil){
                if(d["water"] is NSNull){
                    cell.vv.maxwaterscore = 0.0
                }else{
                    cell.vv.maxwaterscore = Double(d["water"]as! Int) 
                }
                
            }
        }else{
            cell.vv.maxwaterscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(d["waste"] != nil){
                if(d["waste"] is NSNull){
                    cell.vv.maxwastescore = 0.0
                }else{
                    cell.vv.maxwastescore = Double(d["waste"]as! Int) 
                }
                
            }
        }else{
            cell.vv.maxwastescore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(d["transport"] != nil){
                if(d["transport"] is NSNull){
                    cell.vv.maxtransportscore = 0.0
                }else{
                    cell.vv.maxtransportscore = Double(d["transport"]as! Int) 
                }
                
            }
        }else{
            cell.vv.maxtransportscore = 0.0
        }
        
        
        if(dict["maxima"] != nil){
            if(d["human_experience"] != nil){
                if(d["human_experience"] is NSNull){
                    cell.vv.maxhumanscore = 0.0
                }else{
                    cell.vv.maxhumanscore = Double(d["human_experience"]as! Int) 
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let nav = segue.destination as! UINavigationController
            let vc  = nav.viewControllers[0] as! DetailViewController
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: currentpts), forKey: "ptsdata")
            vc.currentperformancescore = currentperformancescore
            vc.ptsdata = currentpts
            vc.labeltext = label
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dict = (performancescoresarr.object(at: section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = credentials().micro_secs
        var str = "Not available"
        if(dict["effective_at"] != nil){
            let dateConverted: Date = dateFormatter.date(from: dict["effective_at"] as! String)!
            //print(dateConverted)
            dateFormatter.dateFormat = "MMM yyyy"
            str = dateFormatter.string(from: dateConverted)
            //print(str)
        }
        
        return str
        
    }
    
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    
}
