//
//  ViewController.swift
//  Placer
//
//  Created by Vishal on 10/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import TTGSnackbar

class SplashViewController: UIViewController {
    var logoIV:UIImageView!
    var appNameLabel:UILabel!
    var logInfoLabel:UILabel!
    var poweredByLabel:UILabel!
    var pwrByContainer:UIView!
    var loadingView:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.dodo.topLayoutGuide = topLayoutGuide
        self.initViews()
    }
    
    func initViews() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.hexStringToUIColor("#323754")
        
        self.appNameLabel = UILabel()
        self.appNameLabel.text = "Placer"
        self.appNameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 40)
        self.appNameLabel.font = UIFont(name: "Roboto-Thin", size: 40.0)
        self.appNameLabel.textColor = UIColor.white
        self.appNameLabel.textAlignment = .center
        self.appNameLabel.center = self.view.center
        self.view.addSubview(self.appNameLabel)
        
        self.logoIV = UIImageView()
        let image = UIImage(named: "logo")!.withRenderingMode(.alwaysTemplate)
        self.logoIV.image = image
        self.logoIV.tintColor = UIColor.white
        self.logoIV.frame = CGRect(x: CGFloat((width/2)-40), y: CGFloat(appNameLabel.frame.origin.y-80), width: 80, height: 80)
        self.logoIV.contentMode = .scaleAspectFit
        self.view.addSubview(self.logoIV)
        
        self.logInfoLabel = UILabel()
        self.logInfoLabel.text = "Getting logged member info..."
        self.logInfoLabel.frame = CGRect(x: 0, y: CGFloat(appNameLabel.frame.origin.y+appNameLabel.frame.height), width: width, height: 40)
        self.logInfoLabel.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.logInfoLabel.textColor = UIColor.white
        self.logInfoLabel.textAlignment = .center
        self.view.addSubview(self.logInfoLabel)
        
        self.pwrByContainer = UIView()
        self.pwrByContainer.frame = CGRect(x: 0, y: CGFloat(height-15), width: width, height: 15)
        self.pwrByContainer.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.view.addSubview(self.pwrByContainer)
        
        self.poweredByLabel = UILabel()
        DispatchQueue.main.async(execute: {
            let attrStr = try! NSAttributedString(
                data: "<font color = #FFFFFF>&copy; </font> <font color = #a2a2a2>Powered by</font> <font color = #FFFFFF><b>GROUP</font><font color = #00B7CE>10</font></b>".data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.poweredByLabel.attributedText = attrStr
            self.poweredByLabel.frame = CGRect(x: 0, y: CGFloat(height-29), width: width, height: 40)
            self.poweredByLabel.textAlignment = .center
            self.view.addSubview(self.poweredByLabel)
        })
        
        
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.loadingView.center = CGPoint(x: self.view.center.x, y: self.view.center.y+70)
        self.view.addSubview(self.loadingView)
        
        //self.logoIV.alpha = 0
        self.appNameLabel.alpha = 0
        self.logInfoLabel.alpha = 0
        self.poweredByLabel.alpha = 0
        self.pwrByContainer.alpha = 0
        
        self.logoIV.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 4.0,
            animations: {
                self.logoIV.transform = CGAffineTransform.identity
            },
            completion:{(Bool) in
                self.animateLogoText()
            }
        )

    }
    
    func animateLogoText(){
        UIView.animate(withDuration: 2, animations:{
            self.appNameLabel.alpha = 1
            }, completion:{(Bool) in
                self.animatePoweredByText()
        })
    }
    
    func animatePoweredByText(){
        UIView.animate(withDuration: 2, animations:{
            self.poweredByLabel.alpha = 1
            self.pwrByContainer.alpha = 1
            }, completion:{(Bool) in
                self.animateLogInfoText()
        })
    }
    
    func animateLogInfoText(){
        UIView.animate(withDuration: 2, animations:{
            self.logInfoLabel.alpha = 1
            }, completion:{(Bool) in
                self.getLoggedMemberInfo()
        })
    }
    
    //to get token detail
    func getTokenDetail() -> String{
        let preferences = UserDefaults.standard
        var token:String = ""
        let tokenKey = "token"
        if preferences.object(forKey: tokenKey) == nil {
            //  Doesn't exist
        } else {
            token = preferences.value(forKey: tokenKey) as! String
            //print(token)
        }
        return token
    }
    
    //to get logged member info
    func getLoggedMemberInfo(){
        if(NetworkReachability.isConnectedToNetwork()){
            let headers = [
                "Authorization": "Basic "+getTokenDetail(),
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            self.showLoading()
            Alamofire.request(Api.baseUrl + Api.loggedMemberInfo, method: .get, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success( _):
                        if let jsonString = response.result.value {
                            //print("JSON: \(jsonString)")
                            let jsonObj = JSON(jsonString)
                            let orgId = jsonObj["orgId"]
                            let memberId = jsonObj["memberId"]
                            let orgName = jsonObj["orgName"]
                            let accessGroupFlag = jsonObj["accessGroupFlag"]
                            //print("OrgId: \(orgId), MemberId: \(memberId), OrgName: \(orgName), AccessGroupFlag: \(accessGroupFlag)")
                            self.saveMemberDetails(orgId.stringValue, memberId: memberId.stringValue, orgName: orgName.stringValue, accessGroupFlag: accessGroupFlag.stringValue)
                            self.hideLoading()
                            self.navigateToDashBoardView()
                        }
                    case .failure(let error):
                        self.hideLoading()
                        print("message: Error 4xx / 5xx: \(error)")
                        self.navigateToLoginView()
                    }
                    
            }
        }else{
//            self.view.dodo.error("No Internet Connectivity!")
            let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
            snackbar.show()
        }
    }
    
    //to save member details
    func saveMemberDetails(_ orgId:String, memberId:String, orgName:String, accessGroupFlag:String){
        let preferences = UserDefaults.standard
        
        let orgIdKey = "orgId"
        let memberIdKey = "memberId"
        let orgNameKey = "orgName"
        let accessGroupFlagKey = "accessGroupFlag"
        
        preferences.setValue(orgId, forKey: orgIdKey)
        preferences.setValue(memberId, forKey: memberIdKey)
        preferences.setValue(orgName, forKey: orgNameKey)
        preferences.setValue(accessGroupFlag, forKey: accessGroupFlagKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save member details!")
        }
    }
    
    //to navigate loginviewcontroller
    func navigateToLoginView(){
        self.navigationController?.present(UINavigationController(rootViewController: LoginViewController()), animated: true, completion: nil)
    }
    
    //to navigate loginviewcontroller
    func navigateToDashBoardView(){
        self.navigationController?.present(UINavigationController(rootViewController: DashboardViewController()), animated: true, completion: nil)
    }
    
    //to show loading
    func showLoading(){
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
    }
    
    //to hide loading
    func hideLoading(){
        self.loadingView.stopAnimating()
        self.loadingView.isHidden = true
    }
    
    //for light statusbar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }


}

