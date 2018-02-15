//
//  EducationDetailsViewController.swift
//  USGBC
//
//  Created by Vishal on 27/04/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class CourseDetailsViewController: UIViewController{
    
    var courseId: String!
    var courseDetails: CourseDetails!
    let helper = Utility()
    var userDidLogin = false
    var onScreen = true
    
    var favoriteButton: UIButton!
    var shareButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    let sb = UIStoryboard(name: "Dashboard", bundle: nil)
    var isFavorite = false
    var access = false
    var (contents, baseUrl) = TemplateManager.shared.getTemplateContents(file: "courseTemplate")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        loadCourseAccess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(helper.getTokenDetail() != ""){
            userDidLogin = true
        }
        initViews()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            // Bounce back to the main thread to update the UI
                self.onScreen = false
                ApiManager.shared.stopAllSessions()
                Utility.hideLoading()
        
    }
    
    //To initialize navigationbar and other default views
    func initViews(){
        if(!userDidLogin){
            favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            favoriteButton.setImage(UIImage(named: "star-empty"), for: .normal)
            favoriteButton.imageView?.contentMode = .scaleAspectFit
            favoriteButton.addTarget(self, action: #selector(CourseDetailsViewController.handleFavorite(_:)), for: .touchUpInside)
            let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
            
            let loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            loginButton.setImage(UIImage(named: "login"), for: .normal)
            loginButton.imageView?.contentMode = .scaleAspectFit
            loginButton.addTarget(self, action: #selector(CourseDetailsViewController.handleLogin(_:)), for: .touchUpInside)
            let loginBarButton = UIBarButtonItem(customView: loginButton)
            
            shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
            shareButton.setImage(UIImage(named: "share"), for: .normal)
            shareButton.imageView?.contentMode = .scaleAspectFit
            shareButton.addTarget(self, action: #selector(CourseDetailsViewController.handleShare(_:)), for: .touchUpInside)
            let shareBarButton = UIBarButtonItem(customView: shareButton)
            
            navigationItem.rightBarButtonItems = [shareBarButton, favoriteBarButton, loginBarButton]
        }else{
            favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            favoriteButton.setImage(UIImage(named: "star-empty"), for: .normal)
            favoriteButton.imageView?.contentMode = .scaleAspectFit
            favoriteButton.addTarget(self, action: #selector(CourseDetailsViewController.handleFavorite(_:)), for: .touchUpInside)
            let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
            
            shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
            shareButton.setImage(UIImage(named: "share"), for: .normal)
            shareButton.imageView?.contentMode = .scaleAspectFit
            shareButton.addTarget(self, action: #selector(CourseDetailsViewController.handleShare(_:)), for: .touchUpInside)
            let shareBarButton = UIBarButtonItem(customView: shareButton)
            
            navigationItem.rightBarButtonItems = [shareBarButton, favoriteBarButton]
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        webView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.bounds = CGRect(x: 0, y: 50, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        refreshControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
        refreshControl.addTarget(self, action: #selector(CourseDetailsViewController.handleRefresh(_:)), for: .valueChanged)
        webView.scrollView.addSubview(refreshControl)
    }
    
    func handleRefresh(_ sender: UIRefreshControl){
        print("Course refresh")
        sender.endRefreshing()
    }
    
    func handleShare(_ sender: Any){
        let objectsToShare = [courseDetails.path]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.shareButton
        activityVC.popoverPresentationController?.sourceRect = self.shareButton.bounds
        present(activityVC, animated: true, completion: nil)
    }
    
    func handleLogin(_ sender: Any){
        let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.delegate = self
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func handleFavorite(_ sender: UIButton){
        if(isFavorite){
            if(FavoriteManager.removeFromFavorite(name: courseDetails.title, id: courseId, category: "Courses")){
                sender.setImage(UIImage(named: "star-empty"), for: .normal)
                isFavorite = false
            }
        }else{
            if(FavoriteManager.addToFavorite(name: courseDetails.title, id: courseId, image: courseDetails.image, category: "Courses")){
                sender.setImage(UIImage(named: "star-filled"), for: .normal)
                isFavorite = true
            }
        }
    }
    
    //To load JSON from file
    func loadCourseDetails(){
        
        ApiManager.shared.getCourseDetails(id: courseId, callback: { (courseDetails, error) in
            if(error == nil){
                Utility.hideLoading()
                self.courseDetails = courseDetails!
                self.courseDetails.access = self.access
                self.initCourseDetails()
                self.isFavorite = FavoriteManager.getFavoriteStatus(title: courseDetails!.title, favoriteButton: self.favoriteButton)
                self.loadCourseResources()
                self.loadCourseLeaders()
                self.loadCourseSessions()
                self.loadCourseProviders()
            }else{
                var statuscode = error?._code as! Int
                if(statuscode != -999){
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong, try again later!")
                }
            }
        })
    }
    
    //To load JSON from file
    func loadCourseLeaders(){
        if(onScreen){
            
            ApiManager.shared.getCourseLeaders(id: courseId, callback: { (courseLeaders, error) in
                if(error == nil){
                    
                    self.courseDetails.leaders = courseLeaders!
                    self.initCourseLeaders()
                }else{
                    
                    var statuscode = error?._code as! Int
                    if(statuscode != -999){
                        Utility.hideLoading()
                        Utility.showToast(message: "Something went wrong, try again later!")
                    }
                }
            })
        }
    }
    
    //To load JSON from file
    func loadCourseResources(){
        if(onScreen){
            
            ApiManager.shared.getCourseResources(id: courseId, callback: { (resources, error) in
                if(error == nil){
                    
                    self.courseDetails.resources = resources!
                    self.initCourseResources()
                }else{
                    
                    var statuscode = error?._code as! Int
                    if(statuscode != -999){
                        Utility.hideLoading()
                        Utility.showToast(message: "Something went wrong, try again later!")
                    }
                }
            })
        }
    }
    
    //To load JSON from file
    func loadCourseProviders(){
        if(onScreen){
            
            ApiManager.shared.getCourseProviders(id: courseId, callback: { (providers, error) in
                if(error == nil){
                    
                    self.courseDetails.providers = providers!
                    self.initCourseProviders()
                }else{
                    
                    var statuscode = error?._code as! Int
                    if(statuscode != -999){
                        Utility.hideLoading()
                        Utility.showToast(message: "Something went wrong, try again later!")
                    }
                }
            })
        }
    }
    
    func loadCourseSessions(){
        if(onScreen){
            
            ApiManager.shared.getCourseSessions(id: courseId, callback: { (sessions, error) in
                if(error == nil){
                    
                    self.courseDetails.sessions = sessions!
                    self.initCourseSessions()
                }else{
                    
                    var statuscode = error?._code as! Int
                    if(statuscode != -999){
                        Utility.hideLoading()
                        Utility.showToast(message: "Something went wrong, try again later!")
                    }
                }
            })
        }
    }
    
    func loadCourseAccess(){
        if(onScreen){
            
            ApiManager.shared.getCourseAcces(id: courseId, email: Utility().getUserDetail(), callback: { (access, error) in
                if(error == nil){
                    
                    //self.courseDetails.access = access!
                    self.access = access!
                    self.loadCourseDetails()
                }else {
                    var statuscode = error?._code as! Int
                    if(statuscode != -999){
                        Utility.hideLoading()
                        Utility.showToast(message: "Something went wrong, try again later!")
                    }
                }
            })
        }
    }
    
    func initCourseDetails(){
        if(contents != nil && baseUrl != nil){
            contents = courseDetails.getCourseDetailsHtmlContents(contents: contents!) as String
            webView.loadHTMLString(contents!, baseURL: baseUrl)
        }
    }
    
    func initCourseResources(){
        if(contents != nil && baseUrl != nil){
            contents = courseDetails.getCourseResourcesHtmlContents(contents: contents!) as String
            webView.loadHTMLString(contents!, baseURL: baseUrl)
        }
    }
    
    func initCourseSessions(){
        if(contents != nil && baseUrl != nil){
            contents = courseDetails.getCourseSessionsHtmlContents(contents: contents!) as String
            webView.loadHTMLString(contents!, baseURL: baseUrl)
            DispatchQueue.main.async {
                Utility.hideLoading()
            }
        }
    }
    
    func initCourseProviders(){
        if(contents != nil && baseUrl != nil){
            contents = courseDetails.getCourseProvidersHtmlContents(contents: contents!) as String
            webView.loadHTMLString(contents!, baseURL: baseUrl)
        }
    }
    
    func initCourseLeaders(){
        if(contents != nil && baseUrl != nil){
            contents = courseDetails.getCourseLeadersHtmlContents(contents: contents!) as String
            webView.loadHTMLString(contents!, baseURL: baseUrl)
        }
    }
}

extension CourseDetailsViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.scheme == "usgbc"){
            let urlComponents = URLComponents(string: (request.url?.absoluteString)!)
            let queryItems = urlComponents?.queryItems
            let param = queryItems?.filter({$0.name == "id"}).first
            if let id = String(param!.value!){
                let sb = UIStoryboard(name: "Dashboard", bundle: nil)
                let viewController = sb.instantiateViewController(withIdentifier: "CourseDetailsViewController") as! CourseDetailsViewController
                viewController.courseId = id
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            return false
        }
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

extension CourseDetailsViewController: LoginDelegate {
    func loginDone() {
        onScreen = true
        (contents, baseUrl) = TemplateManager.shared.getTemplateContents(file: "courseTemplate")
        print("loginDone")
        initCourseDetails()
        initCourseResources()
        initCourseLeaders()
        initCourseProviders()
        initCourseSessions()
    }
}
