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
    var currentperformancescore = [String:AnyObject]()
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
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.adjustwidth), name: UIDeviceOrientationDidChangeNotification, object: nil)
        self.configureView()        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
separator.layer.borderColor = UIColor.whiteColor().CGColor
        
        separator.layer.borderWidth = 2
        name.adjustsFontSizeToFitWidth = true
        leedid.adjustsFontSizeToFitWidth = true
        percentage.adjustsFontSizeToFitWidth = true
        
        self.view.bringSubviewToFront(self.plaqueprogress)
        print("current performance",currentperformancescore )
        let dict = currentperformancescore
        if(dict["building"] != nil){
            if(dict["building"]!["name"] != nil){
            name.text = dict["building"]!["name"] as! String
            }else{
            name.text = "Not available"
            }
            
            if(dict["building"]!["leed_id"] != nil){
                leedid.text = "\(dict["building"]!["leed_id"] as! Int)"
            }else{
                leedid.text = "Not available"
            }
            
            var str = NSMutableString()
            if(dict["energy"] == nil || dict["energy"] is NSNull){
                str.appendString("Energy consumed : 0%")
            }else{
                str.appendString("Energy consumed : \((dict["energy"] as! Double).roundToPlaces(2))%")
            }
            str.appendString("\n")
            if(dict["water"] == nil || dict["water"] is NSNull){
                str.appendString("Water consumed : 0%")
            }else{
                str.appendString("Water consumed : \((dict["water"] as! Double).roundToPlaces(2))%")
            }
            str.appendString("\n")
            if(dict["waste"] == nil || dict["waste"] is NSNull){
                str.appendString("Waste consumed : 0%")
            }else{
                str.appendString("Waste consumed : \((dict["waste"] as! Double).roundToPlaces(2))%")
            }
            str.appendString("\n")
            if(dict["transport"] == nil || dict["transport"] is NSNull){
                str.appendString("Transportation : 0%")
            }else{
                str.appendString("Transportation : \((dict["transport"] as! Double).roundToPlaces(2))%")
            }
            str.appendString("\n")
            if(dict["human_experience"] == nil || dict["human_experience"] is NSNull){
                str.appendString("Human experience : 0%")
            }else{
                str.appendString("Human experience : \((dict["human_experience"] as! Double).roundToPlaces(2))%")
            }
            
            percentage.text = str as String
            
        }
        var totalscores = 0
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["energy"] != nil){
                if(dict["scores"]!["energy"] is NSNull){
                    self.plaqueprogress.energyscore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.energyscore = Double(dict["scores"]!["energy"]!! as! Int) as! Double
                    totalscores = totalscores + (dict["scores"]!["energy"]!! as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.energyscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["water"] != nil){
                if(dict["scores"]!["water"] is NSNull){
                    self.plaqueprogress.waterscore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.waterscore = Double(dict["scores"]!["water"]!! as! Int) as! Double
                    totalscores = totalscores + (dict["scores"]!["water"]!! as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.waterscore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["waste"] != nil){
                if(dict["scores"]!["waste"] is NSNull){
                    self.plaqueprogress.wastescore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.wastescore = Double(dict["scores"]!["waste"]!! as! Int) as! Double
                    
                    totalscores = totalscores + (dict["scores"]!["waste"]!! as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.wastescore = 0.0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["transport"] != nil){
                if(dict["scores"]!["transport"] is NSNull){
                    self.plaqueprogress.transportscore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.transportscore = Double(dict["scores"]!["transport"]!! as! Int) as! Double
                    
                    totalscores = totalscores + (dict["scores"]!["transport"]!! as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.transportscore = 0.0
        }
        
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["human_experience"] != nil){
                if(dict["scores"]!["human_experience"] is NSNull){
                    self.plaqueprogress.humanscore = 0.0
                    totalscores = totalscores + 0
                }else{
                    self.plaqueprogress.humanscore = Double(dict["scores"]!["human_experience"]!! as! Int) as! Double
                    
                    totalscores = totalscores + (dict["scores"]!["human_experience"]!! as! Int)
                }
                
            }
        }else{
            self.plaqueprogress.humanscore = 0.0
        }
        
        totalscore.text = "\(totalscores)"
        
        
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["energy"] != nil){
                if(dict["maxima"]!["energy"] is NSNull){
                    self.plaqueprogress.maxenergyscore = 0.0
                }else{
                    self.plaqueprogress.maxenergyscore = Double(dict["maxima"]!["energy"]!! as! Int) as! Double
                }
             
            }
        }else{
            self.plaqueprogress.maxenergyscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["water"] != nil){
                if(dict["maxima"]!["water"] is NSNull){
                    self.plaqueprogress.maxwaterscore = 0.0
                }else{
                    self.plaqueprogress.maxwaterscore = Double(dict["maxima"]!["water"]!! as! Int) as! Double
                }
                
            }
        }else{
            self.plaqueprogress.maxwaterscore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["waste"] != nil){
                if(dict["maxima"]!["waste"] is NSNull){
                    self.plaqueprogress.maxwastescore = 0.0
                }else{
                    self.plaqueprogress.maxwastescore = Double(dict["maxima"]!["waste"]!! as! Int) as! Double
                }
                
            }
        }else{
            self.plaqueprogress.maxwastescore = 0.0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["transport"] != nil){
                if(dict["maxima"]!["transport"] is NSNull){
                    self.plaqueprogress.maxtransportscore = 0.0
                }else{
                    self.plaqueprogress.maxtransportscore = Double(dict["maxima"]!["transport"]!! as! Int) as! Double
                }
                
            }
        }else{
            self.plaqueprogress.maxtransportscore = 0.0
        }
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["human_experience"] != nil){
                if(dict["maxima"]!["human_experience"] is NSNull){
                    self.plaqueprogress.maxhumanscore = 0.0
                }else{
                    self.plaqueprogress.maxhumanscore = Double(dict["maxima"]!["human_experience"]!! as! Int) as! Double
                }
                
            }
        }else{
            self.plaqueprogress.maxhumanscore = 0.0
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
        self.plaqueprogress.datetext = str
        if(dict["certification_level"] is NSNull){
            certimg.image = UIImage.init(named: "puck")
        }else{
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
        }
        
        self.plaqueprogress.addUntitled1Animation()
        
        
    }

   @IBOutlet weak var separator: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            
            // Update the view.
            self.configureView()
        }
    }
    
    
}

