//
//  ContentViewController.swift
//  LEEDOn
//
//  Created by Group X on 29/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class overallplaque: UIViewController {
    var pageIndex = 0
    var titleText = "123"
    var contexts = "asd"
    var energyscorevalue = 0, waterscorevalue = 0, wastescorevalue = 0, transportscorevalue = 0, humanscorevalue = 0
    var energymaxscorevalue = 0, watermaxscorevalue = 0, wastemaxscorevalue = 0, transportmaxscorevalue = 0, humanmaxscorevalue = 10
    var w = 0.8 * UIScreen.mainScreen().bounds.size.width
    var colorarr = [UIColor.redColor(),UIColor.orangeColor(),UIColor.blueColor(),UIColor.whiteColor(),UIColor.brownColor(),UIColor.darkGrayColor()]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        print("Size",w,0.8 * UIScreen.mainScreen().bounds.size.height)
        self.view.backgroundColor = UIColor.whiteColor()
        self.vv.backgroundColor = UIColor.clearColor()
        self.vv.setNeedsDisplay()
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
        let v = UIScreen.mainScreen().bounds.size.width
        self.vv.frame.size.height = v
        self.vv.frame.size.width = v
        }else{
            let v = UIScreen.mainScreen().bounds.size.height
            self.vv.frame.size.height = v
            self.vv.frame.size.width = v
        }
        sview.scrollEnabled = true
        self.vv.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2,UIScreen.mainScreen().bounds.size.height/2);
        sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
        vv.energyscorevalue = energyscorevalue
        vv.energymaxscorevalue = energymaxscorevalue
        vv.waterscorevalue = waterscorevalue
        vv.watermaxscorevalue = watermaxscorevalue
        vv.wastescorevalue = wastescorevalue
        vv.wastemaxscorevalue = wastemaxscorevalue
        vv.transportscorevalue = transportscorevalue
        vv.transportmaxscorevalue = transportmaxscorevalue
        vv.humanscorevalue = humanscorevalue
        vv.humanmaxscorevalue = humanmaxscorevalue
        vv.addUntitled1Animation()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBOutlet weak var sview: UIScrollView!
    
    @IBOutlet weak var vv: dashboardview!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var cc: UIView!
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
   
    
}
