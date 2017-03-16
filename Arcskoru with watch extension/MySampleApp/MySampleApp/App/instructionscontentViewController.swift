//
//  ContentViewController.swift
//  LEEDOn
//
//  Created by Group X on 29/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class instructionscontentViewController: UIViewController, UINavigationControllerDelegate {
    var dataObject: AnyObject?
    var pageIndex = 0
    var titleText = "123"
    var contexts = "asd"
    @IBOutlet weak var titletext: UILabel!
    @IBOutlet weak var context: UILabel!
    @IBOutlet weak var vv: UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var getstarted: UIButton!
    @IBOutlet weak var imgview: UIImageView!
    var img = UIImage()
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.hidden = true
        titletext.adjustsFontSizeToFitWidth = true
        context.adjustsFontSizeToFitWidth = true
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.view.addSubview(blurEffectView)
             //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.view.backgroundColor = UIColor.blackColor()
        }
        self.getstarted.layer.cornerRadius = 10
        self.vv.layer.cornerRadius = 10
        self.view.bringSubviewToFront(spinner)
        self.view.bringSubviewToFront(vv)
        self.view.bringSubviewToFront(getstarted)
        imgview.image =  img
        titletext.text = titleText
        context.text = contexts
        
        if(pageIndex == 5){
            getstarted.hidden = false
        }else{
            getstarted.hidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var cc: UIView!
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func getstartedclick(sender: AnyObject) {
        var c = startupanimation()
        c.frame = cc.frame
        c.frame.size.width = cc.frame.size.width
        c.frame.size.height = cc.frame.size.width
        c.addOldAnimation()
        self.spinner.hidden = false
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(instructionscontentViewController.timerDidFire), userInfo: nil, repeats: false)
        
    }
    
    func timerDidFire(){
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
    }
    
    
}
