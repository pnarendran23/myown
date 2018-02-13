//
//  DirectoryProjectListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 20/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class DirectoryProjectListViewController: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {
    var selectedfilter : [String] = ["all","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
    fileprivate var searchText = ""
    fileprivate var category = "All"
    fileprivate var loadType = "init"
    fileprivate var pageNumber = 0
    fileprivate var pageSize = 50
    fileprivate var lastRecordsCount = 0
    fileprivate var loading = false
    fileprivate var searchOpen = false
    var projects: [Project] = []
    var filterProjects: [Project] = []
    var totalCount = 0
    var from = 0
    var size = 50
    var filterChanged = false
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        self.nodata.isHidden = true
        //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
        //loadProjectsWithPagination(filterChanged: filterChanged, id: "", category: category, loadType: "init")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "Projects"
        loadType = "init"
        pageNumber = 0
        //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
        from = 0
        self.searchText = self.searchBar.text!
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.hex(hex: Colors.primaryColor)
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        //right nav buttons
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(DirectoryProjectListViewController.handleSearch(_:)), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.addTarget(self, action: #selector(DirectoryProjectListViewController.handleFilter(_:)), for: .touchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        
        /*let mapBarButton = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(DirectoryProjectListViewController.handleMap(_:)))
        mapBarButton.setTitleTextAttributes( [NSFontAttributeName : UIFont.systemFont(ofSize: 17.0),NSForegroundColorAttributeName : UIColor.white], for: .normal)
        mapBarButton.width = 0.0*/
        
        let mapButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        mapButton.setImage(UIImage(named: "map"), for: .normal)
        mapButton.imageView?.tintColor = UIColor.white
        mapButton.imageView?.contentMode = .scaleAspectFit
        mapButton.addTarget(self, action:#selector(DirectoryProjectListViewController.handleMap(_:)), for: .touchUpInside)
        let mapBarButton = UIBarButtonItem(customView: mapButton)
        
        tabBarController?.navigationItem.rightBarButtonItems = [mapBarButton, filterBarButton, searchBarButton]
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.loading = true
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        loadProjectsWithPagination(from: from, size: size, category: category, search: searchText, loadType: loadType)
    }
    
    func initViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        collectionView.register(UINib(nibName: "ProjectCompactCell", bundle: nil), forCellWithReuseIdentifier: "ProjectCompactCell")
        
        //Refresh control for UICollectionView
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
        refreshControl.addTarget(self, action: #selector(DirectoryProjectListViewController.handleRefresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    //MARK: - IBActions
    @IBAction func handleRefresh(_ sender: UIRefreshControl){
        sender.endRefreshing()
        //category = "All"
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
        //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
        //loadProjectsWithPagination(filterChanged: filterChanged, id: "", category: category, loadType: loadType)
        from = 0
        size = 40
        loadProjectsWithPagination(from: from, size: size, category: category, search: searchText, loadType: loadType)
    }
    
    func handleFilter(_ sender: Any){
        performSegue(withIdentifier: "DirectoryProjectFilterViewController", sender: self)
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
    
    func handleMap(_ sender: Any){
        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        let projectsMapTab = sb.instantiateViewController(withIdentifier: "DirectoryProjectMapViewController")
        let projectsTabBarItem = UITabBarItem(title: "Projects", image: UIImage(named: "projects_empty"), selectedImage: UIImage(named: "projects_filled"))
        projectsMapTab.tabBarItem = projectsTabBarItem
        tabBarController?.viewControllers?[2] = projectsMapTab
    }
    
    //To load JSON from file
    func loadProjects(category: String, search: String, page: Int, loadType: String){
        Utility.showLoading()
        ApiManager.shared.getProjectsNew (category: category, search: search, page: page, callback: {(projects, error) in
            if(error == nil){
                Utility.hideLoading()
                self.filterChanged = false
                if(loadType == "init"){
                    self.projects = projects!
                    self.lastRecordsCount = projects!.count
                    self.filterProjects = self.projects
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.collectionView.reloadData()
                    print("init")
                    if(self.filterProjects.count == 0){
                        self.nodata.isHidden = false
                    }else{
                        self.nodata.isHidden = true
                    }
                    print(self.filterProjects.count)
                }else{
                    self.projects.append(contentsOf: projects!)
                    self.lastRecordsCount = projects!.count
                    self.filterProjects = self.projects
                    self.collectionView.reloadData()
                    self.loading = false
                    print("more")
                    if(self.filterProjects.count == 0){
                        self.nodata.isHidden = false
                    }else{
                        self.nodata.isHidden = true
                    }
                    print(self.filterProjects.count)
                }
            }else{
                var statuscode = error?._code
                if(statuscode != -999){
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong, try again later!")
                }
            }
        })
    }
    
    @IBOutlet weak var nodata: UILabel!
    func loadProjectsWithPagination(from: Int , size: Int, category: String, search: String,  loadType: String){
        ApiManager.shared.getProjectsElasticWithpaginationNew(from: from, sizee: size, search: search, category:  category, callback: { totalCount, projects, error in
            if(error == nil){
                if(loadType == "init"){
                    //self.totalCount = totalCount!
                    self.projects = projects!
                    self.lastRecordsCount = projects!.count
                    self.filterProjects = self.projects
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.collectionView.reloadData()
                    print("init")
                    print(self.filterProjects.count)
                    self.from += self.projects.count
                    self.loading = false
                    self.pageNumber += self.projects.count
                    DispatchQueue.main.async {
                        if(self.filterProjects.count > 0){
                            self.nodata.isHidden = true
                        }else{
                            self.nodata.isHidden = false
                        }
                        Utility.hideLoading()
                    }
                    
                }else{
                    if(projects!.count > 0){
                        self.projects.append(contentsOf: projects!)
                        self.lastRecordsCount = projects!.count
                        self.filterProjects = self.projects
                        self.collectionView.reloadData()
                        self.loading = false
                        self.pageNumber += self.projects.count
                        print("more")
                        print(self.filterProjects.count)
                        self.from += self.projects.count
                        DispatchQueue.main.async {
                            if(self.filterProjects.count > 0){
                                self.nodata.isHidden = true
                            }else{
                                self.nodata.isHidden = false
                            }
                            Utility.hideLoading()
                        }
                    }else{
                        self.loading = true
                        DispatchQueue.main.async {
                            Utility.hideLoading()
                            if(self.filterProjects.count > 0){
                                self.nodata.isHidden = true
                            }else{
                                self.nodata.isHidden = false
                            }
                            Utility.showToast(message: "That was all")
                        }
                    }
                }
            }else{
                var statuscode = error?._code
                if(statuscode != -999){
                    Utility.hideLoading()
                    if(self.filterProjects.count > 0){
                        self.nodata.isHidden = true
                    }else{
                        self.nodata.isHidden = false
                    }
                    Utility.showToast(message: "Something went wrong, try again later!")
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectDetailsViewController" {
            if let viewController = segue.destination as? ProjectDetailsViewController {
                viewController.projectID = filterProjects[sender as! Int].ID
            }
        }else if segue.identifier == "DirectoryProjectFilterViewController" {
            if let rootViewController = segue.destination as? UINavigationController {
                let viewController = rootViewController.topViewController as! DirectoryProjectFilterViewController
                viewController.delegate = self
                viewController.filter = category
                viewController.totalCount = totalCount
                viewController.selectedfilter = selectedfilter
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

//MARK: UICollectionView delegates
extension DirectoryProjectListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterProjects.count
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
        let project = filterProjects[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCompactCell", for: indexPath) as! ProjectCompactCell
        cell.updateViews(project: project)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == filterProjects.count-1 && !loading {
            DispatchQueue.main.async {
                Utility.showLoading()
                self.loadType = "more"
                self.pageNumber = 0
                //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
                self.from += 1
                self.pageNumber = self.from
                self.loading = true
                ApiManager.shared.stopAllSessions()
                Utility.showLoading()
                self.loadProjectsWithPagination(from: self.from, size: self.size, category: self.category, search: self.searchText, loadType: self.loadType)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ProjectDetailsViewController", sender: indexPath.row)
    }
}

//MARK: - UISearchBar Delegate
extension DirectoryProjectListViewController: UISearchBarDelegate {
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
        loadType = "init"
        pageNumber = 0
        //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
        from = 0
        loadProjectsWithPagination(from: from, size: size, category: category, search: searchText, loadType: loadType)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchTxt: String) {
            DispatchQueue.main.async {
                Utility.showLoading()
                self.searchText = searchTxt
                self.loadType = "init"
                self.pageNumber = 0
                //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
                self.from = 0
                self.loading = false
                ApiManager.shared.stopAllSessions()
                Utility.showLoading()
                self.loadProjectsWithPagination(from: self.from, size: self.size, category: self.category, search: self.searchText, loadType: self.loadType)
            }
        
    }
    
}

//MARK: - Organization Filter Delegate
extension DirectoryProjectListViewController: ProjectFilterDelegate {
    func userDidSelectedFilter(filter: String, totalCount: Int, selfilter : [String]) {
        self.selectedfilter = selfilter
        var s = filter
        var temp = [String]()
        for str in selfilter{
            if(str != "" && str.lowercased() != "all"){
                temp.append("%22" + str + "%22")
            }
        }
        s = temp.joined(separator: " OR ")
        s = s.replacingOccurrences(of: ":", with: "%3A")        
        s = s.replacingOccurrences(of: " ", with: "%20")
        if(filter == "All"){
            
        }else{
            category = "\(s as! String)"
        }
        searchText = ""
        pageNumber = 0
        loadType = "init"
        filterChanged = true
        self.totalCount = totalCount
        //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
        //loadProjectsWithPagination(filterChanged: filterChanged, id: self.scrollId, category: category, loadType: loadType)
        from = 0
        size = 40
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        loadProjectsWithPagination(from: from, size: size, category: category, search: searchText, loadType: loadType)
    }
}
