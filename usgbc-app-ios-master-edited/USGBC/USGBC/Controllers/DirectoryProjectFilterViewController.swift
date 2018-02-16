//
//  DirectoryProjectFilterViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 24/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

protocol ProjectFilterDelegate: class {
    func userDidSelectedFilter(filter: String, totalCount: Int, selfilter : [String])
}

class DirectoryProjectFilterViewController: UIViewController {
    var selectedfilter : [String] = ["all","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
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
    var countDict = NSMutableDictionary()
    func loadTotalProjectsCount(){
        var v : [String] = []
        ApiManager.shared.getProjectscounts(callback: {(people, error) in
         print(people)
            var tempdict = NSMutableDictionary()
            if(people != nil && error == nil){
                for item in people!{
                    var s = item as! NSDictionary
                    tempdict[s["key"] as! String] = s["doc_count"] as! Int
                }
                self.countDict = tempdict
                self.tableView.reloadData()
                print(tempdict)
            }else{
                
            }
            
            
        })
//            if(error == nil){
//                if(self.filter == "All"){
//                    self.totalCount = count!
//                }
//                DispatchQueue.main.async {
//                    Utility.hideLoading()
//                }
//                self.totalResultsLabel.text = "\(count!) of \(self.totalCount) projects"
//            }else{
//                DispatchQueue.main.async {
//                    Utility.hideLoading()
//                    Utility.showToast(message: "Something went wrong")
//                }
//            }
        
    }
    
    @IBAction func handleDone(_ sender: Any){
        if(filterChanged){
            if let delegate = self.delegate {
                var t = ["","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
                if(t == selectedfilter){
                    selectedfilter = ["all","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
                }
                delegate.userDidSelectedFilter(filter: filter, totalCount: totalCount, selfilter: self.selectedfilter)//.lowercased()).replacingOccurrences(of: " ", with: "-"))
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
        if(filters[indexPath.row].name == "All"){
            var temp = 0
            for (item,value) in countDict{
                temp += value as! Int
            }
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(temp))"
        }else{
            if(countDict.count > 0 && countDict[filters[indexPath.row].name] != nil){
                cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(countDict[filters[indexPath.row].name] as! Int))"
            }else{
                cell.subFilterLabel.text = "\(filters[indexPath.row].name) (0)"
            }
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
                selectedfilter = ["all","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
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
    }
}
