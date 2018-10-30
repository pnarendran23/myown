//
//  WalkThroughViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 26/07/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import paper_onboarding

class WalkThroughViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    @IBOutlet weak var onBoardingView: OnboardingView!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardingView.dataSource = self
        onBoardingView.delegate = self
    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = UIColor.hex(hex: Colors.primaryColor)
        let backgroundColorTwo = UIColor.hex(hex: Colors.primaryColor)
        let backgroundColorThree = UIColor.hex(hex: Colors.primaryColor)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descirptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!        
        return [("intro-usgbc", "USGBC", "The U.S. Green Building Council is committed to a prosperous and sustainable future through cost-efficient and energy-saving green buildings.", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descirptionFont),
                ("intro-article", "Articles", "Caramels cheesecake bonbon bonbon topping. Candy halvah cotton candy chocolate bar cake. Fruitcake liquorice candy canes marshmallow topping powder.", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                ("intro-publication", "Publications", "Caramels cheesecake bonbon bonbon topping. Candy halvah cotton candy chocolate bar cake. Fruitcake liquorice candy canes marshmallow topping powder.", "", backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                ("intro-education", "Education@USGBC", "USGBC offers best-in-class sustainability and green building education to grow your knowledge and fulfill continuing education for LEED credentials, AIA, and others.", "", backgroundColorThree, UIColor.white, UIColor.white, titleFont, descirptionFont)][index]
        
    }
    
    
    @IBAction func gotStarted(_ sender: Any) {
        doneWalkThrough()
    }
    
    @IBAction func skipIntro(_ sender: Any) {
        doneWalkThrough()
    }
    
    func doneWalkThrough(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onboardingComplete")
        userDefaults.synchronize()
        let viewController = self.storyboard?.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 2 {
            
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
            
            if self.skipButton.alpha == 0 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.skipButton.alpha = 1
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3 {
            UIView.animate(withDuration: 0.4, animations: {
                self.getStartedButton.alpha = 1
                self.skipButton.alpha = 0
            })
        }
    }
}
