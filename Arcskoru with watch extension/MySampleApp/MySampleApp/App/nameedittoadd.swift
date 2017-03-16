//

//  nameedit.swift
//  Arcskoru
//
//  Created by Group X on 07/02/17.
//
//

import UIKit
class nameedittoadd: UIViewController, UITextFieldDelegate, UITabBarDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var txtfld: UITextField!
    var name = ""
    var download_requests = [NSURLSession]()
    var currenttitle = ""
    var data_dict = NSMutableDictionary()
    var leedid = ""
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        txtfld.text = name
        context.text = currenttitle        
        self.spinner.hidden = true
        self.spinner.layer.cornerRadius = 5        
        txtfld.delegate = self
        self.tabbar.hidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.delegate = self
        txtfld.becomeFirstResponder()
        
    }
    
    
    
    
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var context: UILabel!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dispatch_async(dispatch_get_main_queue(), {
            self.name = textField.text!
            if(self.currenttitle == "Name"){
                self.data_dict["name"] = self.name
            }else if(self.currenttitle == "Project ID"){
                self.data_dict["leed_id"] = self.name
            }else if(self.currenttitle == "Gross floor area(square foot)"){
                self.data_dict["gross_area"] = self.name
            }else if(self.currenttitle == "Occupancy"){
                self.data_dict["occupancy"] = self.name
            }else if(self.currenttitle == "Address"){
                self.data_dict["street"] = self.name
            }else if(self.currenttitle == "City"){
                self.data_dict["city"] = self.name
            }else if(self.currenttitle == "State"){
                self.data_dict["state"] = self.name
            }else if(self.currenttitle == "Country"){
                self.data_dict["country"] = self.name
            }else if(self.currenttitle == "Owner type"){
                self.data_dict["ownerType"] = self.name
            }else if(self.currenttitle == "Owner organization"){
                self.data_dict["organization"] = self.name
            }else if(self.currenttitle == "Owner Email"){
                self.data_dict["owner_email"] = self.name
            }else if(self.currenttitle == "Owner country"){
                self.data_dict["country"] = self.name
            }else if(self.currenttitle == "Operating hours"){
                self.data_dict["operating_hours"] = self.name
            }
            
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
            self.navigationController?.popViewControllerAnimated(true)
            //self.saveproject(0)
            
        })
        return true
    }
    
    
  
    
    override func viewDidDisappear(animated: Bool) {
        navigationController?.delegate = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        txtfld.resignFirstResponder()
    }
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(context.text == "Name" || context.text == "Address" || context.text == "City" || context.text == "State" || context.text == "Country" || context.text == "Owner type" || context.text == "Owner organization" || context.text == "Owner Email" || context.text == "Owner country"){
            return true
        }
        let aSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
        let numberFiltered = compSepByCharInSet.joinWithSeparator("")
        if(string != numberFiltered){
            shakeit()
        }
        return string == numberFiltered
        
    }
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Score"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"totalanalysis"])
        }else if(item.title == "Manage"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"manage"])
        }else if(item.title == "More"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"listofactions"])
        }
        
    }
    
    func shakeit(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(txtfld.center.x - 10, txtfld.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(txtfld.center.x + 10, txtfld.center.y))
        txtfld.layer.addAnimation(animation, forKey: "position")
    }
    
    @IBAction func saveproject(selected: Int) {
        //{"name":"Test Auth","street":"2101 L Street NW","city":"Test city","state":"DC","country":"US","year_constructed":null,"gross_area":10000,"operating_hours":null,"occupancy":null,"confidential":false,"organization":null,"ownerType":null,"IsLovRecert":false,"PrevCertProdId":null,"OtherCertProg":null,"IsResidential":false,"noOfResUnits":null,"AffiliatedHigherEduIns":false,"nameOfSchool":null,"noOfFloors":null,"intentToPrecertify":false,"targetCertDate":null,"populationDayTime":null,"populationNightTime":null,"manageEntityName":null,"manageEntityAdd1":null,"managEntityAdd2":null,"manageEntityCity":null,"manageEntityState":null,"manageEntityCountry":null,"unitType":"IP"}
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        
        print(data_dict)
        var payload = NSMutableString()
        payload.appendString("{")
        
        
        for (key, value) in data_dict {
            if(value is String){
                payload.appendString("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
                payload.appendString("\"\(key)\": \(value),")
            }
        }
        var str = payload as! String
        payload.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
        payload.appendString("}")
        str = payload as! String
        print(str)
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, leedid))
        print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = str
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        var task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.updateproject()
                        })
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
    }
    
    
    func updateproject(){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        var task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                            
                        })
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
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
                self.spinner.hidden = true
                self.view.userInteractionEnabled = true
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? addnewproject {
            controller.data_dict = data_dict    // Here you pass the data back to your original view controller
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
