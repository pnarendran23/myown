//
//  LoginViewController.swift
//  USGBC
//
//  Created by Vishal on 10/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SafariServices

protocol LoginDelegate: class {
    func loginDone()
}

class LoginViewController: UIViewController {
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var userNameTF: ImageTextField!
    @IBOutlet weak var passwordTF: ImageTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var eyeButton: UIButton!
    let helpUrl: String = "http://usgbc.org/user/password"
    var sender:  String = ""
    let apiManager = ApiManager()
    var helper: Utility!
    var showPassword = false
    weak var delegate: LoginDelegate?
    
    @IBAction func signup(_ sender: Any) {
        self.performSegue(withIdentifier: "signup", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollview.contentSize = CGSize(width : UIScreen.main.bounds.size.width,height : UIScreen.main.bounds.size.height)
        helper = Utility()
        initViews()
        self.containerView.backgroundColor = UIColor.white
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.masksToBounds = true
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "Sign In"
    }
    
    func submit(){
        guard let userName = userNameTF.text, !userName.isEmpty else {
            userNameTF.shake()
            Utility.showToast(message: NSLocalizedString("Please enter username.", comment: "validation"))
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            passwordTF.shake()
            Utility.showToast(message: NSLocalizedString("Please enter password.", comment: "validation"))
            return
        }
        Utility.showLoading()
        apiManager.authenticateUser(userName: userName, password: password, callback: {(token, error) -> () in
            if(error == nil && token != nil){
                Utility.hideLoading()
                self.helper.saveToken(token: token!)
                self.helper.saveLoginDetails(user: userName, password: password)
                if(self.sender == "MyAccountViewController"){
                    let newVc = MyAccountTabViewController()
                    var vcArray = self.navigationController?.viewControllers
                    vcArray!.removeLast()
                    vcArray!.append(newVc)
                    self.navigationController?.setViewControllers(vcArray!, animated: true)
                }else if(self.sender == "CredentialsViewController"){
                    let newVc = CredentialsTabViewController()
                    var vcArray = self.navigationController?.viewControllers
                    vcArray!.removeLast()
                    vcArray!.append(newVc)
                    self.navigationController?.setViewControllers(vcArray!, animated: true)
                }else if(self.sender == "PublicationViewController"){
                    let newVc = PublicationTabViewController()
                    var vcArray = self.navigationController?.viewControllers
                    vcArray!.removeLast()
                    vcArray!.append(newVc)
                    self.navigationController?.setViewControllers(vcArray!, animated: true)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
                let utility = Utility()
                let params = ["app_id": utility.getAppID(), "updated_on": Utility.getCurrentDate(), "partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "active_status": "1", "notification_status": utility.getNotifcationStatus(), "user_email": utility.getUserDetail()]
                print(params)
                ApiManager.shared.updateFCMDevice(params: params, callback: { (message, error) in
                    //
                })
                self.delegate?.loginDone()
            }else{
                Utility.hideLoading()
                self.userNameTF.shake()
                self.passwordTF.shake()
                Utility.showToast(message: "Please enter valid username and password")
            }
        })
        
    }
    
    func initViews(){
        title = "Sign In"
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        userNameTF.delegate = self
        passwordTF.delegate = self
        
        userNameTF.keyboardType = .emailAddress
        userNameTF.autocapitalizationType = .none
        
        userNameTF.returnKeyType = .next
        passwordTF.returnKeyType = .go
        
        signInLabel.font = UIFont.gothamBold(size: 16)
        loginButton.layer.cornerRadius = 4
        loginButton.titleLabel?.font = UIFont.gothamMedium(size: 14)
        signUpButton.layer.cornerRadius = 4
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        signUpButton.titleLabel?.font = UIFont.gothamMedium(size: 14)
        helpButton.titleLabel?.font = UIFont.gothamBook(size: 12)
        
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
    
    @IBAction func handleLogin(_ sender: Any) {
        submit()
    }
    
    @IBAction func HandleSignUpButton(_ sender: Any){}
    
    @IBAction func handleNeedHelp(_ sender: Any) {
        if let url = URL(string: self.helpUrl) {
            let svc = SFSafariViewController(url: url)            
            present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleForgetPassword(_ sender: Any) {
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTF {
            passwordTF.becomeFirstResponder()
        }else if textField == passwordTF {
            passwordTF.resignFirstResponder()
            submit()
        }
        return false
    }
}
