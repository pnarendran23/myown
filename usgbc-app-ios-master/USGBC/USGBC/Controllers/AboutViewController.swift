//
//  AboutViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController {
    
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initWebView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
        initViews()
        initWebView()
    }
    
    
    //To initialize navigationbar and other default views
    func initViews(){
        view.backgroundColor = UIColor.white
        title = "About Us"
    }
    
    //To inilitalize webview
    func initWebView() {
        webView.removeFromSuperview()
        webView.frame = view.frame
        webView.backgroundColor = UIColor.white
        do {
            guard let filePath = Bundle.main.path(forResource: "aboutTemplate", ofType: "html", inDirectory: "Web")
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
        webView.scalesPageToFit = true
        view.addSubview(webView)
    }
}

extension AboutViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
}
