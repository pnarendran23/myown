//
//  ArticleFilterViewControllerNew.swift
//  USGBC
//
//  Created by Vishal Raj on 23/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol ArticleFilterDelegate: class {
    func userDidSelectedFilter(filter: String, selfilter : [String], totalCount: Int)
}

class ArticleFilterViewController: UIViewController {

    var filter: String!
    weak var delegate: ArticleFilterDelegate?
    fileprivate var filterChanged = false
    fileprivate var filters: [ArticleFilter] = []
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
    var totalCount = 0
    var selectedfilter : [String] = ["all","","","","","","","","",""]
    let defaultStore = Firestore.firestore()
    var countsDictionary : NSMutableDictionary!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsets.zero
        DispatchQueue.main.async {
            Utility.showLoading()
            self.tableView.allowsMultipleSelection = true
            self.tableView.frame.origin.y = 0
            self.initViews()
            self.getcounts()
        }
        //loadFirestoreData(category: filter)
        //loadTotalArticlesCount(category: filter.replacingOccurrences(of: "-", with: " "))
    }
    
    func getcounts(){
        ApiManager.shared.getArticlesCounts(cat : "ss") { (dict, error) in
            if(error == nil){
                print(dict)
                self.countsDictionary = dict
                self.loadFilters()
                Utility.hideLoading()
                //self.totalArticlesLabel.text = "\(count!) of \(self.totalCount) articles"
            }
        }
    }
    
    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SubFilterCell", bundle: nil), forCellReuseIdentifier: "SubFilterCell")
        tableView.tableFooterView = UIView()
    }
    
    //To load list of available filters
    func loadFilters(){
        JsonManager.shared.getArticleFilters { (filters: [ArticleFilter]?, error: NSError?) in
            if(error == nil){
                self.filters = filters!
                //self.filters.filter ({($0.name.lowercased()).replacingOccurrences(of: " ", with: "-") == self.filter.lowercased()}).first?.selected = true
                self.filters.filter ({($0.name == self.filter)}).first?.selected = true
                self.tableView.reloadData()
            }
        }
    }
    
    func loadTotalArticlesCount(category: String){
        ApiManager.shared.getArticlesCount(category: category) { (count, error) in
            if(error == nil){
                if(category == "all"){
                    self.totalCount = count!
                }
                //self.totalArticlesLabel.text = "\(count!) of \(self.totalCount) articles"
            }
        }
    }
    
    func loadFirestoreData(category: String){
        print(category)
        let articleRef = defaultStore.collection("articles")
        
        if(category != "All"){
            articleRef
                .whereField("channel", isEqualTo: category)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print(querySnapshot!.count)
                        //self.totalArticlesLabel.text = "\(querySnapshot!.count) of \(self.totalCount) articles"
                    }
            }
        }else{
            articleRef
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print(querySnapshot!.count)
                        self.totalCount = querySnapshot!.count
                        //self.totalArticlesLabel.text = "\(querySnapshot!.count) of \(self.totalCount) articles"
                    }
            }
        }
    }
    
    @IBAction func handleDone(_ sender: Any) {
        if(filterChanged){
            if let delegate = self.delegate {
                var t = ["","","","","","","","","",""]
                if(t == selectedfilter){
                    selectedfilter = ["all","","","","","","","","",""]
                }
                delegate.userDidSelectedFilter(filter: filter, selfilter : selectedfilter, totalCount: totalCount)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableView delegates
extension ArticleFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubFilterCell", for: indexPath) as! SubFilterCell
        cell.selectionStyle = .none
        cell.tintColor = UIColor.black
        if(filters[indexPath.row].selected){
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }else{
            cell.accessoryType = .none
        }
        
        if(selectedfilter[indexPath.row] != ""){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.countsDictionary[filters[indexPath.row].name] as! Int))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.totalArticlesLabel.text = "Please wait"
        if(selectedfilter[indexPath.row] == ""){
            selectedfilter[indexPath.row] = filters[indexPath.row].name
            if(indexPath.row == 0){                
                    selectedfilter = ["all","","","","","","","","",""]
            }
        }else{
            selectedfilter[indexPath.row] = ""
        }
        
        if(indexPath.row > 0){
            selectedfilter[0] = ""
        }
        
        
        
        selectedIndexPath = indexPath
        
        filter = filters[indexPath.row].name
        filterChanged = true
        self.tableView.reloadData()
        //loadTotalArticlesCount(category: filter.lowercased())
        //loadFirestoreData(category: filter)
        
    }
}
