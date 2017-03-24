//
//  beforeanalytics.swift
//  Arcskoru
//
//  Created by Group X on 17/01/17.
//
//

import UIKit

class intermediate: UIViewController {

    func goback(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(self.refreshtoken), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }
    
    func refreshtoken(){
        let url = NSURL.init(string: String(format: "%@auth/login/",credentials().domain_url))
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        let httpbody = String(format: "{\"username\":\"%@\",\"password\":\"%@\"}",NSUserDefaults.standardUserDefaults().objectForKey("username") as! String,NSUserDefaults.standardUserDefaults().objectForKey("password") as! String)
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
                    if(jsonDictionary.valueForKey("token_type") as! String == "Bearer"){
                        NSUserDefaults.standardUserDefaults().setObject(jsonDictionary.valueForKey("authorization_token") as! String, forKey: "token")
                    }
                    self.goback()
                    // Dismiss here
                    
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
    
    
    
    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.view.userInteractionEnabled = true
                //self.navigationController?.popViewControllerAnimated(true)
                // Dismiss here
                self.goback()
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
