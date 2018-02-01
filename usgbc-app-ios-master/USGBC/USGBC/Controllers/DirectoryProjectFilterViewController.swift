//
//  DirectoryProjectFilterViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 24/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

protocol ProjectFilterDelegate: class {
    func userDidSelectedFilter(filter: String, totalCount: Int)
}

class DirectoryProjectFilterViewController: UIViewController {
    
    var filter: String!
    weak var delegate: ProjectFilterDelegate?
    fileprivate var filterChanged = false
    fileprivate var filters: [DirectoryProjectFilter] = []
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var totalResultsLabel: UILabel!
    @IBOutlet weak var clearFilter: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loadFilters()
        loadTotalProjectsCount()
    }

    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SubFilterCell", bundle: nil), forCellReuseIdentifier: "SubFilterCell")
        tableView.tableFooterView = UIView()
        
    }

    func loadFilters(){
        JsonManager.shared.getDirectoryProjectFilters { (filters: [DirectoryProjectFilter]?, error: NSError?) in
            if(error == nil){
                self.filters = filters!
//                self.filters.filter ({($0.name.lowercased()).replacingOccurrences(of: " ", with: "-") == self.filter}).first?.selected = true
                //self.filters.filter ({($0.value) == self.filter}).first?.selected = true
                self.filters.filter ({($0.name) == self.filter}).first?.selected = true
                self.tableView.reloadData()
            }
        }
    }
    
    func loadTotalProjectsCount(){
        ApiManager.shared.getProjectsCount(category: filter, callback: { (count, error) in
            if(error == nil){
                if(self.filter == "All"){
                    self.totalCount = count!
                }
                self.totalResultsLabel.text = "\(count!) of \(self.totalCount) projects"
            }
        })
    }
    
    @IBAction func handleDone(_ sender: Any){
        if(filterChanged){
            if let delegate = self.delegate {
                delegate.userDidSelectedFilter(filter: filter, totalCount: totalCount)//.lowercased()).replacingOccurrences(of: " ", with: "-"))
                //delegate.userDidSelectedFilter(filter: filter)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableView delegates
extension DirectoryProjectFilterViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.subFilterLabel.text = filters[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: selectedIndexPath) {
            cell.accessoryType = .none
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        selectedIndexPath = indexPath
        //filter = filters[indexPath.row].value
        filter = filters[indexPath.row].name
        filterChanged = true
        loadTotalProjectsCount()
    }
}
