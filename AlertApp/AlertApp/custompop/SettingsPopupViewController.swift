//
//  SettingsPopupViewController.swift
//  AlertApp
//
//  Created by Group10 on 28/03/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import UIKit

class SettingsPopupViewController: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    @IBAction func dismissPopup(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alertView.layer.cornerRadius = 5;
        alertView.layer.masksToBounds = true;
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
