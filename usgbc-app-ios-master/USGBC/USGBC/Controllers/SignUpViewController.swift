//
//  SignUpViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 29/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    var eyeButton: UIButton!
    var showPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    func initViews(){
        title = "Sign Up"
        
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        phoneTF.delegate = self
        
        firstNameTF.keyboardType = .alphabet
        lastNameTF.keyboardType = .alphabet
        emailTF.keyboardType = .emailAddress
        emailTF.autocapitalizationType = .none
        phoneTF.keyboardType = .phonePad
        
        firstNameTF.returnKeyType = .next
        lastNameTF.returnKeyType = .next
        emailTF.returnKeyType = .next
        passwordTF.returnKeyType = .next
        phoneTF.returnKeyType = .go
        
        signUpLabel.font = UIFont.gothamBold(size: 16)
        signUpButton.layer.cornerRadius = 4
        signUpButton.titleLabel?.font = UIFont.gothamMedium(size: 14)
        termsLabel.font = UIFont.gothamBook(size: 12)
        
        eyeButton = UIButton()
        eyeButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        eyeButton.setBackgroundImage(UIImage(named: "eye-close"), for: .normal)
        eyeButton.tintColor = UIColor.lightGray
        eyeButton.addTarget(self, action: #selector(LoginViewController.showHidePassword(_:)), for: .touchUpInside)
        passwordTF.rightViewMode = .always
        passwordTF.rightView = eyeButton
    }
    
    func showHidePassword(_ sender: UIButton){
        if(showPassword){
            passwordTF.isSecureTextEntry = true
            sender.setBackgroundImage(UIImage(named: "eye-close"), for: .normal)
            sender.tintColor = UIColor.lightGray
            showPassword = false
        }else{
            passwordTF.isSecureTextEntry = false
            sender.setBackgroundImage(UIImage(named: "eye-open"), for: .normal)
            sender.tintColor = UIColor.hex(hex: Colors.primaryColor)
            showPassword = true
        }
    }
    
    func submit() {
        guard let firstName = firstNameTF.text, !firstName.isEmpty else {
            firstNameTF.shake()
            Utility.showToast(message: NSLocalizedString("Please enter first name.", comment: "validation"))
            return
        }
        guard let lastName = lastNameTF.text, !lastName.isEmpty else {
            lastNameTF.shake()
            Utility.showToast(message: NSLocalizedString("Please enter last name.", comment: "validation"))
            return
        }
        guard let email = emailTF.text, Utility.isValidEmail(email: email) else {
            emailTF.shake()
            Utility.showToast(message: NSLocalizedString("Please enter valid e-mail address.", comment: "validation"))
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            passwordTF.shake()
            Utility.showToast(message: NSLocalizedString("Please enter an password.", comment: "validation"))
            return
        }
        guard let phone = phoneTF.text, !phone.isEmpty else {
            phoneTF.shake()
            Utility.showToast(message: NSLocalizedString("Please enter phone number.", comment: "validation"))
            return
        }
        
        Utility.showLoading()
        ApiManager.shared.createUser(firstName: firstName, lastName: lastName, email: email, password: password, phone: phone) { (message, error) in
            if(error == nil && message != nil){
                Utility.hideLoading()
                Utility.showToast(message: message!)
                self.navigationController?.popViewController(animated: true)
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
    
    @IBAction func handleSignUp(_ sender: Any){
        submit()
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTF {
            lastNameTF.becomeFirstResponder()
        }else if textField == lastNameTF {
            emailTF.becomeFirstResponder()
        }else if textField == emailTF {
            passwordTF.becomeFirstResponder()
        }else if textField == passwordTF {
            phoneTF.becomeFirstResponder()
        }else if textField == phoneTF {
            phoneTF.resignFirstResponder()
            submit()
        }
        return false
    }
}
