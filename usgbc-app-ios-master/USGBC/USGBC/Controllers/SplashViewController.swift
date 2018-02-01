//
//  ViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var logoIV = UIImageView()
    var titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        navigateToDashboard()
    }

    //To initialize navigationbar and other default views
    func initViews(){
        view.backgroundColor = UIColor.white
        navigationController?.isNavigationBarHidden = true
        logoIV.frame = CGRect(x: 8, y: 18, width: view.frame.width - 16, height: view.frame.height - 16)
        let image = UIImage(named: "logo-usgbc-gray")//!.withRenderingMode(.alwaysTemplate)
        logoIV.image = image
        //logoIV.tintColor = UIColor.hexStringToUIColor(hex: Colors.primaryColor)
        logoIV.contentMode = .scaleAspectFit
        view.addSubview(logoIV)
        
        titleLabel.text = "© 2017 U.S. Green Building Council"
        titleLabel.frame = CGRect(x: 8, y: view.frame.height - 52, width: view.frame.width - 16, height: 40)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    func navigateToDashboard(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            navigationController?.present(UINavigationController(rootViewController: DashboardViewController()), animated: false, completion: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DashboardVC")
            self.navigationController?.present(UINavigationController(rootViewController:controller), animated: false, completion: nil)
        }
    }
}

