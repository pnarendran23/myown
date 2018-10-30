//
//  showpdf.swift
//  Arcskoru
//
//  Created by Group X on 24/05/17.
//
//

import UIKit

class showpdf: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var paths = [String]()
        paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = paths[0] 
        let path = documentsDir + "/vv.pdf"
        let targetURL = URL(fileURLWithPath: path)
        let request = URLRequest.init(url: targetURL)
        //print("Target URL is ", targetURL)
        webview.loadRequest(request)
        
        // Do any additional setup after loading the view.
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
