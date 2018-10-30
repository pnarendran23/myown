//
//  CredentialingDetailsViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 21/06/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SafariServices

class CredentialingDetailsViewController: UIViewController, UIWebViewDelegate {
    
    var resource: Resource!
    var webView = UIWebView()
    let fileUrl = "https://in.usgbc.org/sites/default/files/leed-om-transit.pdf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initWebView()
    }
    
    //To initialize navigationbar and other default views
    func initViews(){
        view.backgroundColor = UIColor.white
        title = "Credentialing"
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.scheme == "usgbc" {
            let svc = SFSafariViewController(url: URL(string:fileUrl)!)
            present(svc, animated: true, completion: nil)
        }
        return true
    }
    
    //To inilitalize webview
    func initWebView() {
        webView.frame = view.frame
        webView.backgroundColor = UIColor.white
        webView.delegate = self
        do {
            guard let filePath = Bundle.main.path(forResource: "credentialingTemplate", ofType: "html", inDirectory: "Web")
                else {
                    // File Error
                    print ("File reading error")
                    return
            }
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }
        view.addSubview(webView)
    }
    
}
