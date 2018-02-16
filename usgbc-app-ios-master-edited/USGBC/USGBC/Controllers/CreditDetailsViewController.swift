//
//  CreditLibraryDetailsViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 04/07/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class CreditDetailsViewController: UIViewController{
    
    var creditId: String!
    var creditDetails: CreditDetails!
    var favoriteButton: UIButton!
    var shareButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    var isFavorite = false
    var favorite: Favorite!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initViews()
        loadCreditDetails()
    }
    
    //To initialize navigationbar and other default views
    func initViews(){
        favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        favoriteButton.setImage(UIImage(named: "star-empty"), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.addTarget(self, action: #selector(CreditDetailsViewController.handleFavorite(_:)), for: .touchUpInside)
        let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        
        shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.addTarget(self, action: #selector(CreditDetailsViewController.handleShare(_:)), for: .touchUpInside)
        let shareBarButton = UIBarButtonItem(customView: shareButton)
        
        navigationItem.rightBarButtonItems = [shareBarButton, favoriteBarButton]
        for item in self.navigationItem.rightBarButtonItems!{
            item.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            ApiManager.shared.stopAllSessions()
            Utility.hideLoading()
        }
    }
    
    @IBAction func handleFavorite(_ sender: UIButton){
        if(isFavorite){
            if(FavoriteManager.removeFromFavorite(name: creditDetails.title, id: creditId, category: "Credits")){
                sender.setImage(UIImage(named: "star-empty"), for: .normal)
                isFavorite = false
            }
        }else{
            if(FavoriteManager.addToFavorite(name: creditDetails.title, id: creditId, image: creditDetails.image, category: "Credits")){
                sender.setImage(UIImage(named: "star-filled"), for: .normal)
                isFavorite = true
            }
        }
    }
    
    @IBAction func handleShare(_ sender: Any) {
        let objectsToShare = [creditDetails.path]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.shareButton
        activityVC.popoverPresentationController?.sourceRect = self.shareButton.bounds
        present(activityVC, animated: true, completion: nil)
    }
    
    func loadCreditDetails(){
        Utility.showLoading()
        ApiManager.shared.getCreditDetails(id: creditId) { (creditDetails, error) in
            if(error == nil){
                Utility.hideLoading()
                self.creditDetails = creditDetails!
                self.initWebView()
                self.isFavorite = FavoriteManager.getFavoriteStatus(title: creditDetails!.title, favoriteButton: self.favoriteButton)
                for item in self.navigationItem.rightBarButtonItems!{
                    item.isEnabled = true
                }
            }else{
                var statuscode = error?._code as! Int
                if(statuscode != -999){
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong, try again later!")
                }else{
                for item in self.navigationItem.rightBarButtonItems!{
                    item.isEnabled = true
                }
                Utility.hideLoading()
                }
            }
        }
    }
    
    //To inilitalize webview
    func initWebView() {
        self.webView.delegate = self
        let (contents, baseUrl) = TemplateManager.shared.getTemplateContents(file: "creditTemplate")
        if(contents != nil && baseUrl != nil){
            webView.loadHTMLString(creditDetails.getHtmlContents(contents: contents!), baseURL: baseUrl)
        }
    }
}

extension CreditDetailsViewController: UIWebViewDelegate{
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
