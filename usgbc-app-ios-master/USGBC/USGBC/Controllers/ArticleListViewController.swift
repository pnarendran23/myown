//
//  ArticleListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 18/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import Kingfisher
import IOStickyHeader
import FirebaseFirestore
import FirebaseDatabase

class ArticleListViewController: UIViewController {
    
    @IBOutlet weak var nodata: UILabel!
    fileprivate var searchText = ""
    fileprivate var category = "All"
    fileprivate var loadType = "init"
    fileprivate var pageNumber = 0
    fileprivate var pageSize = 40
    fileprivate var lastRecordsCount = 0
    fileprivate var loading = false
    fileprivate var searchOpen = false
    fileprivate var articles: [Article] = []
    fileprivate var filterArticles: [Article] = []
    var start = 0
    var end = 50
    var totalCount = 0

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    
    //var ref: DatabaseReference!
    let defaultStore = Firestore.firestore()
    
    override func viewDidLoad() {
        
        DispatchQueue.main.async {
            Utility.showLoading()
            self.initViews()
            AppUtility.lockOrientation(.all)
            self.collectionView.keyboardDismissMode = .onDrag
            //loadFirestoreData(category: "All")
            if((self.searchBar.text?.characters.count)! > 0){
                self.searchData(keyword: self.searchBar.text!)
            }else{
            self.getData()
            }
        }
        
        //loadAllFirestoreData(category: "All")
        //loadArticles(category: category, search: searchText, page: pageNumber, loadType: loadType)
    }
    
    func loadFirestoreData(category: String){
        Utility.showLoading()
        filterArticles.removeAll()
        articles.removeAll()
        let articleRef = defaultStore.collection("articles")
        
        if(category != "All"){
            articleRef
                .order(by: "postedDate", descending: true)
                .whereField("channel", isEqualTo: category)
                .limit(to: 10)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print(querySnapshot!.count)
                        for document in querySnapshot!.documents {
                            let article = Article()
                            article.addData(document: document)
                            self.filterArticles.append(article)
                        }
                        //self.filterArticles = self.filterArticles.sorted(by: {$0.postedDate > $1.postedDate})
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            Utility.hideLoading()
                        }
                        self.articles = self.filterArticles
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            print("done")
                            //
                            self.getData()
                        })
                    }
                }
        }else{
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
                        self.filterArticles.append(article)
                        //self.collectionView.reloadData()
                    }
                    //self.filterArticles = self.filterArticles.sorted(by: {$0.postedDate > $1.postedDate})
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        Utility.hideLoading()
                    }
                    self.articles = self.filterArticles
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        print("done")
                        //self.loadAllFirestoreData(category: "All")
                        self.getData()
                    })
                }
            }
        }
    }
    
    func searchData(keyword : String){
        
        ApiManager.shared.searchArticlesfromElastic(category: category, size: 50, keyword: keyword, callback: {(articles, error) in
            
            //(category: "all", search: "", page: 0, callback:  { (articles, error) in
            if(error == nil){
                //self.filterArticles = self.filterArticles.sorted(by: {$0.postedDate > $1.postedDate})
                DispatchQueue.main.async {
                    self.filterArticles = articles!
                    self.collectionView.reloadData()
                    Utility.hideLoading()
                }
                
            }else{
                //Utility.hideLoading()
                var statuscode = error?._code
                if(statuscode != -999){
                Utility.showToast(message: "Something went wrong")
                }
            }
            //self.loadAllFirestoreData(category: self.category)
        })
    }

    
    func getData(){
        ApiManager.shared.getArticlesfromElastic(category: category, size : 50, callback: {(articles, error) in
        
        //(category: "all", search: "", page: 0, callback:  { (articles, error) in
                        if(error == nil){
                            self.articles = articles!
                            //self.filterArticles = self.filterArticles.sorted(by: {$0.postedDate > $1.postedDate})
                            DispatchQueue.main.async {
                                self.filterArticles = self.articles
                                self.collectionView.reloadData()                                
                                Utility.hideLoading()
                            }
                            
                      }else{
                            //Utility.hideLoading()
                            var statuscode = error?._code
                            if(statuscode != -999){
                                Utility.showToast(message: "Something went wrong")
                            }
                        }
            //self.loadAllFirestoreData(category: self.category)
                    })
    }
    
    func loadAllFirestoreData(category: String){
        self.getData()
        /*
        let articleRef = defaultStore.collection("articles")
        if(category != "All"){
            articleRef
                .order(by: "postedDate", descending: true)
                .whereField("channel", isEqualTo: category)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print(querySnapshot!.count)
                        self.filterArticles.removeAll()
                        for document in querySnapshot!.documents {
                            let article = Article()
                            article.addData(document: document)
                            self.filterArticles.append(article)
                        }
                        //self.filterArticles = self.filterArticles.sorted(by: {$0.postedDate > $1.postedDate})
                        self.articles = self.filterArticles
                        self.collectionView.reloadData()
                    }
            }
        }else{
            articleRef
                .order(by: "postedDate", descending: true)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print(querySnapshot!.count)
                        self.filterArticles.removeAll()
                        for document in querySnapshot!.documents {
                            let article = Article()
                            article.addData(document: document)
                            self.filterArticles.append(article)
                        }
                        //self.filterArticles = self.filterArticles.sorted(by: {$0.postedDate > $1.postedDate})
                        self.articles = self.filterArticles
                        print("refresh done")
                        self.collectionView.reloadData()
                    }
            }
        }*/
    }
    
    func loadFirebaseData(){
        //Utility.showLoading()
        //Firebase
        //ref = Database.database().reference()
        //ref.child("articles")//.queryOrdered(byChild: "channel")
        //.queryLimited(toFirst: UInt(end))//for 40 records per page
        //.queryOrdered(byChild: "title")
        //.queryStarting(atValue: "Clone").queryEnding(atValue: "Clone"+"\u{f8ff}")
        //.observe(DataEventType.value, with: { (snapshot) in
        //    let articlesDict = snapshot.value as? [String : AnyObject] ?? [:]
        //    print(articlesDict.count)
        //    articlesDict.forEach({ (key, value) in
        //        let article = Article()
        //        article.key = key
        //        article.ID = value["ID"] as? String ?? ""
        //        article.image = value["image"] as? String ?? ""
        //        article.title = value["title"] as? String ?? ""
        //        article.postedDate = value["postedDate"] as? String ?? ""
        //        article.username = value["username"] as? String ?? ""
        //        article.imageSmall = value["imageSmall"] as? String ?? ""
        //        article.channel = value["channel"] as? String ?? ""
        //        self.filterArticles.append(article)
        //    })
        //    self.filterArticles = self.filterArticles.sorted(by: {$0.postedDate > $1.postedDate})
        //    self.collectionView.reloadData()
        //    self.start = self.end
        //    Utility.hideLoading()
        //})
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
        
    }
    
    //MARK: - Init Views
    func initViews(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.hex(hex: Colors.primaryColor)
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor

        //Navbar buttons
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(ArticleListViewController.handleSearch(_:)), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.addTarget(self, action: #selector(ArticleListViewController.handleFilter(_:)), for: .touchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        
        navigationItem.rightBarButtonItems = [filterBarButton, searchBarButton]
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        //CollectionView Sticky Header
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
        
        //collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        collectionView.register(UINib(nibName: "ArticleCompactCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCompactCell")
        collectionView.register(UINib(nibName: "ArticleRegularCell", bundle: nil), forCellWithReuseIdentifier: "ArticleRegularCell")
        collectionView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCell")
        //collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withReuseIdentifier: "CollectionHeaderView")
        
        //Refresh control for UICollectionView
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
        refreshControl.addTarget(self, action: #selector(ArticleListViewController.handleRefresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    //MARK: - IBActions
    @IBAction func handleRefresh(_ sender: UIRefreshControl){
        sender.endRefreshing()
        category = "All"
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
        //loadArticles(category: category, search: searchText, page: pageNumber, loadType: loadType)
        loadAllFirestoreData(category: category)
    }
    
    @IBAction func handleFilter(_ sender: Any) {
        performSegue(withIdentifier: "ArticleFilterViewController", sender: self)
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
    
    //MARK: - Load Articles
    func loadArticles(category: String, search: String, page: Int, loadType: String){
        Utility.showLoading()
        ApiManager.shared.getArticlesNew(category: category, search: search, page: page, callback: { (articles, error) in
            if(error == nil){
                Utility.hideLoading()
                if(loadType == "init"){
                    self.articles = articles!
                    self.lastRecordsCount = articles!.count
                    self.filterArticles = self.articles
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.collectionView.reloadData()
                    print(self.filterArticles.count)
                }else{
                    self.articles.append(contentsOf: articles!)
                    self.lastRecordsCount = articles!.count
                    self.filterArticles = self.articles
                    self.collectionView.reloadData()
                    self.loading = false
                    print(self.filterArticles.count)
                }
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong, try again later!")
            }
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
        //        coordinator.animate(alongsideTransition: nil) { _ in
        //            self.initCollectionHeaderView()
        //        }
    }
    
    //MARK: Segue Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArticleDetailsViewController" {
            if let articleDetailsViewController = segue.destination as? ArticleDetailsViewController {
                articleDetailsViewController.articleId = filterArticles[sender as! Int].ID
                articleDetailsViewController.key = filterArticles[sender as! Int].ID
            }
        }else if segue.identifier == "ArticleFilterViewController" {
            if let rootViewController = segue.destination as? UINavigationController {
                let articleFilterViewController = rootViewController.topViewController as! ArticleFilterViewController
                articleFilterViewController.delegate = self
                articleFilterViewController.filter = category
                articleFilterViewController.totalCount = totalCount
            }
        }
    }
}

//MARK: UICollectionView Delegate
extension ArticleListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(filterArticles.count == 0){
            self.nodata.isHidden = false
        }else{
            self.nodata.isHidden = true
        }
        return filterArticles.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case IOStickyHeaderParallaxHeader:
//            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderView", for: indexPath) as! CollectionHeaderView
//            if let image = filterArticles.first?.image{
//                let placeHolder = UIImage(named: "placeholder")
//                cell.imageView.kf.setImage(with: URL(string: image.trimmingCharacters(in: NSCharacterSet.whitespaces)), placeholder: placeHolder)
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
        //return CGSize(width: floor(collectionView.frame.size.width), height: floor(collectionView.frame.size.height))
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
        let article = filterArticles[indexPath.row]
//        if UI_USER_INTERFACE_IDIOM() == .pad {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleRegularCell", for: indexPath) as! ArticleRegularCell
//            cell.updateViews(article: article)
//            return cell
//        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
            cell.updateViews(article: article)
//            cell.layer.borderWidth = 1
//            cell.layer.borderColor = UIColor.red.cgColor
//            if(indexPath.row == 0){
//                cell.imageWidth.constant = 0
//            }else{
//                cell.imageWidth.constant = 76
//            }
//            cell.layoutIfNeeded()
            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == filterArticles.count-1 && !loading && lastRecordsCount == pageSize {
//            loading = true
//            loadType = "more"
//            pageNumber += 1
//            loadArticles(category: category, search: searchText, page: pageNumber, loadType: loadType)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        performSegue(withIdentifier: "ArticleDetailsViewController", sender: indexPath.row)
    }
}

//MARK: - UISearchBar Delegate
extension ArticleListViewController: UISearchBarDelegate {
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
        //loadArticles(category: category, search: searchText, page: pageNumber, loadType: loadType)
        filterArticles = articles
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if((searchBar.text?.characters.count)! > 0){
            self.searchData(keyword: searchBar.text!)
        }else{
            searchBar.showsCancelButton = false
            hideSearch()
            loadType = "init"
            pageNumber = 0
            //loadArticles(category: category, search: searchText, page: pageNumber, loadType: loadType)
            filterArticles = articles
            collectionView.reloadData()
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

//MARK: - Article Filter Delegate
extension ArticleListViewController: ArticleFilterDelegate {
    func userDidSelectedFilter(filter: String, totalCount: Int) {
        category = filter
        self.totalCount = totalCount
        searchText = ""
        pageNumber = 0
        loadType = "init"
        //loadArticles(category: category, search: searchText, page: pageNumber, loadType: loadType)
        loadAllFirestoreData(category: category)
    }
}

//extension ArticleListViewController: ArticlesViewModel {
//    func getArticles(category: String) -> [Article] {
//        ApiManager.shared.getArticlesFromFirebase(category: category, callback: articles, error){
//            if(error == nil) {
//                this.filterArticles = articles!
//                collectionView.reloadData()
//            }
//        }
//    }
//}
