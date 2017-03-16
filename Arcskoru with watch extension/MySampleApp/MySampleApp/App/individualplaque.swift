//
//  ViewController.swift
//  dashboard
//
//  Created by Group X on 19/01/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class individualplaque: UIViewController {
    var localavgscorevalue = 0
    var globalavgscorevalue = 0
    var outerscorevalue = 0
    var innerstroke = UIColor.whiteColor()
    var pageIndex = 0
    var outermaxscorevalue = 0
    var middlescorevalue = 0
    var middlemaxscorevalue = 0
    var innerscorevalue = 0
    var innermaxscorevalue = 0
    var titlevalue = ""
    var context1value = ""
    var context2value = ""
    var strokecolor = UIColor.whiteColor()
    var plaqueimg = UIImage.init(named: "energy")!
    var w = 0.8 * UIScreen.mainScreen().bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
       /* print("Two")
        print(UIScreen.mainScreen().bounds.size.width)
        var v = UIScreen.mainScreen().bounds.size.width
        self.vv.frame.size.height = v
        self.vv.frame.size.width = v
        vv.localavgscorevalue = 32
        vv.globalavgscorevalue = 22
        vv.outerscorevalue = 31
        vv.outermaxscorevalue = 33        
        self.vv.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2,UIScreen.mainScreen().bounds.size.height/2);
        sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
        vv.setNeedsDisplay()
        vv.removeAllAnimations()
        vv.addUntitled1Animation()*/
        self.view.backgroundColor = UIColor.blackColor()
        self.vv.backgroundColor = UIColor.clearColor()
        self.vv.setNeedsDisplay()
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
            var v = UIScreen.mainScreen().bounds.size.width
            self.vv.frame.size.height = v
            self.vv.frame.size.width = v
        }else{
            var v = UIScreen.mainScreen().bounds.size.height
            self.vv.frame.size.height = v
            self.vv.frame.size.width = v
        }
        sview.scrollEnabled = true
        self.vv.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2,UIScreen.mainScreen().bounds.size.height/2);
        sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
        vv.localavgscorevalue = localavgscorevalue
        vv.globalavgscorevalue = globalavgscorevalue
        vv.outermaxscorevalue = outermaxscorevalue
        vv.outerscorevalue = outerscorevalue
        vv.middlescorevalue = middlescorevalue
        vv.middlemaxscorevalue = middlemaxscorevalue
        vv.innerscorevalue = innerscorevalue
        vv.titlevalue = titlevalue
        vv.innerstrokes = innerstroke
        vv.context1value = context1value
        vv.context2value = context2value
        vv.strokecolor = strokecolor
        vv.categoryimg = plaqueimg
        vv.innermaxscorevalue = innermaxscorevalue
        vv.removeAllAnimations()
        vv.addUntitled1Animation()
        
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("One")
    }
    
    
    
    @IBOutlet weak var vv: individual!
    @IBOutlet weak var sview: UIScrollView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

