//
//  teamrole.swift
//  LEEDOn
//
//  Created by Group X on 08/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class teamrole: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UINavigationControllerDelegate {
    @IBOutlet weak var picker: UIPickerView!
    var pickerarr = NSArray()
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var token = UserDefaults.standard.object(forKey: "token")
    var email = ""
    var currentrole = ""
    var currentID = ""
    var status = ""
    var rolesarr = NSArray()
    var refresh = 0
    @IBOutlet weak var spinner: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.spinner.layer.cornerRadius = 5
        
        self.navigationController?.delegate = self
        picker.dataSource = self
        picker.delegate = self
        var selectedindex = 0
        for i in 0..<rolesarr.count{
            let dict = rolesarr.object(at: i) as! NSDictionary
            if(currentrole == dict["Rtitl"] as! String){
                selectedindex = i
                break
            }
        }
        picker.selectRow(selectedindex, inComponent: 0, animated: true)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.navigationController?.navigationBar.backItem?.title = "Teams"
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    @IBAction func done(_ sender: AnyObject) {
        let row = picker.selectedRow(inComponent: 0)
        if(row == rolesarr.count){
            DispatchQueue.main.async(execute: {
                self.view.isUserInteractionEnabled = false
                self.spinner.isHidden = false
                self.delrole("", type:self.currentID)
            })
        }else{
        let dict = rolesarr.object(at: row) as! NSDictionary
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            self.saverole(dict["Rtitl"] as! String, type:dict["Reltyp"] as! String)
        })
        
        }
        
    }
    @IBAction func cancel(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rolesarr.count + 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(row == rolesarr.count){
            return "None"
        }
        let dict = rolesarr.object(at: row) as! NSDictionary
        return dict["Rtitl"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    
    func delrole(_ role:String, type:String){
        //
        let payload = NSMutableString()
        payload.append("{")
        payload.append("\"user_email\":\"\(email)\",")
        payload.append("\"Responsibility\":\"\(leedid)\",")
        payload.append("\"Reltyp\":\"\(type)\"")
        payload.append("}")
        let str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/update/",credentials().domain_url, leedid))
        ////print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "DELETE"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                    })
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        self.refresh = 0
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
                            self.view.isUserInteractionEnabled = true
                            self.spinner.isHidden = true
                        })
                        DispatchQueue.main.async(execute: {
                            
                            if let snapshotValue = jsonDictionary["error"] as? NSArray, let err = snapshotValue[0] as? NSDictionary, let message = err["message"] as? String {
                                self.showalert(message, title: "Error", action: "OK")
                            }
                            
                            
                            
                            
                        })
                        
                    } catch {
                        //print(error)
                    }
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        //self.maketoast("Role has been assigned successfuly")
                        DispatchQueue.main.async(execute: {
                            self.view.isUserInteractionEnabled = true
                            self.spinner.isHidden = true
                            self.refresh = 1
                            self.maketoast(jsonDictionary["result"] as! String, type: "message")
                            self.navigationController?.popViewController(animated: true)                            
                            //self.showalert("Role has been assigned successfully", title: "Success", action: "OK")
                        })
                        
                        
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
        
    }

    
    func saverole(_ role:String, type:String){
        //
        let payload = NSMutableString()
            payload.append("{")
                payload.append("\"user_email\":\"\(email)\",")
                payload.append("\"Reltyp\":\"\(type)\"")
            payload.append("}")
        let str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/update/",credentials().domain_url, leedid))
        ////print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = true
                    self.spinner.isHidden = true
                })
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    self.refresh = 0
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                    })
                    DispatchQueue.main.async(execute: {
                        
                        if let snapshotValue = jsonDictionary["error"] as? NSArray, let err = snapshotValue[0] as? NSDictionary, let message = err["message"] as? String {
                            self.showalert(message, title: "Error", action: "OK")
                        }
                        
                        
                        
                        
                    })
                    
                } catch {
                    //print(error)
                }
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    //self.maketoast("Role has been assigned successfuly")
                    DispatchQueue.main.async(execute: {
                            self.view.isUserInteractionEnabled = true
                            self.spinner.isHidden = true
                        self.refresh = 1
                        self.navigationController?.popViewController(animated: true)
                    //self.showalert("Role has been assigned successfully", title: "Success", action: "OK")
                    })
                    
                    
                } catch {
                    //print(error)
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
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        //self.navigationController?.delegate = nil
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is listofteams){
            let v = viewController as! listofteams
            v.refresh = refresh
            
        //self.navigationController?.delegate = nil
        }
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
