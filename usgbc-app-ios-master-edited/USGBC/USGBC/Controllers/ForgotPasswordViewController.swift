//
//  ForgotPasswordViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 18/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews(){
        title = "Forgot password"
        resetButton.layer.cornerRadius = 4
        resetButton.titleLabel?.font = UIFont.gothamMedium(size: 14)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    func submit() {
        guard let email = emailTF.text, Utility.isValidEmail(email: email) else {
            emailTF.shake()
            Utility.showToast(message: NSLocalizedString("Please enter valid e-mail address.", comment: "validation"))
            return
        }
        Utility.showLoading()
        ApiManager.shared.resetPassword(email: email) { (message, error) in
            if(error == nil && message != nil){
                Utility.hideLoading()
                Utility.showToast(message: message!)
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
    
    @IBAction func handleReset(_ sender: Any) {
        submit()
    }
}
