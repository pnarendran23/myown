//
//  DirectoryOrganizationListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 20/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class DirectoryOrganizationListViewController: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var nodata: UILabel!
    fileprivate var searchText = ""
    var category = "all"
    var rating = "all"
    var version = "all"
    var selectedfilter : [String] = ["all","","","","",""]
    fileprivate var loadType = "init"
    fileprivate var pageNumber = 0
    fileprivate var pageSize = 50
    fileprivate var lastRecordsCount = 0
    fileprivate var loading = false
    fileprivate var searchOpen = false
    fileprivate var organizations: [Organization] = []
    fileprivate var filterOrganizations: [Organization] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.keyboardDismissMode = .onDrag
        self.nodata.isHidden = true
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
        tabBarController?.title = "Organizations"
        loadType = "init"
        pageNumber = 0
        //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
        
        self.searchText = self.searchBar.text!
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.hex(hex: Colors.primaryColor)
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        //right nav buttons
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(DirectoryOrganizationListViewController.handleSearch(_:)), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.addTarget(self, action: #selector(DirectoryOrganizationListViewController.handleFilter(_:)), for: .touchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        
        tabBarController?.navigationItem.rightBarButtonItems = [filterBarButton, searchBarButton]
        
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        //Refresh control for UICollectionView
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
        refreshControl.addTarget(self, action: #selector(DirectoryOrganizationListViewController.handleRefresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        self.pageNumber = 0
        DispatchQueue.main.async {
            Utility.showLoading()
            self.loadOrganizations(rating : self.rating, version : self.version, category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType )
        }
        
    }
    
    func initViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        collectionView.register(UINib(nibName: "OrganizationCompactCell", bundle: nil), forCellWithReuseIdentifier: "OrganizationCompactCell")
    }
    
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
        DispatchQueue.main.async {
            Utility.showLoading()
            self.loadOrganizations(rating : self.rating, version : self.version, category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType )
        }
    }
    
    @IBAction func handleFilter(_ button: UIBarButtonItem){
        performSegue(withIdentifier: "DirectoryOrganizationFilterViewController", sender: self)
    }
    
    @IBAction func handleSearch(_ sender: Any){
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
    
    //To load JSON from file
    func loadOrganizations(rating: String, version: String, category: String, search: String, page: Int, loadType: String){
        Utility.showLoading()
        var parameter = category.replacingOccurrences(of: " ", with: "%20")
        parameter = parameter.replacingOccurrences(of: "&", with: "%26")
        ApiManager.shared.getOrganizationsNew(rating: rating, size: 50, parameter : parameter, version: version, category: category, search: self.searchText, page: page, callback: { (organizations:[Organization]?, error:NSError?) in
            if(error == nil){
                DispatchQueue.main.async {
                        Utility.hideLoading()
                }
                if(loadType == "init"){
                    self.organizations = organizations!
                    self.lastRecordsCount = organizations!.count
                    self.filterOrganizations = self.organizations
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.loading = false
                    self.pageNumber += organizations!.count
                    self.collectionView.reloadData()
                    if(self.filterOrganizations.count == 0){
                        self.nodata.isHidden = false
                    }else{
                        self.nodata.isHidden = true
                    }
                    print(self.filterOrganizations.count)
                }else{
                    if(organizations!.count > 0){
                        self.organizations.append(contentsOf: organizations!)
                        self.loading = false
                        if(self.organizations.count == 0){
                            self.loading = true
                            Utility.showToast(message: "That was all")
                        }
                        self.lastRecordsCount = organizations!.count
                        self.filterOrganizations = self.organizations
                        self.collectionView.reloadData()
                        self.pageNumber += organizations!.count
                        if(self.filterOrganizations.count == 0){
                            self.nodata.isHidden = false
                        }else{
                            self.nodata.isHidden = true
                        }
                        print(self.filterOrganizations.count)
                    }else{
                        self.loading = true
                        Utility.showToast(message: "That was all")      
                    }
                }
            }else{
                var statuscode = error?._code
                if(statuscode != -999){
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong, try again later!")
                    self.loading = false
                        Utility.showToast(message: "That was all")
                    
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrganizationOverviewViewController" {
            if let viewController = segue.destination as? OrganizationOverviewViewController {
                viewController.organizationID = (sender as! Organization).ID
            }
        }else if segue.identifier == "DirectoryOrganizationFilterViewController" {
            if let rootViewController = segue.destination as? UINavigationController {
                let viewController = rootViewController.topViewController as! DirectoryOrganizationFilterViewController
                viewController.delegate = self
                viewController.filter = category
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
extension DirectoryOrganizationListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOrganizations.count
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
        let organization = filterOrganizations[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrganizationCompactCell", for: indexPath) as! OrganizationCompactCell
        cell.updateViews(organization: organization)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == filterOrganizations.count-1 && !loading {
            loading = true
            loadType = "more"
            pageNumber += 1
            DispatchQueue.main.async {
                Utility.showLoading()
                self.loadOrganizations(rating : self.rating, version : self.version, category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType )
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OrganizationOverviewViewController", sender: filterOrganizations[indexPath.row])
    }
}

//MARK: - UISearchBar Delegate
extension DirectoryOrganizationListViewController: UISearchBarDelegate {
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
        DispatchQueue.main.async {
            Utility.showLoading()
            self.loadOrganizations(rating : self.rating, version : self.version, category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType )
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchTxt: String) {
        
        
            DispatchQueue.main.async {
                self.searchText = searchTxt
                self.loadType = "init"
                self.pageNumber = 0
                Utility.showLoading()
                self.loading = true
                self.pageNumber = 0
                ApiManager.shared.stopAllSessions()
                self.loadOrganizations(rating: self.rating, version: self.version, category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
                
            }
    }
}

//MARK: - Organization Filter Delegate
extension DirectoryOrganizationListViewController: OrganizationFilterDelegate {
    func userDidSelectedFilter(filter: String,selfilter : [String]) {
        self.selectedfilter = selfilter
        var temp = [String]()
        for item in selfilter{
            if(item != "" && item.lowercased() != "all"){
                temp.append(item)
            }
        }
        var result = "all"
        if(temp.count > 0){
            result = temp.joined(separator: " OR ")
            result = result.replacingOccurrences(of: " ", with: "%20")
            print(result)
            category = "%28relationship:" + result + "%29"
        }else{
            category = result
        }
        category = category.replacingOccurrences(of: "partners", with: "partner")
        self.pageNumber = 0
        DispatchQueue.main.async {
            Utility.showLoading()
            self.loadOrganizations(rating: self.rating, version: self.version, category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
        }
    }
}

