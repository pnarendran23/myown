//
//  DirectoryPeopleListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 20/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class DirectoryPeopleListViewController: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate{
    var rating = ""
    var version = ""
    @IBOutlet weak var nodata: UILabel!
    fileprivate var searchText = ""
    fileprivate var category = "all"
    fileprivate var loadType = "init"
    fileprivate var pageNumber = 0
    fileprivate var pageSize = 40
    fileprivate var lastRecordsCount = 0
    fileprivate var loading = false
    fileprivate var searchOpen = false
    var people: [People] = []
    var filterPeople: [People] = []
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nodata.isHidden = true
        initViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    var selectedfilter : [String] = ["all","","","","","","",""]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "People"
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
        searchButton.addTarget(self, action: #selector(DirectoryPeopleListViewController.handleSearch(_:)), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.addTarget(self, action: #selector(DirectoryPeopleListViewController.handleFilter(_:)), for: .touchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        
        tabBarController?.navigationItem.rightBarButtonItems = [filterBarButton, searchBarButton]
        
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        DispatchQueue.main.async {
            Utility.showLoading()
            self.loadPeople(category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
        }
    }
    
    func initViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        collectionView.register(UINib(nibName: "PeopleCompactCell", bundle: nil), forCellWithReuseIdentifier: "PeopleCompactCell")
        
        //Refresh control for UICollectionView
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
        refreshControl.addTarget(self, action: #selector(DirectoryPeopleListViewController.handleRefresh(_:)), for: .valueChanged)
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
        DispatchQueue.main.async {
            Utility.showLoading()
            self.loadPeople(category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
        }
    }
    
    func handleFilter(_ button: UIBarButtonItem){
        performSegue(withIdentifier: "DirectoryPeopleFilterViewController", sender: self)
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
    
    func handleSearch(_ sender: Any){
        if(!searchOpen){
            searchBar.becomeFirstResponder()
            showSearch()
        }else{
            searchBar.resignFirstResponder()
            hideSearch()
        }
    }
    
    //To load JSON from file
    func loadPeople(category: String, search: String, page: Int, loadType: String){
        Utility.showLoading()
        var parameter = category.replacingOccurrences(of: " ", with: "%20")
        parameter = parameter.replacingOccurrences(of: "&", with: "%26")
        ApiManager.shared.getPeopleNew(rating: rating, size: 50, parameter : parameter, version: version, category: category, search: self.searchText, page: page, callback: { (people:[People]?, error:NSError?) in
            if(error == nil){
                DispatchQueue.main.async {
                    Utility.hideLoading()                 
                }
                if(loadType == "init"){
                    self.people = people!
                    self.lastRecordsCount = people!.count
                    self.filterPeople = self.people
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.collectionView.reloadData()
                    if(self.filterPeople.count == 0){
                        self.nodata.isHidden = false
                    }else{
                        self.nodata.isHidden = true
                    }
                    DispatchQueue.main.async {
                        if(people!.count < 50){
                            self.loading = true
                            Utility.hideLoading()
                            if(people!.count > 0){
                                Utility.showToast(message: "That was all")
                            }
                        }else{
                            Utility.hideLoading()
                            self.loading = false
                        }
                    }
                    print(self.filterPeople.count)
                }else{
                    if(people!.count > 0){
                    self.people.append(contentsOf: people!)
                    self.lastRecordsCount = people!.count
                    self.filterPeople = self.people
                        self.pageNumber += people!.count
                    self.collectionView.reloadData()
                    self.loading = false
                    if(self.filterPeople.count == 0){
                        self.nodata.isHidden = false
                    }else{
                        self.nodata.isHidden = true
                    }
                    print(self.filterPeople.count)
                    }else{
                        DispatchQueue.main.async {
                            Utility.hideLoading()
                            self.loading = true
                            Utility.showToast(message: "That was ")
                        }
                    }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PeopleDetailsViewController" {
            if let viewController = segue.destination as? PeopleDetailsViewController {
                viewController.peopleID = (sender as! People).ID
            }
        }else if segue.identifier == "DirectoryPeopleFilterViewController" {
            if let rootViewController = segue.destination as? UINavigationController {
                let viewController = rootViewController.topViewController as! DirectoryPeopleFilterViewController
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
extension DirectoryPeopleListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterPeople.count
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
        let people = self.filterPeople[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCompactCell", for: indexPath) as! PeopleCompactCell
        cell.updateViews(people: people)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == filterPeople.count-1 && !loading {
            loading = true
            loadType = "more"
            pageNumber += 1
            DispatchQueue.main.async {
                Utility.showLoading()
                self.loadPeople(category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PeopleDetailsViewController", sender: self.filterPeople[indexPath.row])
    }
}

//MARK: - UISearchBar Delegate
extension DirectoryPeopleListViewController: UISearchBarDelegate {
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
        self.loading = true        
        DispatchQueue.main.async {
            Utility.showLoading()
            self.loadPeople(category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
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
                self.loadPeople(category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
            }
        
    }
}

//MARK: - Organization Filter Delegate
extension DirectoryPeopleListViewController: PeopleFilterDelegate {
    func userDidSelectedFilter(filter: String, selfilter : [String]) {
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
            category = "%28relationships:" + result + "%29"
        }else{
            category = result
        }
        category = category.replacingOccurrences(of: "partners", with: "partner")
        self.pageNumber = 0
        DispatchQueue.main.async {
            Utility.showLoading()
            self.loadPeople(category: self.category, search: self.searchText, page: self.pageNumber, loadType: self.loadType)
        }
    }
}
