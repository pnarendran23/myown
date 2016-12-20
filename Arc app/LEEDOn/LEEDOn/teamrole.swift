//
//  teamrole.swift
//  LEEDOn
//
//  Created by Group X on 08/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class teamrole: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    var pickerarr = NSArray()
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token")
    var email = ""
    var currentrole = ""
    var rolesarr = NSArray()
    
    @IBOutlet weak var spinner: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        var selectedindex = 0
        for i in 0..<rolesarr.count{
            let dict = rolesarr.objectAtIndex(i)
            if(currentrole == dict["Rtitl"] as! String){
                selectedindex = i
                break
            }
        }
        picker.selectRow(selectedindex, inComponent: 0, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBAction func done(sender: AnyObject) {
        let row = picker.selectedRowInComponent(0)
        let dict = rolesarr.objectAtIndex(row)
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = false
            self.spinner.hidden = false
        })
        saverole(dict["Rtitl"] as! String, type:dict["Reltyp"] as! String)
        
    }
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rolesarr.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dict = rolesarr.objectAtIndex(row)
        return dict["Rtitl"] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    
    
    
    func saverole(role:String, type:String){
        //
        let payload = NSMutableString()
            payload.appendString("{")
                payload.appendString("\"user_email\":\"\(email)\",")
                payload.appendString("\"Reltyp\":\"\(type)\"")
            payload.appendString("}")
        let str = payload as String
        print(str)
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/teams/update/",credentials().domain_url, leedid))
        print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.userInteractionEnabled = true
                    self.spinner.hidden = true
                })
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let a = self.navigationController!.viewControllers[0] as! team
                    a.refresh = 0
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = true
                        self.spinner.hidden = true
                    })
                    dispatch_async(dispatch_get_main_queue(), {
                    self.showalert(jsonDictionary["error"]!.objectAtIndex(0)["message"]!! as! String, title: "Error", action: "OK")
                    })
                    
                } catch {
                    print(error)
                }
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    print("Successfully updated")
                    let a = self.navigationController!.viewControllers[0] as! team
                    a.refresh = 1
                    dispatch_async(dispatch_get_main_queue(), {
                        
                            self.view.userInteractionEnabled = true
                            self.spinner.hidden = true
                        
                    self.showalert("Role has been assigned successfully", title: "Success", action: "OK")
                    })
                    
                    
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()

    }
    
    
    
    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController?.popViewControllerAnimated(true)
                
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
