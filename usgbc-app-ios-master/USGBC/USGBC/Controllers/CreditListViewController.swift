//
//  CreditListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 19/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreditListViewController: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {

    fileprivate var searchText = ""
    fileprivate var pageNumber = 0
    fileprivate var pageSize = 40
    fileprivate var lastRecordsCount = 0
    fileprivate var loading = false
    fileprivate var searchOpen = false
//    fileprivate var rating = "new-construction"
//    fileprivate var version = "v4"
    fileprivate var rating = "all"
    fileprivate var version = "all"
    fileprivate var credit = "all"
    fileprivate var filter = "all"
    fileprivate var loadType = "init"
    fileprivate var credits: [Credit] = []
    fileprivate var filterCredits: [Credit] = []
    var totalCount = 0
    var category = "All"
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchText = searchBar.text!
        self.collectionView.keyboardDismissMode = .onDrag
        loadCredits(rating: rating, version: version, credit: credit, search: searchText, page: pageNumber, loadType: loadType)
        initViews()
    }
    
    func initViews(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.hex(hex: Colors.primaryColor)
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(CreditListViewController.handleSearch(_:)), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.addTarget(self, action: #selector(CreditListViewController.handleFilter(_:)), for: .touchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        
        navigationItem.rightBarButtonItems = [filterBarButton, searchBarButton]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        collectionView.register(UINib(nibName: "CreditCompactCell", bundle: nil), forCellWithReuseIdentifier: "CreditCompactCell")
        
        //Refresh control for UICollectionView
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
        refreshControl.addTarget(self, action: #selector(ArticleListViewController.handleRefresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    @IBAction func handleRefresh(_ sender: UIRefreshControl){
        sender.endRefreshing()
        credit = "all"
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
        loadCredits(rating: rating, version: version, credit: credit, search: searchText, page: pageNumber, loadType: loadType)
    }
    
    //To perform filter on articles
    @IBAction func handleFilter(_ sender: Any){
        performSegue(withIdentifier: "CreditFilterViewController", sender: self)
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                Utility.hideLoading()
                self.loading = false
            }
        
    }
    
    //To load JSON from file
    func loadCredits(rating: String, version: String, credit: String, search: String, page: Int, loadType: String){
        Utility.showLoading()
        var parameter = category.replacingOccurrences(of: " ", with: "%20")
        parameter = parameter.replacingOccurrences(of: "&", with: "%26")
        ApiManager.shared.getCredits(rating: rating, parameter : parameter, version: version, credit: credit, search: search, page: page, callback: { (credits:[Credit]?, error:NSError?) in
            if(error == nil){
                Utility.hideLoading()
                if(loadType == "init"){
                    self.credits = credits!
                    self.lastRecordsCount = credits!.count
                    self.filterCredits = self.credits
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.collectionView.reloadData()
                    print(self.filterCredits.count)
                }else{
                    self.credits.append(contentsOf: credits!)
                    self.lastRecordsCount = credits!.count
                    self.filterCredits = self.credits
                    self.collectionView.reloadData()
                    self.loading = false
                    print(self.filterCredits.count)
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
    
    //MARK: Segue Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreditDetailsViewController" {
            if let viewController = segue.destination as? CreditDetailsViewController {
                viewController.creditId = filterCredits[sender as! Int].ID
                
            }
        }else if segue.identifier == "CreditFilterViewController" {
            if let rootViewController = segue.destination as? UINavigationController {
                let viewController = rootViewController.topViewController as! CreditFilterViewController
                viewController.delegate = self
                viewController.filter = credit
                viewController.totalCount = totalCount
                viewController.category = category
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
}

//MARK: UICollectionView delegates
extension CreditListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterCredits.count
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
        let credit = filterCredits[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreditCompactCell", for: indexPath) as! CreditCompactCell
        cell.updateViews(credit: credit)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == filterCredits.count-1 && !loading && lastRecordsCount == pageSize {
            loading = true
            loadType = "more"
            pageNumber += 1
            loadCredits(rating: rating, version: version, credit: credit, search: searchText, page: pageNumber, loadType: loadType)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CreditDetailsViewController", sender: indexPath.row)
    }
}

//MARK: - UISearchBar Delegate
extension CreditListViewController: UISearchBarDelegate {
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
        if((searchBar.text?.characters.count)! >= 3){
           
        }else{
            Utility.showToast(message: "Minimum 3 letters!")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadType = "init"
        pageNumber = 0
        searchBar.showsCancelButton = false
        ApiManager.shared.stopAllSessions()
        loadCredits(rating: rating, version: version, credit: credit, search: searchText, page: pageNumber, loadType: loadType)
    }
}

//MARK: - Credit Filter Delegate
extension CreditListViewController: CreditFilterDelegate {
    func userDidSelectedFilter(filter: String, totalCount: Int, category : String) {
        credit = filter
        self.totalCount = totalCount
        searchText = ""
        self.category = category
        pageNumber = 0
        loadType = "init"
        loadCredits(rating: rating, version: version, credit: credit, search: searchText, page: pageNumber, loadType: loadType)
    }
}
