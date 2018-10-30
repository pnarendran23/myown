//
//  mediate.swift
//  LEEDOn
//
//  Created by Group X on 19/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class mediate: UIViewController {
var width = CGFloat(0)
var height = CGFloat(0)
    var tempview = UIView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
self.titlefont()
        
        
        // Do any additional setup after loading the view.
    }

    func closeit(){
        showalert("Device in offline. Please try again later", title: "Unable to validate credentials", action: "OK")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                exit(0)
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
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
