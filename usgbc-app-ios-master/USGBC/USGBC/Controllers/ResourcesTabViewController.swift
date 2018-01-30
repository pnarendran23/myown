//
//  ResoursesViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class ResourcesTabViewController: UITabBarController {
    
    let sb = UIStoryboard(name: "Dashboard", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let leedTab = sb.instantiateViewController(withIdentifier: "ResourceLeedListViewController")
        let leedTabBarItem = UITabBarItem(title: "LEED", image: UIImage(named: "temp"), selectedImage: UIImage(named: "temp"))
        leedTabBarItem.tag = 0
        leedTab.tabBarItem = leedTabBarItem
        
        let credTab = sb.instantiateViewController(withIdentifier: "ResourceCredentialingListViewController")
        let credTabBarItem = UITabBarItem(title: "Credentialing", image: UIImage(named: "temp"), selectedImage: UIImage(named: "temp"))
        credTabBarItem.tag = 1
        credTab.tabBarItem = credTabBarItem
        
        let advAndPolTab = sb.instantiateViewController(withIdentifier: "ResourceAdvAndPolicyListViewController")
        let advAndPolTabBarItem = UITabBarItem(title: "Advocacy & Policy", image: UIImage(named: "temp"), selectedImage: UIImage(named: "temp"))
        advAndPolTabBarItem.tag = 2
        advAndPolTab.tabBarItem = advAndPolTabBarItem
        
        viewControllers = [leedTab, credTab, advAndPolTab]
    }
    
    //To cretae tabs
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
}

extension ResourcesTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return Utility.animateTabView(tabBarController: tabBarController, shouldSelect: viewController)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Utility.animateTabItem(tabBar: tabBar, didSelect: item)
    }
}
