//
//  login.swift
//  MySampleApp
//
//  Created by Group X on 03/11/16.
//
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class login: UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate  {
    @IBOutlet weak var usernametxtfield: UITextField!
    var domain_url = ""
    @IBOutlet weak var passwordtxtfield: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var loginbtn: UIButton!
    var secured = true
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! logincell
        if(indexPath.row == 0){
            cell.txtfield.isSecureTextEntry = false
            cell.txtfield.placeholder = "Enter username"
            cell.txtfield.tag = 1
            cell.btn.isHidden = true
        }else{
            cell.btn.isHidden = false
            cell.btn.addTarget(self, action: #selector(self.viewswitch(_:)), for: UIControlEvents.touchUpInside)
            cell.txtfield.placeholder = "Enter password"
            if(secured == true){
            cell.btn.setBackgroundImage(UIImage.init(named: "eye"), for: UIControlState.normal)
            cell.txtfield.isSecureTextEntry = true
            }else{
            cell.txtfield.isSecureTextEntry = false
            cell.btn.setBackgroundImage(UIImage.init(named: "noteye"), for: UIControlState.normal)
            }
            cell.txtfield.tag = 2
        }
        
        return cell
    }
    
    
    func viewswitch(_ sender: UIButton){
        secured = !secured
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        secured = !secured
        tableView.reloadData()
    }
    
    @IBAction func signin(_ sender: AnyObject) {
        
        let textfield1 = self.view.viewWithTag(1) as! UITextField
        let textfield2 = self.view.viewWithTag(2) as! UITextField        
        textfield1.resignFirstResponder()
        textfield2.resignFirstResponder()
        if(textfield1.text?.characters.count == 0){
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: textfield1.center.x - 10, y: textfield1.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: textfield1.center.x + 10, y: textfield1.center.y))
            textfield1.layer.add(animation, forKey: "position")
        }
        
        if(textfield2.text?.characters.count == 0){
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: textfield2.center.x - 10, y: textfield2.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: textfield2.center.x + 10, y: textfield2.center.y))
            textfield2.layer.add(animation, forKey: "position")
            
            
           /* let coloranimation = CABasicAnimation(keyPath: "backgroundColor")
            coloranimation.duration = 2.07
            coloranimation.repeatCount = 0
            coloranimation.fromValue = UIColor.redColor().CGColor
            coloranimation.toValue = UIColor.clearColor().CGColor
            textfield2.layer.addAnimation(coloranimation, forKey: "backgroundColor")
            */
                        
        }
        
        if(textfield2.text?.characters.count > 0 && textfield1.text?.characters.count > 0){
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            self.loginbtn.setTitle("Signing in...", for: UIControlState())
        })
        
        let username = textfield1.text
        let password = textfield2.text        
        let credential = credentials()
        domain_url=credential.domain_url
         //print("subscription key of LEEDOn ",credential.subscription_key)
        let url = URL.init(string: String(format: "%@auth/login/",domain_url))
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(credential.subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        let httpbody = String(format: "{\"username\":\"%@\",\"password\":\"%@\"}",username!,password!)
    request.httpBody = httpbody.data(using: String.Encoding.utf8)
        //print("HEadre is ",httpbody)
        //print(request.allHTTPHeaderFields)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 400 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("JSON data is",jsonDictionary)
                    DispatchQueue.main.async(execute: {
                    if(jsonDictionary.value(forKey: "token_type") as! String == "Bearer"){
                        if let snapshotValue = jsonDictionary["user"] as? NSDictionary, let firstname = snapshotValue["first_name"] as? String, let lastname = snapshotValue["last_name"] as? String {
                            var str = ""
                            if(lastname as! String == ""){
                        str = "\(firstname as! String)\(lastname as! String)" as! String
                            }else{
                                str = "\(firstname as! String) \(lastname as! String)" as! String
                            }
                        UserDefaults.standard.set(str, forKey: "currentuser")
                        }
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.set(jsonDictionary.value(forKey: "authorization_token") as! String, forKey: "token")
                    }
                    //self.getportfolio(jsonDictionary.valueForKey("authorization_token") as! String, subscription_key: credential.subscription_key, token_type: jsonDictionary.valueForKey("token_type") as! String)
                        self.getbuilding(jsonDictionary.value(forKey: "authorization_token") as! String, subscription_key: credentials().subscription_key, token_type: jsonDictionary.value(forKey: "token_type") as! String)
                    })
                    
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }
            }
            
        }) 
        task.resume()
        }
        
        
    }
    
    
    func showalert(_ message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            DispatchQueue.main.async(execute: {
                self.view.isUserInteractionEnabled = true
                self.spinner.isHidden = true
                self.loginbtn.setTitle("Sign in", for: UIControlState())
                //self.navigationController?.popViewControllerAnimated(true)
                
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        present(alertController, animated: true, completion: nil)
        
        
    }

    @IBOutlet weak var panelview: UIView!
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationItem.title = "Login"
        
        //self.navigationController?.delegate = nil
        self.usernametxtfield.text = ""
        self.passwordtxtfield.text = ""
        (self.view.viewWithTag(1) as! UITextField).text = ""
        (self.view.viewWithTag(2) as! UITextField).text = ""
        self.tableview.reloadData()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is login){
        self.navigationItem.title = "Login"
            (self.view.viewWithTag(1) as! UITextField).text = ""
            (self.view.viewWithTag(2) as! UITextField).text = ""
            self.tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.titlefont()
        self.loginbtn.layer.cornerRadius = 5        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            
            //self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            //self.view.backgroundColor = UIColor.blackColor()
        }
        self.view.backgroundColor = UIColor.white
        self.tableview.register(UINib.init(nibName: "logincell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.loginbtn.frame = CGRect(x: self.loginbtn.frame.origin.x, y: self.loginbtn.frame.origin.y, width: self.loginbtn.frame.size.width, height: self.tableview.frame.size.height/2 )
        self.view.bringSubview(toFront: self.panelview)
        self.view.bringSubview(toFront: self.usernametxtfield)
        self.view.bringSubview(toFront: self.passwordtxtfield)
        self.view.bringSubview(toFront: self.loginbtn)
        self.view.bringSubview(toFront: self.img)
        self.view.bringSubview(toFront: self.spinner)        
        self.tableview.layer.borderColor = self.tableview.separatorColor?.cgColor
        self.tableview.layer.borderWidth =  1.0
        self.panelview.layer.cornerRadius = 10
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override var shouldAutorotate : Bool {
        // 3. Lock autorotate
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
    
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        
        // 4. Only allow Landscape
        return UIInterfaceOrientation.portrait
    }
    
    // 5. Restoring the locked-rotation before controller disappeared
    override func viewWillDisappear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableview.frame.size.height/2
    }
        //https://api.usgbc.org/dev/leed/portfolios/?page=1

    func getportfolio(_ token:String,subscription_key:String,token_type:String){
        let url = URL.init(string: String(format: "%@portfolios/?page=1",domain_url))
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 400 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                    UserDefaults.standard.set(datakeyed, forKey: "portfolios")
                    UserDefaults.standard.synchronize()
                    //print("JSON data is",jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        UserDefaults.standard.set(0, forKey: "grid")
                        self.getbuilding(token, subscription_key: subscription_key, token_type: token_type)
                    })
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }
            }
            
        }) 
        task.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Login"
        self.usernametxtfield.text = ""
        self.passwordtxtfield.text = ""
    }
    func getbuilding(_ token:String,subscription_key:String,token_type:String){
        let url = URL.init(string: String(format: "%@assets/?page_size=30&page=1",domain_url))
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 400 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                    UserDefaults.standard.set(datakeyed, forKey: "assetdata")
                    UserDefaults.standard.synchronize()
                    //print("JSON data is",jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                        self.loginbtn.setTitle("Sign in", for: UIControlState())
                    })
                    DispatchQueue.main.async(execute: {
                        if(UserDefaults.standard.object(forKey: "searchtext") != nil){
                        UserDefaults.standard.removeObject(forKey:"searchtext")
                        }
                        UserDefaults.standard.set(0, forKey: "grid")
                        if(UserDefaults.standard.integer(forKey: "grid") == 0){
                        //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"instructionscontent"])
                            
                            if(UserDefaults.standard.integer(forKey: "noinstructions") == 1){
                            self.performSegue(withIdentifier: "gotolist", sender: nil)
                            }else{
                            self.performSegue(withIdentifier: "gotoinstructions", sender: nil)
                            }
                        }else{
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"gridview"])
                        }
                    })
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }
            }
            
        }) 
        task.resume()
    }
    
    
}


extension UITableView{
    func vibrate(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 2.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 2.0, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}


