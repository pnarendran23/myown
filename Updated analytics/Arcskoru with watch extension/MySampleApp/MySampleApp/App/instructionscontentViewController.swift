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
    
    override func viewDidAppear(animated: Bool) {
        if(NSUserDefaults.standardUserDefaults().integerForKey("noinstructions") == 1){
            toggleswitch.on = true
        }else{
            toggleswitch.on = false
        }
    }
    
    
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
        self.view.bringSubviewToFront(toggleswitch)
        self.view.bringSubviewToFront(dontshowlbl)
        self.dontshowlbl.adjustsFontSizeToFitWidth = true
        imgview.image =  img
        titletext.text = titleText
        context.text = contexts
        
        if(pageIndex == 5){
            getstarted.hidden = false
        }else{
            getstarted.hidden = true
        }
        // Do any additional setup after loading the view.
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    override func shouldAutorotate() -> Bool {
        // 3. Lock autorotate
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }
    @IBOutlet weak var toggleswitch: UISwitch!
    
    @IBAction func toggleit(sender: AnyObject) {
        if(toggleswitch.on == true){
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "noinstructions")
        }else{
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "noinstructions")
        }
    }
    
    @IBOutlet weak var dontshowlbl: UILabel!
    
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
        //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
        let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
        let rootViewController = self.navigationController
        var controllers = (rootViewController!.viewControllers)
        controllers.removeAll()
        var v = UIViewController()
        var grid = 0
        if(NSUserDefaults.standardUserDefaults().integerForKey("grid") == 1){
            v = mainstoryboard.instantiateViewControllerWithIdentifier("grid") as! UINavigationController
        }else{
            v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets") as! UINavigationController
        }
        var listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
        if(grid == 1){
            listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("gridvc")
        }else{
            listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
        }
        
        listofassets.navigationItem.title = "All projects"
        controllers.append(listofassets)
        //controllers.append(listofactions)
        //controllers.append(datainput)
        self.navigationController?.setViewControllers(controllers, animated: false)
        
    }
    
    
}
