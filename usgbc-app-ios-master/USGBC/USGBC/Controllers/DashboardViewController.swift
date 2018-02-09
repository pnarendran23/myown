//
//  DashoardVC.swift
//  USGBC
//
//  Created by Vishal Raj on 24/06/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import Firebase
import FirebaseFirestore

class DashboardViewController: UIViewController,UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var drawerContainer: UIView!
    @IBOutlet weak var drawerTableView: UITableView!
    @IBOutlet weak var seeMoreImageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var notificationBarButton: UIBarButtonItem!
    var igcMenu: IGCMenu?
    let sb = UIStoryboard(name: "Dashboard", bundle: nil)
    
    @IBOutlet weak var articleslbl: UILabel!
    var quickMenus: [QuickMenu] = []
    var settings: [SettingsMenu] = []
    var selectedSettings: [SettingsMenu] = []
    var controllers: [String] = []
    var articles: [Article] = []
    var helper: Utility!
    
    var drawerOpen = false
    var isMenuActive = false
    var userSeenDashboard = false
    var actualrect = CGRect()
    var currentNotificationCount = 0
    var previousNotificationCount = 0
    var drawerMenuList: [String] = ["My Account", "Credentials", "Education@USGBC", "Articles", "Resources", "Publications", "Directory", "Credit Library", "Favorites", "Settings",  "About Us"]
    var previousNotifications: [NotificationLog] = []
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    func changeorientation(){
        AppUtility.lockOrientation(.portrait)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            AppUtility.lockOrientation(.all)
        }
        loaded = true
        self.updatecollectionview()
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func rotated() {
        self.updatecollectionview()
    }
    
    override func viewDidLayoutSubviews() {
        //self.articleCollectionView.collectionViewLayout.invalidateLayout()
    }
    var h : CGFloat = 0.0
    var w : CGFloat = 0.0
 
    
    
    func updatecollectionview(){
        self.articleCollectionView.frame.origin.y = 1.1 * (self.articleslbl.frame.size.height + self.articleslbl.frame.origin.y)
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        if(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height){
        h = UIScreen.main.bounds.size.width
        w = self.articleCollectionView.layer.bounds.size.height
        }else{
        h = self.articleCollectionView.layer.bounds.size.height
        w = UIScreen.main.bounds.size.width
        }
        layout.itemSize = CGSize(width: w * 0.9, height: h * 1.1)//270)
        if(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height){
            layout.itemSize = CGSize(width: 0.5 * h, height: 0.95 * w)//270)
        }else{
            layout.itemSize = CGSize(width: 0.85 * w, height: 0.95 * h)//270)
        }
        if(UIDevice.current.userInterfaceIdiom == .pad){
        //self.articleCollectionView.frame.size.height = 0.8 * h
        layout.itemSize = CGSize(width: 0.8 * w, height: h)//270)
        if(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height){
        layout.itemSize = CGSize(width: 0.5 * h, height:0.9 * w)//270)
        }else{
        layout.itemSize = CGSize(width: 0.7 * w, height: 0.95 * h)//270)
        }
        }
        print(layout.itemSize.width,layout.itemSize.height)
        self.articleCollectionView.collectionViewLayout = layout
        self.articleCollectionView.reloadData()
    }
    
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.articleCollectionView.frame.origin.y = 1.1 * (self.articleslbl.frame.size.height + self.articleslbl.frame.origin.y)
        actualrect = self.articleCollectionView.frame
        h = self.articleCollectionView.frame.size.height
        w = self.articleCollectionView.frame.size.width
        self.articleCollectionView.backgroundColor = UIColor.clear
        self.automaticallyAdjustsScrollViewInsets = false
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height){
            h = self.articleCollectionView.frame.size.width
            w = self.articleCollectionView.frame.size.height
        }else{
            h = self.articleCollectionView.frame.size.height
            w = self.articleCollectionView.frame.size.width
        }
        layout.itemSize = CGSize(width: w * 0.9, height: h * 1.1)//270)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            //self.articleCollectionView.frame.size.height = 0.8 * h
            layout.itemSize = CGSize(width: 0.8 * w, height: h)//270)
            if(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height){
                layout.itemSize = CGSize(width: 1.1 * w, height: w)//270)
            }else{
                layout.itemSize = CGSize(width: 1.1 * h, height: h)//270)
            }
        }
        print(layout.itemSize.width,layout.itemSize.height)
        self.articleCollectionView.collectionViewLayout = layout
        print(self.articleCollectionView.frame.size.height,self.articleCollectionView.frame.size.width, UIScreen.main.bounds.size.width,UIScreen.main.bounds.size.height)
        self.articleCollectionView.register(UINib.init(nibName: "ArticleCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCell")
        AppUtility.lockOrientation(.portrait)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.changeorientation), userInfo: nil, repeats: false)
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBaseTapOnly))
        doubleTapRecognizer.numberOfTapsRequired = 1
        doubleTapRecognizer.delegate = self
        self.view.addGestureRecognizer(doubleTapRecognizer)
    }
    var loaded = false
    
    override func viewDidAppear(_ animated: Bool) {
        if(loaded == true){
            AppUtility.lockOrientation(.portrait)
            if(UIDevice.current.userInterfaceIdiom == .pad){
                AppUtility.lockOrientation(.all)
            }
        }
        DispatchQueue.main.async {
            self.helper = Utility()
            Utility.showLoading()
            self.loadArticleJson()
            self.initViews()
            self.loadQuickMenus()
            self.loadSettingsMenus()
            self.setDefaultQuickMenu()
            self.initQuickMenu()
            self.getPreviousNotifications()
            self.loadNotifications()
            if(self.helper.getTokenDetail() != ""){
                if(!self.drawerMenuList.contains("Logout")){
                    self.drawerMenuList.append("Logout")
                    self.drawerTableView.reloadData()
                }
            }
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if ((touch.view?.isDescendant(of: drawerTableView))! || (touch.view?.isDescendant(of: self.articleCollectionView))!){
            return false
        }
        return true
    }
    
    func onBaseTapOnly(sender: UITapGestureRecognizer) {
        hideDrawer()
    }
    
    func removeNotificationBadge(){
        notificationBarButton.removeBadge()
    }
    
    func getPreviousNotifications(){
        let realm = try! Realm()
        previousNotifications = Array(realm.objects(NotificationLog.self))
        print("Previous Notifications: \(previousNotifications.count)")
    }
    
    //MARK: - Init views
    func initViews(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        drawerContainer.backgroundColor = UIColor.hex(hex: Colors.drawerBackground)
        drawerTableView.tableFooterView = UIView()
        
        drawerTableView.delegate = self
        drawerTableView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        
        seeMoreImageView.tintColor = UIColor.lightGray
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DashboardViewController.handleSwipe(_:)))
        swipeLeft.direction = .left
        mainContainer.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(DashboardViewController.handleSwipe(_:)))
        swipeRight.direction = .right
        mainContainer.addGestureRecognizer(swipeRight)
    }
    
    func initQuickMenu(){
        getSelectedSettings()
        menuButton.backgroundColor = UIColor.hex(hex: Colors.primaryColor)
        menuButton.layer.cornerRadius = menuButton.frame.size.height / 2
        menuButton.layer.shadowColor = UIColor.darkGray.cgColor
        menuButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        menuButton.layer.shadowRadius = 1.0
        menuButton.layer.shadowOpacity = 0.7
        menuButton.layer.masksToBounds = false
        igcMenu = IGCMenu()
        igcMenu?.menuButton = menuButton
        igcMenu?.menuSuperView = self.view
        igcMenu?.disableBackground = true
        igcMenu?.backgroundType = .None
        igcMenu?.delegate = self
        igcMenu?.numberOfMenuItem = settings[1].sectionList.filter{$0.selected == true}.count
        var backColor:[UIColor] = []
        var menuImage:[String] = []
        controllers.removeAll()
        settings[1].sectionList.forEach { (section) in
            if(section.selected == true){
                quickMenus.forEach({ quickMenu in
                    if(quickMenu.name == section.name){
                        backColor.append(UIColor.hex(hex: Colors.primaryColor))
                        menuImage.append(quickMenu.image)
                        controllers.append(quickMenu.controller)
                    }
                })
            }
        }
        igcMenu?.menuBackgroundColorsArray = backColor
        igcMenu?.menuImagesNameArray = menuImage
    }
    
    func showDrawer(){
        mainContainer.layer.shadowOpacity = 1
        menuButton.alpha = 0
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseOut,
                       animations: {
                            self.mainContainer.transform = CGAffineTransform(translationX: 224, y: 0)
        }, completion: nil)
        drawerOpen = true
    }
    
    func hideDrawer(){
        mainContainer.layer.shadowOpacity = 0
        menuButton.alpha = 1
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseIn,
                       animations: {
                            self.mainContainer.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        drawerOpen = false
    }

    func showHideMenu(){
        if isMenuActive {
            menuButton.setImage(UIImage(named: "plus.png"), for: .normal)
            igcMenu?.hideCircularMenu()
            isMenuActive = false
        }
        else {
            menuButton.setImage(UIImage(named: "cross.png"), for: .normal)
            igcMenu?.showCircularMenu()
            isMenuActive = true
        }
    }
    
    func hideCircleMenu(){
        if isMenuActive {
            menuButton.setImage(UIImage(named: "plus.png"), for: .normal)
            igcMenu?.hideCircularMenu()
            isMenuActive = false
        }
    }
    
    //To load JSON from file
    func loadArticleJson(){
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        Utility.showLoading()
        ApiManager.shared.getArticlesfromElastic(category: "All", size: 10, callback: {(articles, error) in
            if(error == nil){
                //Utility.hideLoading()
                self.articles = articles!
                self.articleCollectionView.reloadData()
            }else{
                //Utility.hideLoading()
                Utility.showToast(message: "Unable to get featured articles!")
            }
        })
        //FirebaseApp.configure()
        /*let defaultStore = Firestore.firestore()
        let articleRef = defaultStore.collection("articles")
        articleRef
            .order(by: "postedDate", descending: true)
            .limit(to: 10)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print(querySnapshot!.count)
                    for document in querySnapshot!.documents {
                        let article = Article()
                        article.addData(document: document)
                        self.articles.append(article)
                    }
                    self.articles = self.articles.sorted(by: {$0.postedDate > $1.postedDate})
                    self.articleCollectionView.reloadData()
                }
                DispatchQueue.main.async {
                    Utility.hideLoading()
                }
        }*/
    }
    
    func loadNotifications(){
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        ApiManager.shared.getNotificationLogs(email: Utility().getUserDetail(), callback: { (notifications, error) in
            if(error == nil){
                let uniqueNotifications = Set(notifications!).subtracting(Set(self.previousNotifications))
                if(uniqueNotifications.count > 0){
                    self.notificationBarButton.addBadge(number: uniqueNotifications.count)
                }
            }
            DispatchQueue.main.async {
                    Utility.hideLoading()
            }
        })
    }

    //MARK: Quick Menu settings
    //To load Quick Menu list from json file
    func loadQuickMenus(){
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        JsonManager.shared.getQuickMenus { (quickMenus, error) in
            if(error == nil){
                self.quickMenus = quickMenus!
                print(self.quickMenus)
            }
        }
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    //To load Settings Menu list from json file
    func loadSettingsMenus(){
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        JsonManager.shared.getSettings { (settingsMenus, error) in
            if(error == nil){
                self.settings = settingsMenus!
            }
        }
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    //To set default Quick Menu
    func setDefaultQuickMenu(){
        if(!userSeenDashboard){
            for i in 0..<3 {
                saveSettings(section: 1, sectionName: "Quick Menu", path: i, selected: true)
            }
            userSeenDashboard = true
        }
    }
    
    //To set default Setting Menu in DB
    func saveSettings(section: Int, sectionName: String, path: Int, selected: Bool){
        let realm = try! Realm()
        let preSettings = realm.objects(SettingsMenu.self)
        if(preSettings.count > 0){
            try! realm.write{
                preSettings[section].sectionName = sectionName
                preSettings[section].sectionList[path].selected = selected
            }
        }else{
            settings[section].sectionName = sectionName
            settings[section].sectionList[path].selected = selected
            do{
                try realm.write { () -> Void in
                    realm.add(settings)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //To get Setting Menu from DB
    func getSelectedSettings(){
        let realm = try! Realm()
        selectedSettings = Array(realm.objects(SettingsMenu.self))
        if(selectedSettings.count > 0){
            settings = selectedSettings
        }
    }

    //MARK: - Logout dialog
    func showLogoutDialog(){
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure, you want to logout? ", preferredStyle: UIAlertControllerStyle.alert)
        logoutAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.logoutUser()
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            logoutAlert .dismiss(animated: true, completion: nil)
        }))
        present(logoutAlert, animated: true, completion: nil)
    }
    
    func logoutUser(){
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        let utility = Utility()
        let params = ["app_id": utility.getAppID(), "updated_on": Utility.getCurrentDate(), "partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "active_status": "0"]
        print(params)
        ApiManager.shared.updateFCMDevice(params: params, callback: { (message, error) in
            if(message != nil && error == nil){
                let appId = Utility().getAppID()
                let appDomain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
                UserDefaults.standard.set(true, forKey: "onboardingComplete")
                UserDefaults.standard.synchronize()
                self.drawerMenuList.removeLast()
                self.drawerTableView.reloadData()
                Utility().saveAppID(appId: appId)
                Utility.showToast(message: "You've logged out successfully")
            }else{
                Utility.showToast(message: "Something went wrong!")
            }
            DispatchQueue.main.async {
                Utility.hideLoading()
            }
        })
    }
    
    //MARK: - IBActions
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == UISwipeGestureRecognizerDirection.right {
            showDrawer()
        }
        else if sender.direction == UISwipeGestureRecognizerDirection.left {
            hideDrawer()
        }
    }
    
    @IBAction func HandleMenuButton(_ sender: UIButton) {
        showHideMenu()
    }
    
    @IBAction func handleSeeMore(_ sender: Any){
        performSegue(withIdentifier: "ArticleListViewController", sender: self)
    }
    
    @IBAction func handleDrawer(_ sender: Any) {
        hideCircleMenu()
        if(!drawerOpen){
            showDrawer()
        }else{
            hideDrawer()
        }
    }
    
    @IBAction func handleNotification(_ sender: Any) {
        performSegue(withIdentifier: "NotificationListViewController", sender: self)
    }
    
    //MARK: Segue prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArticleDetailsViewController" {
            if let viewController = segue.destination as? ArticleDetailsViewController {
                viewController.articleId = articles[sender as! Int].ID
                viewController.key = articles[sender as! Int].ID
            }
        }else if segue.identifier == "SettingsViewController" {
            if let viewController = segue.destination as? SettingsViewController {
                viewController.delegate = self
            }
        }else if segue.identifier == "NotificationListViewController" {
            if let viewController = segue.destination as? NotificationListViewController {
                viewController.delegate = self
            }
        }
    }
    
    func performManualSegue(controller: String){
        
    }
}

//MARK: - UITableView delegates
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = drawerTableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath as IndexPath)
        cell.backgroundColor = UIColor.clear
        let iconView: UIImageView = cell.viewWithTag(1) as! UIImageView
        iconView.image = UIImage(named: "temp")!.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor.white
        
        if(drawerMenuList[indexPath.row].lowercased().contains("credit")){
            iconView.image = UIImage(named: "credits-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("directory")){
            iconView.image = UIImage(named: "directory-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("resources")){
            iconView.image = UIImage(named: "resources-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("account")){
            iconView.image = UIImage(named: "myaccount-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("credentials")){
            iconView.image = UIImage(named: "credentials-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("article")){
            iconView.image = UIImage(named: "article-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("education")){
            iconView.image = UIImage(named: "education-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("publication")){
            iconView.image = UIImage(named: "publication-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("settings")){
            iconView.image = UIImage(named: "settings-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("about")){
            iconView.image = UIImage(named: "about-us-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("favorites")){
            iconView.image = UIImage(named: "favorites-empty-new")
        }else if(drawerMenuList[indexPath.row].lowercased().contains("logout")){
            iconView.image = UIImage(named: "logout")
        }
        let labelView: UILabel = cell.viewWithTag(2)as! UILabel
        labelView.text = drawerMenuList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                if(helper.getTokenDetail() != ""){
                    navigationController?.pushViewController(MyAccountTabViewController(), animated: true)
                }else{
                    AppUtility.lockOrientation(.portrait)
                    let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    loginViewController.sender = "MyAccountViewController"
                    navigationController?.pushViewController(loginViewController, animated: true)
                }
            case 1:
                if(helper.getTokenDetail() != ""){
                    navigationController?.pushViewController(CredentialsTabViewController(), animated: true)
                }else{
                    let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    loginViewController.sender = "CredentialsViewController"
                    navigationController?.pushViewController(loginViewController, animated: true)
                }
            case 2:
                performSegue(withIdentifier: "CourseListViewController", sender: self)
            case 3:
                performSegue(withIdentifier: "ArticleListViewController", sender: self)
            case 4:
                navigationController?.pushViewController(ResourcesTabViewController(), animated: true)
            case 5:
                navigationController?.pushViewController(PublicationTabViewController(), animated: true)
            case 6:
                navigationController?.pushViewController(DirectoryTabViewController(), animated: true)
            case 7:
                performSegue(withIdentifier: "CreditListViewController", sender: self)
            case 8:
                performSegue(withIdentifier: "FavoriteListViewController", sender: self)
            case 9:
                performSegue(withIdentifier: "SettingsViewController", sender: self)
            case 10:
                navigationController?.pushViewController(AboutViewController(), animated: true)
            case 11:
                showLogoutDialog()
            default:
                break
            }
        hideDrawer()
    }
}

//MARK: - UICollectionView delegates
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        let iconView: UIImageView = cell.viewWithTag(1) as! UIImageView
        let image = UIImage(named: "logo-usgbc-gray")
        iconView.kf.setImage(with: URL(string: articles[indexPath.row].image), placeholder: image)
        iconView.layer.cornerRadius = 2
        iconView.clipsToBounds = true
        let titleLabelView: UILabel = cell.viewWithTag(2)as! UILabel
        titleLabelView.attributedText = Utility.linespacedString(string: articles[indexPath.row].title, lineSpace: 2)
        let authorLabelView: UILabel = cell.viewWithTag(3)as! UILabel
        authorLabelView.text = (articles[indexPath.row].username).replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return cell*/
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.updateViews(article: articles[indexPath.row])
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        performSegue(withIdentifier: "ArticleDetailsViewController", sender: indexPath.row)
    }
    
}




//MARK: - IGCMenu delegates
extension DashboardViewController: IGCMenuDelegate{
    func igcMenuSelected(selectedMenuName: String, atIndex index: Int) {
        switch index {
            case 0:
                hideCircleMenu()
                if(controllers[0] == "ArticleListViewController" || controllers[0] == "CourseListViewController" || controllers[0] == "CreditListViewController"){
                    performSegue(withIdentifier: controllers[0], sender: self)
                }else{
                    if(controllers[0] == "MyAccountTabViewController"){
                        print("MyAccountTabViewController")
                        if(helper.getTokenDetail() != ""){
                            print("MyAccountTabViewController if")
                            navigationController?.pushViewController(MyAccountTabViewController(), animated: true)
                        }else{
                            print("MyAccountTabViewController else")
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "MyAccountViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[0] == "CredentialsTabViewController"){
                        if(helper.getTokenDetail() != ""){
                            navigationController?.pushViewController(CredentialsTabViewController(), animated: true)
                        }else{
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "CredentialsViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[0] == "PublicationTabViewController"){
                        navigationController?.pushViewController(PublicationTabViewController(), animated: true)
                    }else if(controllers[0] == "ResourcesTabViewController"){
                        navigationController?.pushViewController(ResourcesTabViewController(), animated: true)
                    }else if(controllers[0] == "DirectoryTabViewController"){
                        navigationController?.pushViewController(DirectoryTabViewController(), animated: true)
                    }
                }
            case 1:
                hideCircleMenu()
                if(controllers[1] == "ArticleListViewController" || controllers[1] == "CourseListViewController" || controllers[1] == "CreditListViewController"){
                    performSegue(withIdentifier: controllers[1], sender: self)
                }else{
                    if(controllers[1] == "MyAccountTabViewController"){
                        if(helper.getTokenDetail() != ""){
                            navigationController?.pushViewController(MyAccountTabViewController(), animated: true)
                        }else{
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "MyAccountViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[1] == "CredentialsTabViewController"){
                        if(helper.getTokenDetail() != ""){
                            navigationController?.pushViewController(CredentialsTabViewController(), animated: true)
                        }else{
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "CredentialsViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[1] == "PublicationTabViewController"){
                        navigationController?.pushViewController(PublicationTabViewController(), animated: true)
                    }else if(controllers[1] == "ResourcesTabViewController"){
                        navigationController?.pushViewController(ResourcesTabViewController(), animated: true)
                    }else if(controllers[1] == "DirectoryTabViewController"){
                        navigationController?.pushViewController(DirectoryTabViewController(), animated: true)
                    }
            }
            case 2:
                hideCircleMenu()
                if(controllers[2] == "ArticleListViewController" || controllers[2] == "CourseListViewController" || controllers[2] == "CreditListViewController"){
                    performSegue(withIdentifier: controllers[2], sender: self)
                }else{
                    if(controllers[2] == "MyAccountsTabViewController"){
                        if(helper.getTokenDetail() != ""){
                            navigationController?.pushViewController(MyAccountTabViewController(), animated: true)
                        }else{
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "MyAccountViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[2] == "CredentialsTabViewController"){
                        if(helper.getTokenDetail() != ""){
                            navigationController?.pushViewController(CredentialsTabViewController(), animated: true)
                        }else{
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "CredentialsViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[2] == "PublicationTabViewController"){
                        navigationController?.pushViewController(PublicationTabViewController(), animated: true)
                    }else if(controllers[2] == "ResourcesTabViewController"){
                        navigationController?.pushViewController(ResourcesTabViewController(), animated: true)
                    }else if(controllers[2] == "DirectoryTabViewController"){
                        navigationController?.pushViewController(DirectoryTabViewController(), animated: true)
                    }
            }
            case 3:
                hideCircleMenu()
                if(controllers[3] == "ArticleListViewController" || controllers[3] == "CourseListViewController" || controllers[3] == "CreditListViewController"){
                    performSegue(withIdentifier: controllers[3], sender: self)
                }else{
                    if(controllers[3] == "MyAccountsTabViewController"){
                        if(helper.getTokenDetail() != ""){
                            navigationController?.pushViewController(MyAccountTabViewController(), animated: true)
                        }else{
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "MyAccountViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[3] == "CredentialsTabViewController"){
                        if(helper.getTokenDetail() != ""){
                            navigationController?.pushViewController(CredentialsTabViewController(), animated: true)
                        }else{
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "CredentialsViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[3] == "PublicationTabViewController"){
                        navigationController?.pushViewController(PublicationTabViewController(), animated: true)
                    }else if(controllers[3] == "ResourcesTabViewController"){
                        navigationController?.pushViewController(ResourcesTabViewController(), animated: true)
                    }else if(controllers[3] == "DirectoryTabViewController"){
                        navigationController?.pushViewController(DirectoryTabViewController(), animated: true)
                    }
            }
            case 4:
                hideCircleMenu()
                if(controllers[4] == "ArticleListViewController" || controllers[4] == "CourseListViewController" || controllers[4] == "CreditListViewController"){
                    performSegue(withIdentifier: controllers[4], sender: self)
                }else{
                    if(controllers[4] == "MyAccountTabViewController"){
                        if(helper.getTokenDetail() != ""){
                            navigationController?.pushViewController(MyAccountTabViewController(), animated: true)
                        }else{
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "MyAccountViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[4] == "CredentialsTabViewController"){
                        if(helper.getTokenDetail() != ""){
                            navigationController?.pushViewController(CredentialsTabViewController(), animated: true)
                        }else{
                            let loginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.sender = "CredentialsViewController"
                            navigationController?.pushViewController(loginViewController, animated: true)
                        }
                    }else if(controllers[4] == "PublicationTabViewController"){
                        navigationController?.pushViewController(PublicationTabViewController(), animated: true)
                    }else if(controllers[4] == "ResourcesTabViewController"){
                        navigationController?.pushViewController(ResourcesTabViewController(), animated: true)
                    }else if(controllers[4] == "DirectoryTabViewController"){
                        navigationController?.pushViewController(DirectoryTabViewController(), animated: true)
                    }
            }
            default:
                break
        }
    }
}

extension DashboardViewController: SettingsDelegate {
    func refreshQuickMenu(){
        initQuickMenu()
    }
}

extension DashboardViewController: NotificationDelegate {
    func userSeenNotifications() {
        removeNotificationBadge()
    }
}
