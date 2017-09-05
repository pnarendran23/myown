//
//  agreement.swift
//  Arcskoru
//
//  Created by Group X on 07/03/17.
//
//

import UIKit

class agreement: UIViewController, UIDocumentInteractionControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //wview.loadRequest(NSURLRequest.init(URL: NSURL.init(string: "https://dev.app.arconline.io/assets/pdf/registration_agreement.pdf")!))

        
        // Do any additional setup after loading the view.
    }
    
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBOutlet weak var wview: UIWebView!

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
