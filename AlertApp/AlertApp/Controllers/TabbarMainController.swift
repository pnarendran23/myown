//
//  TabbarMainController.swift
//  LGSideMenuControllerDemo
//
//  Created by Group10 on 29/01/18.
//  Copyright © 2018 Cole Dunsby. All rights reserved.
//

import Foundation
class TabbarMainController: UITabBarController , UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .plain, target: self, action: #selector(showLeftView(sender:)))
        //        let logo = UIImage().resizetheImage(image: (UIImage(named: "tab1_msg_on.png")!), newWidth: 20)
        let imageView = UIImage(named: "top-menu-nav-2x.png")!
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imageView, style: .plain, target: self, action: #selector(showLeftView(sender:)))
        
        self.tabBarController?.tabBarItem.image = imageView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnSpecialNotification), name: NSNotification.Name(rawValue: "mySpecialNotificationKey"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//         UserDefaults.standard.string(forKey: "Key")
        if(UserDefaults.standard.string(forKey: "fromnotification") != nil){
                if(UserDefaults.standard.string(forKey: "fromnotification")  == "a"){
                    self.selectedIndex = 2
                    UserDefaults.standard.set("", forKey: "fromnotification")
                }else  if(UserDefaults.standard.string(forKey: "fromnotification")  == "b"){
                    self.selectedIndex = 1
                    UserDefaults.standard.set("", forKey: "fromnotification")
                }
//                else{
//                    self.selectedIndex = 0
//                }
        }else{
//            self.selectedIndex = 0
        }
    }
    
    @objc func actOnSpecialNotification() {
        if(Utility().getFCMType() == "b"){
          self.tabBar.items![1].badgeValue = String(Utility().getMsgFCMCount())
        }else{
        self.tabBar.items![2].badgeValue = String(Utility().getAlertsFCMCount())
        }
        
        print("I heard the notification!")
    }
    
    
    @objc func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    func showRightView(sender: AnyObject?) {
        sideMenuController?.showRightView(animated: true, completionHandler: nil)
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("the selected index is : \(tabBar.items?.index(of: item))")
        let selected : Int = (tabBar.items?.index(of: item))!
        
        if(selected == 1){
            self.tabBar.items![1].badgeValue = nil
            Utility().saveMsgFCMCount(fcm: 0)
            UIApplication.shared.applicationIconBadgeNumber = Utility().getMsgFCMCount() + 0
        }else if(selected == 2){
            Utility().saveAlertsFCMCount(fcm: 0)
            self.tabBar.items![2].badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0 + Utility().getAlertsFCMCount()
        }
    }
    
}

extension UIImage{
    
    func resizetheImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth,height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth,height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}

