//
//  DirectoryOrganizationFilterViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 24/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift

protocol OrganizationFilterDelegate: class {
    func userDidSelectedFilter(filter: String, selfilter : [String])
}

class DirectoryOrganizationFilterViewController: UIViewController {

    var filter: String!
    fileprivate var filterChanged = false
    fileprivate var filters: [DirectoryOrganizationFilter] = []
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
    weak var delegate: OrganizationFilterDelegate?
    var totalCount = 0
    var selectedfilter : [String] = ["all","","","","",""]
    var all = 0, education = 0, homes = 0, roundtable = 0, members = 0, regions = 0
    @IBOutlet weak var clearFilterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        DispatchQueue.main.async {
            Utility.showLoading()
            self.loadFilters()
            self.loadOrganizationsCount()
        }
        
    }
    
    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SubFilterCell", bundle: nil), forCellReuseIdentifier: "SubFilterCell")
        tableView.tableFooterView = UIView()
    }
    
    func loadFilters(){
        JsonManager.shared.getDirectoryOrganizationFilters { (filters: [DirectoryOrganizationFilter]?, error: NSError?) in
            if(error == nil){
                self.filters = filters!
                self.filters.filter ({($0.name.lowercased()).replacingOccurrences(of: " ", with: "-") == self.filter}).first?.selected = true
                //self.tableView.reloadData()
            }
        }
    }
    var isloading = false
    func loadOrganizationsCount(){
        var strarr = [String]()
        for str in filters{
            strarr.append(str.name)
        }
        self.filters.removeAll()
        self.tableView.reloadData()
        ApiManager.shared.getDirectoriesCounts(callback: {(organization, error) in
            var organizations = organization! as! NSMutableDictionary
            if(error == nil && organizations.count == 6){
                    print(organizations)
                self.all = organizations["All"] as! Int
                self.education = organizations["education partners"] as! Int
                self.homes = organizations["homes providers"] as! Int
                self.roundtable = organizations["leed international roundtable member"] as! Int
                self.members = organizations["members"] as! Int
                self.regions = organizations["regions"] as! Int
                self.loadFilters()
                DispatchQueue.main.async {
                    Utility.hideLoading()
                    self.tableView.reloadData()
                }
            }else{
                DispatchQueue.main.async {
                    Utility.hideLoading()
                }
            }
          
        })
        /*ApiManager.shared.getOrganizationsCount(category: (filter.lowercased()).replacingOccurrences(of: " ", with: "-")) { count, error in
            if(error == nil){
                self.isloading = false
                Utility.hideLoading()
                if(self.filter == "all"){
                    self.totalCount = count!
                }
                self.totalResultsLabel.text = "\(count!) of \(self.totalCount) organizations"
            }else{
                self.isloading = false
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong")
            }
        }*/
    }
    
    @IBAction func handleDone(_ sender: Any){
        if(filterChanged){
            if let delegate = self.delegate {
                var t = ["","","","","",""]
                if(t == selectedfilter){
                    selectedfilter = ["all","","","","",""]
                }
                delegate.userDidSelectedFilter(filter: (filter.lowercased()).replacingOccurrences(of: " ", with: "-"), selfilter : selectedfilter)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableView delegates
extension DirectoryOrganizationFilterViewController: UITableViewDelegate, UITableViewDataSource {
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
        if(filters[indexPath.row].name.lowercased() == "all"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.all))"
        }else if(filters[indexPath.row].name.lowercased() == "education partners"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.education))"
        }else if(filters[indexPath.row].name.lowercased() == "homes providers"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.homes))"
        }else if(filters[indexPath.row].name.lowercased() == "leed international roundtable member"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.roundtable))"
        }else if(filters[indexPath.row].name.lowercased() == "members"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.members))"
        }else if(filters[indexPath.row].name.lowercased() == "regions"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.regions))"
        }
        
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
        
        return cell
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedfilter[indexPath.row] == ""){
            selectedfilter[indexPath.row] = filters[indexPath.row].name
            if(indexPath.row == 0){
                selectedfilter = ["all","","","","",""]
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
        //self.isloading = true
        //Utility.showLoading()
        //loadOrganizationsCount()
    }
}
