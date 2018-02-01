//
//  LibraryViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class PublicationTabViewController: UITabBarController {
    
    let helper = Utility()
    var userDidLogin = false
    let sb = UIStoryboard(name: "Dashboard", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if(helper.getTokenDetail() != ""){
            userDidLogin = true
        }
        var cloudTab: UIViewController!
        if(userDidLogin){
            cloudTab = sb.instantiateViewController(withIdentifier: "PublicationCloudListViewController")
        }else{
            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginViewController.sender = "PublicationViewController"
            cloudTab = loginViewController
        }
        let cloudTabBarItem = UITabBarItem(title: "Cloud", image: UIImage(named: "cloud_empty"), selectedImage: UIImage(named: "cloud_empty"))
        cloudTabBarItem.tag = 0
        cloudTab.tabBarItem = cloudTabBarItem
        
        let deviceTab = sb.instantiateViewController(withIdentifier: "PublicationDeviceListViewController")
        let deviceTabBarItem = UITabBarItem(title: "Device", image: UIImage(named: "device_empty"), selectedImage: UIImage(named: "device_empty"))
        deviceTabBarItem.tag = 1
        deviceTab.tabBarItem = deviceTabBarItem
        
        self.viewControllers = [cloudTab, deviceTab]
    }
    
    //To cretae tabs
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
}

extension PublicationTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return Utility.animateTabView(tabBarController: tabBarController, shouldSelect: viewController)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Utility.animateTabItem(tabBar: tabBar, didSelect: item)
    }
}
