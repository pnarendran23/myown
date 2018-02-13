//
//  CreditFilterViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 24/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift

protocol CreditFilterDelegate: class {
    func userDidSelectedFilter(filter: String, totalCount: Int, category : String, selfiter : [String])
}

class CreditFilterViewController: UIViewController {
    var category = ""
    var selectedfilter : [String] = ["all","","","","","","","","","","","","",""]
    var filter: String!
    fileprivate var filters: [CreditFilter] = []
    fileprivate var filterChanged = false
    weak var delegate: CreditFilterDelegate?
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    //@IBOutlet weak var totalResultsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var totalCount = 0
    var countsDictionary : NSMutableDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadTotalCreditsCount()
        DispatchQueue.main.async {
            Utility.showLoading()
            self.getcounts()
            //self.totalResultsLabel.text = ""
        }
    }
    
    func getcounts(){
        ApiManager.shared.getCreditsCounts(cat : "ss") { (dict, error) in
            if(error == nil){
                print(dict)
                self.countsDictionary = dict
                self.loadFilters()
                Utility.hideLoading()
                print(self.countsDictionary)
                self.initViews()
                self.loadFilters()
                DispatchQueue.main.async {
                    Utility.hideLoading()
                }
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
    
    func loadFilters(){
        JsonManager.shared.getCreditFilters { (filters: [CreditFilter]?, error: NSError?) in
            if(error == nil){
                self.filters = filters!
                self.filters.filter ({($0.name.lowercased()).replacingOccurrences(of: " ", with: "-") == self.filter}).first?.selected = true
                self.tableView.reloadData()
            }
        }
    }
    
    func loadTotalCreditsCount(){
        ApiManager.shared.getCreditsCount(rating: "all", version: "all", credit: (filter.lowercased()).replacingOccurrences(of: " ", with: "-"), callback: { (count, error) in
            if(error == nil){
                if(self.filter == "all"){
                    self.totalCount = count!
                }
                //self.totalResultsLabel.text = "\(count!) of \(self.totalCount) credits"
            }
        })
    }
    
    
    
    @IBAction func handleDone(){
        if(filterChanged){
            if let delegate = self.delegate {
                delegate.userDidSelectedFilter(filter: (filter.lowercased()).replacingOccurrences(of: " ", with: "-"), totalCount: totalCount, category : category, selfiter:  self.selectedfilter )
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableView delegates
extension CreditFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.subFilterLabel.text = filters[indexPath.row].name + " (\(countsDictionary[filters[indexPath.row].name]!))"
        if(selectedfilter[indexPath.row] != ""){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedfilter[indexPath.row] == ""){
            selectedfilter[indexPath.row] = filters[indexPath.row].name
        }else{
            selectedfilter[indexPath.row] = ""
        }
        selectedIndexPath = indexPath
        
        filter = filters[indexPath.row].name
        filterChanged = true
        self.tableView.reloadData()
    }
}
