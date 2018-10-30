//
//  Group10VC.swift
//  Placer For Schools
//
//  Created by Group10 on 11/17/15.
//  Copyright © 2015 Group10. All rights reserved.
//

import UIKit
import MessageUI

class Group10VC: UIViewController ,MFMailComposeViewControllerDelegate{

//    @IBOutlet var GtenText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @IBAction func btnEmailUsAction(_ sender: Any) {
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    @IBOutlet weak var btnEmailUs: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = "ContactUs"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["school@groupten.com"])
        mailComposerVC.setSubject("AlertApp")
        mailComposerVC.setMessageBody("Dear Group10,          \n 1.Phone : \(Utility().getPhone()) \n 2.Macid : \(Utility.getMacAddress()) \n 3.AppVersion : \(Utility.getAppVersion()) \n 4.OsType : \(Utility.getModel())", isHTML: false)
        
        return mailComposerVC
    }
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
