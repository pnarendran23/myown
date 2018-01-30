//
//  CeHoursViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class CredentialsTabViewController: UITabBarController {
    
    let sb = UIStoryboard(name: "Dashboard", bundle: nil)
    var ceActivities: [CEActivity] = []
    var uiView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        title = "Credentials"
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        let credentialsOverviewViewController = sb.instantiateViewController(withIdentifier: "CredentialsOverviewViewController") as! CredentialsOverviewViewController
        let overviewTab = credentialsOverviewViewController
        let overviewTabBarItem = UITabBarItem(title: "CE History", image: UIImage(named: "temp"), selectedImage: UIImage(named: "temp"))
        overviewTabBarItem.tag = 0
        overviewTab.tabBarItem = overviewTabBarItem
        
        let credentialsCEActivityViewController = sb.instantiateViewController(withIdentifier: "CredentialsCEActivityViewController")
        let ceActivityTab = credentialsCEActivityViewController
        let ceActivityTabBarItem = UITabBarItem(title: "Overview", image: UIImage(named: "temp"), selectedImage: UIImage(named: "temp"))
        ceActivityTabBarItem.tag = 1
        ceActivityTab.tabBarItem = ceActivityTabBarItem
        
        viewControllers = [ceActivityTab, overviewTab]
    }
    
    //To create tabs
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension CredentialsTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return Utility.animateTabView(tabBarController: tabBarController, shouldSelect: viewController)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Utility.animateTabItem(tabBar: tabBar, didSelect: item)
    }
}
