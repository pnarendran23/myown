//
//  login.swift
//  MySampleApp
//
//  Created by Group X on 03/11/16.
//
//

import Foundation
import UIKit

class login: UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate  {
    @IBOutlet weak var usernametxtfield: UITextField!
    var domain_url = ""
    @IBOutlet weak var passwordtxtfield: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var loginbtn: UIButton!
    var secured = true
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! logincell
        if(indexPath.row == 0){
            cell.txtfield.secureTextEntry = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.txtfield.placeholder = "Enter username"
            cell.txtfield.tag = 1
        }else{
            cell.txtfield.placeholder = "Enter password"
            if(secured == true){
            cell.txtfield.secureTextEntry = true
            }else{
            cell.txtfield.secureTextEntry = false
            }
            cell.txtfield.tag = 2
            cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        secured = !secured
        tableView.reloadData()
    }
    
    @IBAction func signin(sender: AnyObject) {
        
        let textfield1 = self.view.viewWithTag(1) as! UITextField
        let textfield2 = self.view.viewWithTag(2) as! UITextField        
        textfield1.resignFirstResponder()
        textfield2.resignFirstResponder()
        if(textfield1.text?.characters.count == 0){
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(CGPoint: CGPointMake(textfield1.center.x - 10, textfield1.center.y))
            animation.toValue = NSValue(CGPoint: CGPointMake(textfield1.center.x + 10, textfield1.center.y))
            textfield1.layer.addAnimation(animation, forKey: "position")
        }
        
        if(textfield2.text?.characters.count == 0){
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(CGPoint: CGPointMake(textfield2.center.x - 10, textfield2.center.y))
            animation.toValue = NSValue(CGPoint: CGPointMake(textfield2.center.x + 10, textfield2.center.y))
            textfield2.layer.addAnimation(animation, forKey: "position")
            
            
           /* let coloranimation = CABasicAnimation(keyPath: "backgroundColor")
            coloranimation.duration = 2.07
            coloranimation.repeatCount = 0
            coloranimation.fromValue = UIColor.redColor().CGColor
            coloranimation.toValue = UIColor.clearColor().CGColor
            textfield2.layer.addAnimation(coloranimation, forKey: "backgroundColor")
            */
                        
        }
        
        if(textfield2.text?.characters.count > 0 && textfield1.text?.characters.count > 0){
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = false
            self.spinner.hidden = false
            self.loginbtn.setTitle("Signing in...", forState: UIControlState.Normal)
        })
        
        let username = textfield1.text
        let password = textfield2.text        
        let credential = credentials()
        domain_url=credential.domain_url
         print("subscription key of LEEDOn ",credential.subscription_key)
        let url = NSURL.init(string: String(format: "%@auth/login/",domain_url))
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(credential.subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        let httpbody = String(format: "{\"username\":\"%@\",\"password\":\"%@\"}",username!,password!)
    request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        print("HEadre is ",httpbody)
        print(request.allHTTPHeaderFields)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 400 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("JSON data is",jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                    if(jsonDictionary.valueForKey("token_type") as! String == "Bearer"){
                        if(jsonDictionary["user"] != nil){
                        var str = "\(jsonDictionary["user"]!["first_name"] as! String)\(jsonDictionary["user"]!["last_name"] as! String)" as! String
                        NSUserDefaults.standardUserDefaults().setObject(str, forKey: "currentuser")
                        }
                        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
                        NSUserDefaults.standardUserDefaults().setObject(jsonDictionary.valueForKey("authorization_token") as! String, forKey: "token")
                    }
                    //self.getportfolio(jsonDictionary.valueForKey("authorization_token") as! String, subscription_key: credential.subscription_key, token_type: jsonDictionary.valueForKey("token_type") as! String)
                        self.getbuilding(jsonDictionary.valueForKey("authorization_token") as! String, subscription_key: credentials().subscription_key, token_type: jsonDictionary.valueForKey("token_type") as! String)
                    })
                    
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }
            }
            
        }
        task.resume()
        }
        
        
    }
    
    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.view.userInteractionEnabled = true
                self.spinner.hidden = true
                self.loginbtn.setTitle("Sign in", forState: UIControlState.Normal)
                //self.navigationController?.popViewControllerAnimated(true)
                
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    @IBOutlet weak var panelview: UIView!
    
    override func viewDidLoad() {
        self.titlefont()
        self.loginbtn.layer.cornerRadius = 5        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            
            //self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            //self.view.backgroundColor = UIColor.blackColor()
        }
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableview.registerNib(UINib.init(nibName: "logincell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.loginbtn.frame = CGRect(x: self.loginbtn.frame.origin.x, y: self.loginbtn.frame.origin.y, width: self.loginbtn.frame.size.width, height: self.tableview.frame.size.height/2 )
        self.view.bringSubviewToFront(self.panelview)
        self.view.bringSubviewToFront(self.usernametxtfield)
        self.view.bringSubviewToFront(self.passwordtxtfield)
        self.view.bringSubviewToFront(self.loginbtn)
        self.view.bringSubviewToFront(self.img)
        self.view.bringSubviewToFront(self.spinner)        
        self.tableview.layer.borderColor = self.tableview.separatorColor?.CGColor
        self.tableview.layer.borderWidth =  1.0
        self.panelview.layer.cornerRadius = 10
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    override func shouldAutorotate() -> Bool {
        // 3. Lock autorotate
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }
    
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        
        // 4. Only allow Landscape
        return UIInterfaceOrientation.Portrait
    }
    
    // 5. Restoring the locked-rotation before controller disappeared
    override func viewWillDisappear(animated: Bool) {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldRotate = true
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableview.frame.size.height/2
    }
        //https://api.usgbc.org/dev/leed/portfolios/?page=1

    func getportfolio(token:String,subscription_key:String,token_type:String){
        let url = NSURL.init(string: String(format: "%@portfolios/?page=1",domain_url))
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 400 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "portfolios")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("JSON data is",jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "grid")
                        self.getbuilding(token, subscription_key: subscription_key, token_type: token_type)
                    })
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }
            }
            
        }
        task.resume()
    }
    
    
    func getbuilding(token:String,subscription_key:String,token_type:String){
        let url = NSURL.init(string: String(format: "%@assets/?page_size=30&page=1",domain_url))
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 400 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "assetdata")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("JSON data is",jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = true
                        self.spinner.hidden = true
                        self.loginbtn.setTitle("Sign in", forState: UIControlState.Normal)
                    })
                    dispatch_async(dispatch_get_main_queue(), {
                        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "grid")
                        if(NSUserDefaults.standardUserDefaults().integerForKey("grid") == 0){
                        //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"instructionscontent"])
                            
                            if(NSUserDefaults.standardUserDefaults().integerForKey("noinstructions") == 1){
                            self.performSegueWithIdentifier("gotolist", sender: nil)
                            }else{
                            self.performSegueWithIdentifier("gotoinstructions", sender: nil)
                            }
                        }else{
                        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"gridview"])
                        }
                    })
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }
            }
            
        }
        task.resume()
    }
    
    
}


extension UITableView{
    func vibrate(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x - 2.0, self.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(self.center.x + 2.0, self.center.y))
        self.layer.addAnimation(animation, forKey: "position")
    }
}


