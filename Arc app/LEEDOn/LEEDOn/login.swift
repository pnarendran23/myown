//
//  login.swift
//  MySampleApp
//
//  Created by Group X on 03/11/16.
//
//

import Foundation
import UIKit

class login: UIViewController  {
    @IBOutlet weak var usernametxtfield: UITextField!
    var domain_url = ""
    @IBOutlet weak var passwordtxtfield: UITextField!
    
    @IBAction func signin(sender: AnyObject) {
        var username = usernametxtfield.text
        var password = passwordtxtfield.text
        username = "testuser@gmail.com"
        password = "initpass"
        var credential = credentials()
        domain_url=credential.domain_url
         print("subscription key of LEEDOn ",credential.subscription_key)
        var url = NSURL.init(string: String(format: "%@auth/login/",domain_url))
        var request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(credential.subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var httpbody = String(format: "{\"username\":\"%@\",\"password\":\"%@\"}",username!,password!)
    request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        print("HEadre is ",httpbody)
        print(request.allHTTPHeaderFields)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("JSON data is",jsonDictionary)
                    if(jsonDictionary.valueForKey("token_type") as! String == "Bearer"){
                        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
                        NSUserDefaults.standardUserDefaults().setObject(jsonDictionary.valueForKey("authorization_token") as! String, forKey: "token")
                    }
                    self.getbuilding(jsonDictionary.valueForKey("authorization_token") as! String, subscription_key: credential.subscription_key, token_type: jsonDictionary.valueForKey("token_type") as! String)
                    
                    
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
        
    }
    
    override func viewDidLoad() {
        
       
    }
    
    func getbuilding(token:String,subscription_key:String,token_type:String){
        var url = NSURL.init(string: String(format: "%@assets/",domain_url))
        var request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "assetdata")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("JSON data is",jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("gotolist", sender: nil)
                    
                    })
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    
    
}
