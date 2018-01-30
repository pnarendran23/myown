//
//  CourseListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 19/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import IOStickyHeader

class CourseListViewController: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {

    fileprivate var searchText = ""
    fileprivate var category = "all/all/all/all/all/all/all/all"
    fileprivate var loadType = "init"
    fileprivate var pageNumber = 0
    fileprivate var pageSize = 40
    fileprivate var lastRecordsCount = 0
    fileprivate var loading = false
    fileprivate var searchOpen = false
    var courses: [Course] = []
    var filterCourses: [Course] = []
    var filters: [CourseFilter] = []
    var playlists = ""
    var courseFeature = ""
    var continuingEducation = ""
    var ratingSystemVersion = ""
    var leedCreditCategory = ""
    var courseFormat = ""
    var courseLevel = ""
    var courseLanguage = ""
    var continuousarray = NSMutableArray()
    var versionarrar = NSMutableArray()
    var categoryarray = NSMutableArray()
    var formatarray = NSMutableArray()
    var levelarray = NSMutableArray()
    var languagearr = NSMutableArray()
    var isFiltered = false
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        //initCollectionHeaderView()
        //loadFilters()
        //loadCourses(category: category, search: searchText, page: pageNumber, loadType: loadType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadFilters()
        self.collectionView.keyboardDismissMode = .onDrag
        Utility.showLoading()
        if(isFiltered || courses.count == 0){
            loadCourses(category: category, search: searchText, page: pageNumber, loadType: loadType)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
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
        searchButton.addTarget(self, action: #selector(CourseListViewController.handleSearch(_:)), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.addTarget(self, action: #selector(CourseListViewController.handleFilter(_:)), for: .touchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        
        navigationItem.rightBarButtonItems = [filterBarButton, searchBarButton]
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        collectionView.register(UINib(nibName: "CourseCompactCell", bundle: nil), forCellWithReuseIdentifier: "CourseCompactCell")
        collectionView.register(UINib(nibName: "CourseRegularCell", bundle: nil), forCellWithReuseIdentifier: "CourseRegularCell")
        
        //Refresh control for UICollectionView
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
        refreshControl.addTarget(self, action: #selector(CourseListViewController.handleRefresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
//    func initCollectionHeaderView(){
//        if let layout: IOStickyHeaderFlowLayout = collectionView.collectionViewLayout as? IOStickyHeaderFlowLayout {
//            if UI_USER_INTERFACE_IDIOM() == .pad {
//                layout.parallaxHeaderReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 300)
//            }else{
//                layout.parallaxHeaderReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 200)
//            }
//            layout.parallaxHeaderMinimumReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 0)
//            layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: layout.itemSize.height)
//            layout.parallaxHeaderAlwaysOnTop = true
//            layout.disableStickyHeaders = true
//            collectionView.collectionViewLayout = layout
//        }
//        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withReuseIdentifier: "CollectionHeaderView")
//    }
    
    func handleRefresh(_ sender: UIRefreshControl){
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
        loadCourses(category: category, search: searchText, page: pageNumber, loadType: loadType)
    }
    
    @IBAction func handleFilter(_ sender: Any) {
        performSegue(withIdentifier: "CourseFilterViewController", sender: self)
    }
    
    @IBAction func handleSearch(_ sender: Any) {
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
    
    //To load courses from server
    func loadCourses(category: String, search: String, page: Int, loadType: String){
        Utility.showLoading()
        var parameter = Payloads().makePayloadForCourses(continuousarr: continuousarray, versionarr: versionarrar, categoryarr: categoryarray, formatarr: formatarray, levelarr: levelarray, languagearr: languagearr)
        if(search.characters.count > 0){
            if(parameter.characters.count > 0){
                parameter = search + "%20AND%20(" + parameter + ")"
            }else{
                parameter = search
            }
        }
        
        ApiManager.shared.getCoursesNew(category: category, parameter: parameter, search: search, page: page, callback: { (courses, error) in
            if(error == nil){
                Utility.hideLoading()
                if(loadType == "init"){
                    self.courses = courses!
                    self.lastRecordsCount = courses!.count
                    self.filterCourses = self.courses
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.collectionView.reloadData()
                    print(self.filterCourses.count)
                }else{
                    self.courses.append(contentsOf: courses!)
                    self.lastRecordsCount = courses!.count
                    self.filterCourses = self.courses
                    self.collectionView.reloadData()
                    self.loading = false
                    print(self.filterCourses.count)
                }
            }else{
                var statuscode = error?._code as! Int
                if(statuscode != -999){
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong, try again later!")
                }
            }
        })
    }
    
    func loadFilters(){
        JsonManager.shared.getCourseFilters { (filters: [CourseFilter]?, error: NSError?) in
            if(error == nil){
                self.filters = filters!
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CourseDetailsViewController" {
            if let viewController = segue.destination as? CourseDetailsViewController {
                viewController.courseId = courses[sender as! Int].ID
            }
        }else if segue.identifier == "CourseFilterViewController" {
            if let rootViewController = segue.destination as? UINavigationController {
                let viewController = rootViewController.topViewController as! CourseFilterViewController
                viewController.delegate = self
                viewController.filters = filters
                viewController.playlists = playlists
                viewController.courseFeature = courseFeature
                viewController.continuingEducation = continuingEducation
                viewController.ratingSystemVersion = ratingSystemVersion
                viewController.leedCreditCategory = leedCreditCategory
                viewController.courseFormat = courseFormat
                viewController.courseLevel = courseLevel
                viewController.courseLanguage = courseLanguage
                
                
                viewController.continuousarray = self.continuousarray
                viewController.versionarrar = self.versionarrar
                viewController.levelarray = self.levelarray
                viewController.languagearr = self.languagearr
                viewController.formatarray = self.formatarray
                viewController.categoryarray = self.categoryarray
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
//        coordinator.animate(alongsideTransition: nil) { _ in
//            self.initCollectionHeaderView()
//        }
    }
}

//MARK: UICollectionView delegates
extension CourseListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterCourses.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case IOStickyHeaderParallaxHeader:
//            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderView", for: indexPath) as! CollectionHeaderView
//            if let image = filterCourses.first?.image{
//                if(image != " "){
//                    let placeHolder = UIImage(named: "placeholder")
//                    cell.imageView.kf.setImage(with: URL(string: image.trimmingCharacters(in: NSCharacterSet.whitespaces)), placeholder: placeHolder)
//                }else{
//                    cell.imageView.image = UIImage(named: "logo-usgbc-gray")
//                }
//            }
//            return cell
//        default:
//            assert(false, "Unexpected element kind")
//        }
//        return UICollectionReusableView()
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if(UIApplication.shared.statusBarOrientation.isPortrait){
                let baseWidth: CGFloat = 320
                let baseHeight: CGFloat = 240
                let width: CGFloat = (screenWidth / 2) - 30.0
                let height: CGFloat = baseHeight * (width / baseWidth)
                return CGSize(width: floor(width), height: floor(height))
            }else{
                let baseWidth: CGFloat = 320
                let baseHeight: CGFloat = 240
                let width: CGFloat = (screenWidth / 3) - 30.0
                let height: CGFloat = baseHeight * (width / baseWidth)
                return CGSize(width: floor(width), height: floor(height))
            }
        }
        else {
            //IPhone
            //let baseWidth: CGFloat = 320
            //let baseHeight: CGFloat = 240
            //let width: CGFloat = screenWidth
            //var height: CGFloat = baseHeight * (width / baseWidth)
            //return CGSize(width: floor(width), height: floor(100))
            if(UIApplication.shared.statusBarOrientation.isPortrait){
                let baseWidth: CGFloat = 320
                let baseHeight: CGFloat = 240
                let width: CGFloat = screenWidth - 40.0
                let height: CGFloat = baseHeight * (width / baseWidth)
                return CGSize(width: floor(width), height: floor(height))
            }else{
                let baseWidth: CGFloat = 320
                let baseHeight: CGFloat = 240
                let width: CGFloat = (screenWidth / 2) - 30.0
                let height: CGFloat = baseHeight * (width / baseWidth)
                return CGSize(width: floor(width), height: floor(height))
            }
            
        }
        //return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            return UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)
        }
        return UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)//.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            return 20.0
        }
        return 20//0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let course = filterCourses[indexPath.row]
//        if UI_USER_INTERFACE_IDIOM() == .pad {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseRegularCell", for: indexPath) as! CourseRegularCell
            cell.updateViews(course: course)
            return cell
//        }else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCompactCell", for: indexPath) as! CourseCompactCell
//            cell.updateViews(course: course)
//            if(indexPath.row == 0){
//                cell.imageViewWidthConstaint.constant = 0
//            }else{
//                cell.imageViewWidthConstaint.constant = 76
//            }
//            cell.layoutIfNeeded()
//            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == filterCourses.count-1 && !loading && lastRecordsCount == pageSize {
            loading = true
            loadType = "more"
            pageNumber += 1
            loadCourses(category: category, search: searchText, page: pageNumber, loadType: loadType)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CourseDetailsViewController", sender: indexPath.row)
    }
}

//MARK: - UISearchBar Delegate
extension CourseListViewController: UISearchBarDelegate {
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
        loadCourses(category: category, search: searchText, page: pageNumber, loadType: loadType)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadType = "init"
        pageNumber = 0
        ApiManager.shared.stopAllSessions()
        loadCourses(category: category, search: searchText, page: pageNumber, loadType: loadType)
    }
    
}

extension CourseListViewController: CourseFilterDelegate {
    func userDidSelectedFilter(filters: [CourseFilter], changed: Bool, playlists: String, courseFeature: String, continuingEducation: String, ratingSystemVersion: String, leedCreditCategory: String, courseFormat: String, courseLevel: String, courseLanguage: String,  continuousarray : NSMutableArray, versionarrar : NSMutableArray, categoryarray : NSMutableArray, formatarray : NSMutableArray,levelarray : NSMutableArray,languagearr : NSMutableArray) {
        if(changed){
            
            self.filters = filters
            self.playlists = playlists
            self.courseFeature = courseFeature
            self.continuingEducation = continuingEducation
            self.ratingSystemVersion = ratingSystemVersion
            self.leedCreditCategory = leedCreditCategory
            self.courseFormat = courseFormat
            self.courseLevel = courseLevel
            self.courseLanguage = courseLanguage
            self.isFiltered = true            
            self.categoryarray = categoryarray
            self.continuousarray = continuousarray
            self.levelarray = levelarray
            self.formatarray = formatarray
            self.languagearr = languagearr
            self.versionarrar = versionarrar
            
            
            if(courseLevel.characters.count == 0){
                category = "all"
            }else{
                category = courseLevel
            }
            
            if(continuingEducation.characters.count == 0){
                category = category + "/" + "all"
            }else{
                category = category + "/" + continuingEducation
            }
            
            if(ratingSystemVersion.characters.count == 0){
                category = category + "/" + "all"
            }else{
                category = category + "/" + ratingSystemVersion
            }
            
            if(leedCreditCategory.characters.count == 0){
                category = category + "/" + "all"
            }else{
                category = category + "/" + category + "/" + leedCreditCategory
            }
            
            if(courseFormat.characters.count == 0){
                category = category + "/" + "all"
            }else{
                category = category + "/" + courseFormat
            }
            
            if(courseLanguage.characters.count == 0){
                category = category + "/" + "all"
            }else{
                category = category + "/" + courseLanguage
            }
            
            if(courseFeature.characters.count == 0){
                category = category + "/" + "all"
            }else{
                category = category + "/" + courseFeature
            }
            
            //category = ((courseLevel.isEmpty) ? "all" : courseLevel) + "/" + ((continuingEducation.isEmpty) ? "all" : continuingEducation) + "/" + ((ratingSystemVersion.isEmpty) ? "all" : ratingSystemVersion) + "/" + ((leedCreditCategory.isEmpty) ? "all" : leedCreditCategory) + "/" + ((courseFormat.isEmpty) ? "all" : courseFormat) + "/" + ((courseLanguage.isEmpty) ? "all" : courseLanguage) + "/" + ((courseFeature.isEmpty) ? "all" : courseFeature)
            print(category)
            searchText = ""
            loadType = "init"
            pageNumber = 0
            loadCourses(category: category, search: searchText, page: pageNumber, loadType: loadType)
        }
    }
}
