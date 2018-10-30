//
//  instructions.swift
//  LEEDOn
//
//  Created by Group X on 29/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class instructions: UIViewController, UIPageViewControllerDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var pgctrl: UIPageControl!
var pageTitles = ["Explore buildings","Analysing projects","Astonishing performance scores animation","Calculating scores", "Organize submission data","Activity feed"]
var contentarray = ["Access and get information about any of your building in a finger tip from anywhere","Get the LEED performance score of the building which you want","Analyse your building performance score to get a better score and also to know, what's really affecting your score.","Calculate your emissions and their scores relfection in a single move.","Check who does that and who needs to do what for your building","Check for the status of the submitted data", "Get instant notifications about your building about its data and certification."]
var imgarray = [UIImage(named: ("list of buildings")),UIImage(named: ("plaque")),UIImage(named: ("analytics")),UIImage(named: ("calculate")),UIImage(named: ("organize")), UIImage(named: ("notifications"))]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = "Instructions"        
        let pageviewcontroller = self.storyboard?.instantiateViewControllerWithIdentifier("instructionspage") as! UIPageViewController
        pageviewcontroller.dataSource = self
        let startviewcontroller = self.viewcontrolleratIndex(NSUserDefaults.standardUserDefaults().integerForKey("instructionsrow"))
        let viewcontrollers = [startviewcontroller] as! NSArray
        pageviewcontroller.setViewControllers(viewcontrollers as! [UIViewController], direction: .Forward , animated: false, completion: nil)
        pageviewcontroller.view.frame.origin.x = 0
        pageviewcontroller.view.frame.origin.y = 0
        pageviewcontroller.view.frame.size.width = self.view.frame.size.width
        pageviewcontroller.view.frame.size.height = self.skipbtn.layer.frame.origin.y
            //self.view.frame.size.height - (0.13*self.view.frame.size.width)
        self.addChildViewController(pageviewcontroller)
        self.view.addSubview(pageviewcontroller.view)
        pageviewcontroller.didMoveToParentViewController(self)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! instructionscontentViewController).pageIndex
        
        if(index == NSNotFound){
            return nil
        }
        index = index + 1
        NSUserDefaults.standardUserDefaults().setInteger(index, forKey: "instructionsrow")
        
        if(index == pageTitles.count){
            return nil
        }
        
        return viewcontrolleratIndex(index)
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            var index = (viewController as! instructionscontentViewController).pageIndex
            
            if(index == NSNotFound){
                return nil
            }
            index = index - 1
            NSUserDefaults.standardUserDefaults().setInteger(index, forKey: "instructionsrow")
            
            if(index < 0){
                return nil
            }        
        return viewcontrolleratIndex(index)
    }

    func viewcontrolleratIndex(index:Int) -> instructionscontentViewController{
        
        let featuredRecipeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("instructionscontentViewController") as! instructionscontentViewController
        featuredRecipeViewController.pageIndex = index
        //print(imgarray[index])
        
        if let image = imgarray[index] {
            featuredRecipeViewController.img = image
            
        }
        if let text = contentarray[index] as? String {
            featuredRecipeViewController.contexts = text
        }
        
        if let text = pageTitles[index] as? String {
            featuredRecipeViewController.titleText = text
        }        
        pgctrl.currentPage = index
        pgctrl.currentPageIndicatorTintColor = UIColor.orangeColor()
        
        return featuredRecipeViewController

    }
    @IBOutlet weak var skipbtn: UIButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func skipnow(sender: AnyObject) {
       // NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
        self.performSegueWithIdentifier("gotoprojects", sender: nil)
    }

}
