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
    
    override func viewDidAppear(_ animated: Bool) {
        if(UserDefaults.standard.integer(forKey: "noinstructions") == 1){
            toggleswitch.isOn = true
        }else{
            toggleswitch.isOn = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true
        titletext.adjustsFontSizeToFitWidth = true
        context.adjustsFontSizeToFitWidth = true
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            self.view.addSubview(blurEffectView)
             //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.view.backgroundColor = UIColor.black
        }
        self.getstarted.layer.cornerRadius = 10
        self.vv.layer.cornerRadius = 10
        self.view.bringSubview(toFront: spinner)
        self.view.bringSubview(toFront: vv)
        self.view.bringSubview(toFront: getstarted)
        self.view.bringSubview(toFront: toggleswitch)
        self.view.bringSubview(toFront: dontshowlbl)
        self.dontshowlbl.adjustsFontSizeToFitWidth = true
        imgview.image =  img
        titletext.text = titleText
        context.text = contexts
        
        if(pageIndex == 5){
            getstarted.isHidden = false
        }else{
            getstarted.isHidden = true
        }
        // Do any additional setup after loading the view.
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override var shouldAutorotate : Bool {
        // 3. Lock autorotate
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
    @IBOutlet weak var toggleswitch: UISwitch!
    
    @IBAction func toggleit(_ sender: AnyObject) {
        if(toggleswitch.isOn == true){
            UserDefaults.standard.set(1, forKey: "noinstructions")
        }else{
            UserDefaults.standard.set(0, forKey: "noinstructions")
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

    @IBAction func getstartedclick(_ sender: AnyObject) {
        let c = startupanimation()
        c.frame = cc.frame
        c.frame.size.width = cc.frame.size.width
        c.frame.size.height = cc.frame.size.width
        c.addOldAnimation()
        self.spinner.isHidden = false
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(instructionscontentViewController.timerDidFire), userInfo: nil, repeats: false)
        
    }
    
    func timerDidFire(){
        //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
        let datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
        let rootViewController = self.navigationController
        var controllers = (rootViewController!.viewControllers)
        controllers.removeAll()
        var v = UIViewController()
        let grid = 0
        if(UserDefaults.standard.integer(forKey: "grid") == 1){
            v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
        }else{
            v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
        }
        var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
        if(grid == 1){
            listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
        }else{
            listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
        }
        
        listofassets.navigationItem.title = "All projects"
        controllers.append(listofassets)
        //controllers.append(listofactions)
        //controllers.append(datainput)
        self.navigationController?.setViewControllers(controllers, animated: false)
        
    }
    
    
}
