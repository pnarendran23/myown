//
//  ResourceDetailsViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 03/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SafariServices

class ResourceDetailsViewController: UIViewController {

    var shareButton: UIButton!
    var favoriteButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    var isFavorite = false
    var resourceID: String!
    var resource: ResourceDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getResourceDetails(id: resourceID)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    func initViews(){
        title = "Resources"
        favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        favoriteButton.setImage(UIImage(named: "star-empty"), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.addTarget(self, action: #selector(ResourceDetailsViewController.handleFavorite(_:)), for: .touchUpInside)
        let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.addTarget(self, action: #selector(ResourceDetailsViewController.handleShare(_:)), for: .touchUpInside)
        let shareBarButton = UIBarButtonItem(customView: shareButton)
        
        navigationItem.rightBarButtonItems = [shareBarButton, favoriteBarButton]
        webView.delegate = self
        for item in self.navigationItem.rightBarButtonItems!{
            item.isEnabled = false
        }
    }
    
    func initWebView() {
        let (contents, baseUrl) = TemplateManager.shared.getTemplateContents(file: "resourceTemplate")
        if(contents != nil && baseUrl != nil){
            webView.loadHTMLString(resource.getHtmlContents(contents: contents!), baseURL: baseUrl)
        }
    }
    
    func getResourceDetails (id: String){
        Utility.showLoading()
        ApiManager.shared.getResourceDetailsfromelastic(id: id) { (resource, error) in
            if(error == nil){
                Utility.hideLoading()
                self.resource = resource!
                self.initWebView()
                self.isFavorite = FavoriteManager.getFavoriteStatus(title: resource!.title, favoriteButton: self.favoriteButton)
            }else{
                Utility.hideLoading()
            }
        }
    }
    
    @IBAction func handleFavorite(_ sender: UIButton){
        if(isFavorite){
            if(FavoriteManager.removeFromFavorite(name: resource.title, id: resourceID, category: "Resources")){
                sender.setImage(UIImage(named: "star-empty"), for: .normal)
                isFavorite = false
            }
        }else{
            if(FavoriteManager.addToFavorite(name: resource.title, id: resourceID, image: resource.image, category: "Resources")){
                sender.setImage(UIImage(named: "star-filled"), for: .normal)
                isFavorite = true
            }
        }
    }
    
    @IBAction func handleShare(_ sender: Any) {
        let objectsToShare = [resource.path]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.shareButton
        activityVC.popoverPresentationController?.sourceRect = self.shareButton.bounds
        present(activityVC, animated: true, completion: nil)
    }
}

extension ResourceDetailsViewController: UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
                if request.url?.scheme == "usgbc" {
                    let svc = SFSafariViewController(url: URL(string:resource.file_path)!)
                    present(svc, animated: true, completion: nil)
                }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        for item in self.navigationItem.rightBarButtonItems!{
            item.isEnabled = true
        }
    }
}
