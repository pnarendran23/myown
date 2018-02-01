//
//  DirectoryViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class DirectoryTabViewController: UITabBarController{
    
    let sb = UIStoryboard(name: "Dashboard", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let orgTab = sb.instantiateViewController(withIdentifier: "DirectoryOrganizationListViewController")
        let orgTabBarItem = UITabBarItem(title: "Organizations", image: UIImage(named: "org_empty"), selectedImage: UIImage(named: "org_empty"))
        orgTabBarItem.tag = 0
        orgTab.tabBarItem = orgTabBarItem
        
        let peopleTab = sb.instantiateViewController(withIdentifier: "DirectoryPeopleListViewController")
        let peopleTabBarItem = UITabBarItem(title: "People", image: UIImage(named: "people_empty"), selectedImage: UIImage(named: "people_empty"))
        peopleTabBarItem.tag = 1
        peopleTab.tabBarItem = peopleTabBarItem
        
        let projectsTab = sb.instantiateViewController(withIdentifier: "DirectoryProjectListViewController")
        let projectsTabBarItem = UITabBarItem(title: "Projects", image: UIImage(named: "projects_empty"), selectedImage: UIImage(named: "projects_empty"))
        projectsTabBarItem.tag = 2
        projectsTab.tabBarItem = projectsTabBarItem
        
        viewControllers = [orgTab, peopleTab, projectsTab]
    }
    
    //To create tabs
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
}

extension DirectoryTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
         return Utility.animateTabView(tabBarController: tabBarController, shouldSelect: viewController)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Utility.animateTabItem(tabBar: tabBar, didSelect: item)
    }
}
