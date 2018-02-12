//
//  ResourceLeedListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 20/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResourceLeedListViewController: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var nodata: UILabel!
    fileprivate var searchText = ""
    fileprivate var category = "2780+2783+2781+4996+2782+1361+965/all/all/all/all/all"
    fileprivate var loadType = "init"
    fileprivate var pageNumber = 0
    fileprivate var pageSize = 40
    fileprivate var lastRecordsCount = 0
    fileprivate var loading = false
    fileprivate var searchOpen = false
    var resources: [Resource] = []
    var filterResources: [Resource] = []
    var filters: [ResourcesLeedFilter] = []
    var type: String = "2780+2783+2781+4996+2782+1361+965"
    var format: String = ""
    var ratingSystem: String = ""
    var versions: String = ""
    var access: String = ""
    var language: String = ""
    var totalCount = 0
    
    var typearr : [String] = ["Addenda","Calculators","Checklists","Certification","Guidance","Rating system","Standards"]
    var formatarr : [String] = []
    var ratingarr : [String] = []
    var versionarr : [String] = []
    var accessarr : [String] = []
    var languagearr : [String] = []
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nodata.isHidden = true
        self.collectionView.keyboardDismissMode = .onDrag
        initViews()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "LEED"
        print("Arrays are ",self.typearr,self.formatarr,self.ratingarr,self.versionarr,self.accessarr,self.languagearr)
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.hex(hex: Colors.primaryColor)
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        //right nav buttons
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(ResourceLeedListViewController.handleSearch(_:)), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.addTarget(self, action: #selector(ResourceLeedListViewController.handleFilter(_:)), for: .touchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        
        tabBarController?.navigationItem.rightBarButtonItems = [filterBarButton, searchBarButton]
        self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        loadFilters()
        loadResources(category: category, search: searchText, page: pageNumber, loadType: loadType)
    }
    
    func initViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        collectionView.register(UINib(nibName: "ResourceCompactCell", bundle: nil), forCellWithReuseIdentifier: "ResourceCompactCell")
        
        //Refresh control for UICollectionView
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
        refreshControl.addTarget(self, action: #selector(ResourceLeedListViewController.handleRefresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        
        
    }
    
    //MARK: - IBActions
    @IBAction func handleRefresh(_ sender: UIRefreshControl){
        sender.endRefreshing()
        category = "all"
        searchText = ""
        pageNumber = 0
        loadType = "init"
        if(searchOpen){
            searchBar.text = ""
            searchText = ""
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
            hideSearch()
        }
        loadResources(category: category, search: searchText, page: pageNumber, loadType: loadType)
    }
    
    func handleFilter(_ button: UIBarButtonItem){
        performSegue(withIdentifier: "ResourcesLeedFilterViewController", sender: nil)
    }
    
    func handleSearch(_ sender: Any){
        if(!searchOpen){
            searchBar.becomeFirstResponder()
            showSearch()
        }else{
            searchBar.resignFirstResponder()
            hideSearch()
        }
    }
    
    func showSearch(){
        collectionViewTopConstraint.constant = 54
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
        searchOpen = true
    }
    
    func hideSearch(){
        collectionViewTopConstraint.constant = 0
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
        searchOpen = false
    }
    
    func loadFilters(){
        JsonManager.shared.getResourcesLeedFilters { (filters: [ResourcesLeedFilter]?, error: NSError?) in
            if(error == nil){
                self.filters = filters!
                //print(filters?.count ?? "Error")
                //print(filters)
                var dict = filters!
                for i in 0...5{
                    if(i == 0){
                            var filterdict = dict[i] as! ResourcesLeedFilter
                        for item in self.typearr{
                            if(filterdict.subFilters.first(where: { $0.value == item}) != nil){
                                var d = filterdict.subFilters.first(where: { $0.value == item}) as! ResourcesLeedSubFilter
                                var index = filterdict.subFilters.index(where: { $0.value == item}) as! Int
                                d.selected = false
                                filterdict.subFilters.replace(index: index, object: d)
                            }
                        }
                        dict[i] = filterdict
                    }
                    
                    if(i == 1){
                        var filterdict = dict[i] as! ResourcesLeedFilter
                        for item in self.typearr{
                            if(filterdict.subFilters.first(where: { $0.value == item}) != nil){
                                var d = filterdict.subFilters.first(where: { $0.value == item}) as! ResourcesLeedSubFilter
                                var index = filterdict.subFilters.index(where: { $0.value == item}) as! Int
                                d.selected = false
                                filterdict.subFilters.replace(index: index, object: d)
                            }
                        }
                        dict[i] = filterdict
                    }
                    
                    if(i == 2){
                        var filterdict = dict[i] as! ResourcesLeedFilter
                        for item in self.typearr{
                            if(filterdict.subFilters.first(where: { $0.value == item}) != nil){
                                var d = filterdict.subFilters.first(where: { $0.value == item}) as! ResourcesLeedSubFilter
                                var index = filterdict.subFilters.index(where: { $0.value == item}) as! Int
                                d.selected = false
                                filterdict.subFilters.replace(index: index, object: d)
                            }
                        }
                        dict[i] = filterdict
                    }
                    
                    if(i == 3){
                        var filterdict = dict[i] as! ResourcesLeedFilter
                        for item in self.typearr{
                            if(filterdict.subFilters.first(where: { $0.value == item}) != nil){
                                var d = filterdict.subFilters.first(where: { $0.value == item}) as! ResourcesLeedSubFilter
                                var index = filterdict.subFilters.index(where: { $0.value == item}) as! Int
                                d.selected = false
                                filterdict.subFilters.replace(index: index, object: d)
                            }
                        }
                        dict[i] = filterdict
                    }
                    
                    if(i == 4){
                        var filterdict = dict[i] as! ResourcesLeedFilter
                        for item in self.typearr{
                            if(filterdict.subFilters.first(where: { $0.value == item}) != nil){
                                var d = filterdict.subFilters.first(where: { $0.value == item}) as! ResourcesLeedSubFilter
                                var index = filterdict.subFilters.index(where: { $0.value == item}) as! Int
                                d.selected = false
                                filterdict.subFilters.replace(index: index, object: d)
                            }
                        }
                        dict[i] = filterdict
                    }
                    
                    if(i == 5){
                        var filterdict = dict[i] as! ResourcesLeedFilter
                        for item in self.typearr{
                            if(filterdict.subFilters.first(where: { $0.value == item}) != nil){
                                var d = filterdict.subFilters.first(where: { $0.value == item}) as! ResourcesLeedSubFilter
                                var index = filterdict.subFilters.index(where: { $0.value == item}) as! Int
                                d.selected = false
                                filterdict.subFilters.replace(index: index, object: d)
                            }
                        }
                        dict[i] = filterdict
                    }
                    
                    
                    self.filters = dict
                }
                //print("After processing", self.filters)
            }
        }
    }
    
    //To load JSON from file
    func loadResources(category: String, search: String, page: Int, loadType: String){
        Utility.showLoading()
        var parameter = Payloads().makePayloadForResources(typearray: typearr, formatarray: formatarr, ratingarray: ratingarr, versionarray: versionarr, accessarray: accessarr, languagearray: languagearr)
        if(search.characters.count > 0){
            parameter = search + "%20AND%20(" + parameter + ")"
        }
        
        ApiManager.shared.getResources(category: category, parameter : parameter, size: 50, search: search, page: page, callback: { (resources:[Resource]?, error:NSError?) in
            if(error == nil){
                if(loadType == "init"){
                    self.resources = resources!
                    self.lastRecordsCount = resources!.count
                    self.filterResources = self.resources
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.collectionView.reloadData()
                    if(self.filterResources.count == 0){
                        self.nodata.isHidden = false
                    }else{
                        self.nodata.isHidden = true
                    }
                    print(self.resources.count)
                }else{
                    if(resources!.count > 0){
                    self.resources.append(contentsOf: resources!)
                    self.lastRecordsCount = resources!.count
                    self.filterResources = self.resources
                    self.collectionView.reloadData()
                    self.loading = false
                    if(self.filterResources.count == 0){
                        self.nodata.isHidden = false
                    }else{
                        self.nodata.isHidden = true
                    }
                    }else{
                        self.loading = true
                        Utility.showToast(message: "That was all")
                    }
                    print(self.filterResources.count)
                }
                Utility.hideLoading()
            }else{
                var statuscode = error?._code as! Int
                if(statuscode != -999){
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong, try again later!")
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResourceDetailsViewController" {
            if let viewController = segue.destination as? ResourceDetailsViewController {
                viewController.resourceID = filterResources[sender as! Int].ID
            }
        }else if segue.identifier == "ResourcesLeedFilterViewController" {
            if let rootViewController = segue.destination as? UINavigationController {
                let viewController = rootViewController.topViewController as! ResourcesLeedFilterViewController
                viewController.delegate = self
                viewController.filters = filters
                viewController.type = type
                viewController.format = format
                viewController.ratingSystem = ratingSystem
                viewController.versions = versions
                viewController.access = access
                viewController.language = language
                viewController.totalCount = totalCount
                
                viewController.typearray = self.typearr
                viewController.formatarray = formatarr
                viewController.ratingarray = self.ratingarr
                viewController.versionarray = self.versionarr
                viewController.accessarray = self.accessarr
                viewController.languagearray = self.languagearr
            }
        }
    }
}

//MARK: UICollectionView delegates
extension ResourceLeedListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterResources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        if UI_USER_INTERFACE_IDIOM() == .pad {
            //let baseWidth: CGFloat = 320
            //let baseHeight: CGFloat = 240
            let width: CGFloat = (screenWidth / 2) - 30.0
            //let height: CGFloat = baseHeight * (width / baseWidth)
            return CGSize(width: floor(width), height: floor(100))
        }
        else {
            //IPhone
            //let baseWidth: CGFloat = 320
            //let baseHeight: CGFloat = 240
            let width: CGFloat = screenWidth
            //var height: CGFloat = baseHeight * (width / baseWidth)
            return CGSize(width: floor(width), height: floor(100))
            
        }
        //return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            return UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            return 20.0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let resource = self.filterResources[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResourceCompactCell", for: indexPath) as! ResourceCompactCell
        cell.updateViews(resource: resource)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == filterResources.count-1 && !loading {
            DispatchQueue.main.async {
                Utility.showLoading()
                self.loading = true
                self.loadType = "more"
                self.pageNumber += 1
                self.loadResources(category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ResourceDetailsViewController", sender: indexPath.row)
    }
}

//MARK: - UISearchBar Delegate
extension ResourceLeedListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.black
        let attributes = [NSForegroundColorAttributeName : UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchText = ""
        searchBar.resignFirstResponder()
        hideSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            Utility.showLoading()
            self.searchText = searchText
            self.loading = true
            self.loadType = "init"
            self.pageNumber = 0
            ApiManager.shared.stopAllSessions()
            self.loadResources(category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
        }
    }
}

extension ResourceLeedListViewController: ResourcesLeedFilterDelegate {
    func userDidSelectedFilter(filters: [ResourcesLeedFilter], changed: Bool, type: String, format: String, ratingSystem: String, versions: String, access: String, language: String, totalCount: Int, typearray : [String], formatarray : [String], ratingarray : [String], versionarray : [String], accessarray : [String], languagearray : [String]) {
        if(changed){
            self.filters = filters
            self.totalCount = totalCount
            print("ResourcesLeedFilter")
            print(type)
            print(format)
            print(ratingSystem)
            print(versions)
            print(access)
            print(language)
            self.type = type
            self.format = format
            self.ratingSystem = ratingSystem
            self.versions = versions
            self.access = access
            self.language = language
            self.typearr = typearray
            self.formatarr = formatarray
            self.ratingarr = ratingarray
            self.versionarr = versionarray
            self.accessarr = accessarray
            self.languagearr = languagearray
            self.typearr = typearray
            //type/rating/version/language/format/member
            category = ((type.isEmpty) ? "all" : type) + "/" + ((ratingSystem.isEmpty) ? "all" : ratingSystem) + "/" + ((versions.isEmpty) ? "all" : versions) + "/" + ((language.isEmpty) ? "all" : language) + "/" + ((format.isEmpty) ? "all" : format) +  "/" + ((access.isEmpty) ? "all" : access)
            print(category)
            searchText = ""
            loadType = "init"
            pageNumber = 0
            loadResources(category: category, search: searchText, page: pageNumber, loadType: loadType)
        }
    }
}
