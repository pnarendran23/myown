//
//  MyAccountViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class MyAccountTabViewController: UITabBarController{
    
    let sb = UIStoryboard(name: "Dashboard", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        title = "Account Settings"
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        let settingTab = sb.instantiateViewController(withIdentifier: "accsettings")
        let settingTabBarItem = UITabBarItem(title: "Accounts", image: UIImage(named: "temp"), selectedImage: UIImage(named: "temp"))
        settingTabBarItem.tag = 0
        settingTab.tabBarItem = settingTabBarItem
        
        let profileTab = PersonalProfileViewController()
        let profileTabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "temp"), selectedImage: UIImage(named: "temp"))
        profileTabBarItem.tag = 1
        profileTab.tabBarItem = profileTabBarItem
        
        let subscriptionTab = sb.instantiateViewController(withIdentifier: "EmailSubscriptionViewController")
        let subscriptionTabBarItem = UITabBarItem(title: "Subscription", image: UIImage(named: "temp"), selectedImage: UIImage(named: "temp"))
        subscriptionTabBarItem.tag = 2
        subscriptionTab.tabBarItem = subscriptionTabBarItem
        viewControllers = [settingTab, profileTab]
        self.tabBar.isHidden = true
        
    }
    
    //To create tabs

}
extension MyAccountTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return Utility.animateTabView(tabBarController: tabBarController, shouldSelect: viewController)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Utility.animateTabItem(tabBar: tabBar, didSelect: item)
    }
}
