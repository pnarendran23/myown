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
    func userDidSelectedFilter(filter: String, totalCount: Int)
}

class ArticleFilterViewController: UIViewController {

    var filter: String!
    weak var delegate: ArticleFilterDelegate?
    fileprivate var filterChanged = false
    fileprivate var filters: [ArticleFilter] = []
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
    var totalCount = 0
    let defaultStore = Firestore.firestore()
    var countsDictionary : NSMutableDictionary!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalArticlesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            Utility.showLoading()
            self.totalArticlesLabel.text = ""
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
                delegate.userDidSelectedFilter(filter: filter/*(filter.lowercased()).replacingOccurrences(of: " ", with: "-")*/, totalCount: totalCount)
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
        cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.countsDictionary[filters[indexPath.row].name] as! Int))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.totalArticlesLabel.text = "Please wait"
        if let cell = tableView.cellForRow(at: selectedIndexPath) {
            cell.accessoryType = .none
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        selectedIndexPath = indexPath
        filter = filters[indexPath.row].name
        filterChanged = true
        //loadTotalArticlesCount(category: filter.lowercased())
        //loadFirestoreData(category: filter)
        
    }
}
