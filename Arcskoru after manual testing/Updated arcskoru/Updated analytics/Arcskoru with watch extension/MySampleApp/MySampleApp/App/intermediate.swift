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
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.refreshtoken), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }
    
    func refreshtoken(){
        let url = URL.init(string: String(format: "%@auth/login/",credentials().domain_url))
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        let httpbody = String(format: "{\"username\":\"%@\",\"password\":\"%@\"}",UserDefaults.standard.object(forKey: "username") as! String,UserDefaults.standard.object(forKey: "password") as! String)
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
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "gotologin"), object: nil, userInfo:nil)
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "gotologin"), object: nil, userInfo:nil)
                    self.showalert("Invalid credentials", title: "Please check the credentials entered", action: "OK")
                })
            }else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "gotologin"), object: nil, userInfo:nil)
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("JSON data is",jsonDictionary)
                    
                    DispatchQueue.main.async(execute: {
                    if(jsonDictionary.value(forKey: "token_type") as! String == "Bearer"){
                        UserDefaults.standard.set(jsonDictionary.value(forKey: "authorization_token") as! String, forKey: "token")
                    }
                    self.goback()
                    // Dismiss here
                    })
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "gotologin"), object: nil, userInfo:nil)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }
            }
            
        }) 
        task.resume()

    }
    
    
    
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true            
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            self.goback()
            // self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
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
