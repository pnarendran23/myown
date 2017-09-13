//
//  DetailViewController.swift
//  master
//
//  Created by Group X on 11/01/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
var labeltext = ""
    var currentperformancescore = NSMutableDictionary()
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailview: UIView!
    var ptsdata = [1,2,3,4,5]

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    @IBOutlet weak var plaqueprogress: detailedanimview!
    
    @IBOutlet weak var totalscore: UILabel!
    @IBOutlet weak var vv: UIImageView!
    
    func adjustwidth(){
        super.view.layoutSubviews()
        plaqueprogress.setNeedsLayout()
        plaqueprogress.setNeedsDisplay()
    }
    @IBOutlet weak var leedid: UILabel!
    @IBOutlet weak var certimg: UIImageView!
    
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bottomview: UIView!
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustwidth), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.configureView()        
    }
    override func viewDidDisappear(_ animated: Bool) {
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        if(self.navigationController is NSNull){
            
        }else{
        self.navigationController?.navigationBar.backItem?.title = "Back"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let current_dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        self.navigationItem.title = current_dict["name"] as? String
        self.titlefont()
separator.layer.borderColor = UIColor.white.cgColor
        
        separator.layer.borderWidth = 2
        name.adjustsFontSizeToFitWidth = true
        leedid.adjustsFontSizeToFitWidth = true
        percentage.adjustsFontSizeToFitWidth = true
        
        self.view.bringSubview(toFront: self.plaqueprogress)
        //print("current performance",currentperformancescore )
        let dict = currentperformancescore
        var d = dict["building"] as! NSDictionary
        if(dict["building"] != nil){
            if(d["name"] != nil){
            name.text = d["name"] as? String
            }else{
            name.text = "Not available"
            }
            
            if(d["leed_id"] != nil){
                leedid.text = "\(d["leed_id"] as! Int)"
            }else{
                leedid.text = "Not available"
            }
            
            var str = NSMutableString()
            if(dict["energy"] == nil || dict["energy"] is NSNull){
                str.append("Energy consumed : 0%")
            }else{
                str.append("Energy consumed : \((dict["energy"] as! Double).roundToPlaces(places: 2))%")
            }
            str.append("\n")
            if(dict["water"] == nil || dict["water"] is NSNull){
                str.append("Water consumed : 0%")
            }else{
                str.append("Water consumed : \((dict["water"] as! Double).roundToPlaces(places:2))%")
            }
            str.append("\n")
            if(dict["waste"] == nil || dict["waste"] is NSNull){
                str.append("Waste consumed : 0%")
            }else{
                str.append("Waste consumed : \((dict["waste"] as! Double).roundToPlaces(places:2))%")
            }
            str.append("\n")
            if(dict["transport"] == nil || dict["transport"] is NSNull){
                str.append("Transportation : 0%")
            }else{
                str.append("Transportation : \((dict["transport"] as! Double).roundToPlaces(places:2))%")
            }
            str.append("\n")
            if(dict["human_experience"] == nil || dict["human_experience"] is NSNull){
                str.append("Human experience : 0%")
            }else{
                str.append("Human experience : \((dict["human_experience"] as! Double).roundToPlaces(places:2))%")
            }
            
            percentage.text = str as String
            
        }
        var totalscores = 0
        d = dict["scores"] as! NSDictionary
        if(dict["scores"] != nil){
            if(d["energy"] != nil){
                if(d["energy"] is NSNull){
                    self.plaqueprogress.energyscore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.energyscore = Double(d["energy"] as! Int)
                    totalscores = totalscores + (d["energy"] as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.energyscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(d["water"] != nil){
                if(d["water"] is NSNull){
                    self.plaqueprogress.waterscore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.waterscore = Double(d["water"] as! Int) 
                    totalscores = totalscores + (d["water"] as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.waterscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(d["waste"] != nil){
                if(d["waste"] is NSNull){
                    self.plaqueprogress.wastescore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.wastescore = Double(d["waste"] as! Int) 
                    
                    totalscores = totalscores + (d["waste"] as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.wastescore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(d["transport"] != nil){
                if(d["transport"] is NSNull){
                    self.plaqueprogress.transportscore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.transportscore = Double(d["transport"] as! Int) 
                    
                    totalscores = totalscores + (d["transport"] as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.transportscore = 0.0
        }
        
        
        if(dict["scores"] != nil){
            if(d["human_experience"] != nil){
                if(d["human_experience"] is NSNull){
                    self.plaqueprogress.humanscore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.humanscore = Double(d["human_experience"] as! Int) 
                    
                    totalscores = totalscores + (d["human_experience"] as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.humanscore = 0.0
        }
        
        totalscore.text = "\(totalscores)"
        
        
        d = dict["maxima"] as! NSDictionary
        
        if(dict["maxima"] != nil){
            if(d["energy"] != nil){
                if(d["energy"] is NSNull){
                    self.plaqueprogress.maxenergyscore = 0.0
                }else{
                    self.plaqueprogress.maxenergyscore = Double(d["energy"] as! Int) 
                }
             
            }
        }else{
            self.plaqueprogress.maxenergyscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(d["water"] != nil){
                if(d["water"] is NSNull){
                    self.plaqueprogress.maxwaterscore = 0.0
                }else{
                    self.plaqueprogress.maxwaterscore = Double(d["water"] as! Int) 
                }
                
            }
        }else{
            self.plaqueprogress.maxwaterscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(d["waste"] != nil){
                if(d["waste"] is NSNull){
                    self.plaqueprogress.maxwastescore = 0.0
                }else{
                    self.plaqueprogress.maxwastescore = Double(d["waste"] as! Int) 
                }
                
            }
        }else{
            self.plaqueprogress.maxwastescore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(d["transport"] != nil){
                if(d["transport"] is NSNull){
                    self.plaqueprogress.maxtransportscore = 0.0
                }else{
                    self.plaqueprogress.maxtransportscore = Double(d["transport"] as! Int) 
                }
                
            }
        }else{
            self.plaqueprogress.maxtransportscore = 0.0
        }
        
        
        if(dict["maxima"] != nil){
            if(d["human_experience"] != nil){
                if(d["human_experience"] is NSNull){
                    self.plaqueprogress.maxhumanscore = 0.0
                }else{
                    self.plaqueprogress.maxhumanscore = Double(d["human_experience"] as! Int) 
                }
                
            }
        }else{
            self.plaqueprogress.maxhumanscore = 0.0
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
        self.plaqueprogress.datetext = str
        if(dict["certification_level"] is NSNull){
            certimg.image = UIImage.init(named: "puck")
        }else{
            if(dict["certification_level"] != nil){
        if(dict["certification_level"] as! String == "certified"){
            certimg.image = UIImage.init(named: "certified")
        }else if(dict["certification_level"] as! String == "silver"){
            certimg.image = UIImage.init(named: "silver")
        }else if(dict["certification_level"] as! String == "gold"){
            certimg.image = UIImage.init(named: "gold")
        }else if(dict["certification_level"] as! String == "platinum"){
            certimg.image = UIImage.init(named: "platinum")
        }else{
            certimg.image = UIImage.init(named: "puck")
        }
            }else{
                certimg.image = UIImage.init(named: "puck")
            }
        }
        
        self.plaqueprogress.addUntitled1Animation()
        
        
    }

   @IBOutlet weak var separator: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Date? {
        didSet {
            
            // Update the view.
            self.configureView()
        }
    }
    
    
}

