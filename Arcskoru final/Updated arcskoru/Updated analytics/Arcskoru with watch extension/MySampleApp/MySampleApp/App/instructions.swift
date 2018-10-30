//
//  instructions.swift
//  LEEDOn
//
//  Created by Group X on 29/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class instructions: UIViewController, UIPageViewControllerDataSource, UINavigationControllerDelegate, UIPageViewControllerDelegate {
    
    @IBOutlet weak var pgctrl: UIPageControl!
var pageTitles = ["Explore buildings","Analysing projects","Astonishing performance scores animation","Calculating scores", "Organize submission data","Activity feed"]
var contentarray = ["Access and get information about any of your building in a finger tip from anywhere","Get the LEED performance score of the building which you want","Analyse your building performance score to get a better score and also to know, what's really affecting your score.","Calculate your emissions and their scores relfection in a single move.","Check who does that and who needs to do what for your building","Check for the status of the submitted data", "Get instant notifications about your building about its data and certification."]
var imgarray = [UIImage(named: ("list of buildings")),UIImage(named: ("plaque")),UIImage(named: ("analytics")),UIImage(named: ("calculate")),UIImage(named: ("organize")), UIImage(named: ("notifications"))]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.titlefont()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Instructions"
        let pageviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "instructionspage") as! UIPageViewController
        pageviewcontroller.dataSource = self
        pageviewcontroller.delegate = self
        let startviewcontroller = self.viewcontrolleratIndex(UserDefaults.standard.integer(forKey: "instructionsrow"))
        let viewcontrollers = [startviewcontroller] 
        pageviewcontroller.setViewControllers(viewcontrollers as [UIViewController], direction: .forward , animated: false, completion: nil)
        DispatchQueue.main.async(execute:{
            self.pgctrl.currentPage = 0
            self.pgctrl.currentPageIndicatorTintColor = UIColor.white
            self.pgctrl.currentPageIndicatorTintColor = UIColor.orange
        })
        pageviewcontroller.view.frame.origin.x = 0
        pageviewcontroller.view.frame.origin.y = 0
        pageviewcontroller.view.frame.size.width = self.view.frame.size.width
        pageviewcontroller.view.frame.size.height = self.skipbtn.layer.frame.origin.y
            //self.view.frame.size.height - (0.13*self.view.frame.size.width)
        self.addChildViewController(pageviewcontroller)
        self.view.addSubview(pageviewcontroller.view)
        pageviewcontroller.didMove(toParentViewController: self)
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        var index = (pageViewController.viewControllers?.first as! instructionscontentViewController).pageIndex
        DispatchQueue.main.async(execute:{
            self.pgctrl.currentPage = index
            self.pgctrl.currentPageIndicatorTintColor = UIColor.white
            self.pgctrl.currentPageIndicatorTintColor = UIColor.orange
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.backItem?.title = "Logout"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: listofassets().imageWithImage(UIImage(named: "signout.png")!, scaledToSize: CGSize(width: 32, height: 28)), style: .plain, target: self, action:#selector(self.leftbuttonclick(_:)))
    }
    
    func leftbuttonclick(_ sender : UIBarButtonItem){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: "Logout", message: "Would you like to logout from the current user?", preferredStyle: .alert)
            let callActionHandler = { (action:UIAlertAction!) -> Void in                
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "password")
                    UserDefaults.standard.removeObject(forKey: "building_details")
                    let appDomain = Bundle.main.bundleIdentifier!
                    let noinstructions = UserDefaults.standard.integer(forKey: "noinstructions")
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "password")
                    if let bid = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bid)
                    }
                    UserDefaults.standard.set(noinstructions, forKey: "noinstructions")
                    UserDefaults.standard.set(noinstructions, forKey: "noinstructions")
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "password")
                    UserDefaults.standard.removeObject(forKey: "tobefiltered")
                    if let bid = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bid)
                    }
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.synchronize()                    
                    self.navigationController?.popViewController(animated: true)
                
            }
            
            let cancelActionHandler = { (action:UIAlertAction!) -> Void in
                DispatchQueue.main.async(execute: {
                    
                })
                
            }
            let cancelAction = UIAlertAction(title: "No", style: .default, handler:cancelActionHandler)
            
            let defaultAction = UIAlertAction(title: "Yes", style: .default, handler:callActionHandler)
            alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
            self.present(alertController, animated: true, completion: nil)
            
        })

    }
    
    
    override var shouldAutorotate : Bool {
        // 3. Lock autorotate
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! instructionscontentViewController).pageIndex
        
        if(index == NSNotFound){
            return nil
        }
        index = index + 1
        UserDefaults.standard.set(index, forKey: "instructionsrow")        
        if(index == pageTitles.count){
            return nil
        }
        
        return viewcontrolleratIndex(index)
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            var index = (viewController as! instructionscontentViewController).pageIndex
            
            if(index == NSNotFound){
                return nil
            }
            index = index - 1
            UserDefaults.standard.set(index, forKey: "instructionsrow")
        
            if(index < 0){
                return nil
            }        
        return viewcontrolleratIndex(index)
    }

    func viewcontrolleratIndex(_ index:Int) -> instructionscontentViewController{
        
        let featuredRecipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "instructionscontentViewController") as! instructionscontentViewController
        featuredRecipeViewController.pageIndex = index
        ////print(imgarray[index])
        
        if let image = imgarray[index] {
            featuredRecipeViewController.img = image
            
        }
        if let text = contentarray[index] as? String {
            featuredRecipeViewController.contexts = text
        }
        
        if let text = pageTitles[index] as? String {
            featuredRecipeViewController.titleText = text
        }        
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
    @IBAction func skipnow(_ sender: AnyObject) {
       // NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
        self.performSegue(withIdentifier: "gotoprojects", sender: nil)
    }

}
