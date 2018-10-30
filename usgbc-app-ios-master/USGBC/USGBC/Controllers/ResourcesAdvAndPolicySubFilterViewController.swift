//
//  ResourcesAdvAndPolicySubFilterViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 24/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

protocol ResourcesAdvAndPolicySubFilterDelegate: class {
    func userDidSelectedSubFilter(filter: ResourcesAdvAndPolicyFilter, changed: Bool, selectedFilter: String,typearray : [String], formatarray : [String], ratingarray :[String], versionarray : [String], accessarray : [String], languagearray : [String])
}

class ResourcesAdvAndPolicySubFilterViewController: UIViewController {
    var filterString: [String] = []
    weak var delegate: ResourcesAdvAndPolicySubFilterDelegate?
    var filter: ResourcesAdvAndPolicyFilter!
    fileprivate var filterChanged = false
    var selectedIndexPath = IndexPath(row: 0, section: 0)

    var typearray : [String] = []
    var formatarray : [String] = []
    var ratingarray : [String] = []
    var versionarray : [String] = []
    var accessarray : [String] = []
    var languagearray : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        print("Filter String")
        filterString.forEach { (temp) in
            print(temp)
        }
    }
    
    func initViews(){
        title = filter.name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SubFilterCell", bundle: nil), forCellReuseIdentifier: "SubFilterCell")
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func handleApply(_ sender: Any){
        if(filterChanged){
            if let delegate = self.delegate {
                delegate.userDidSelectedSubFilter(filter: filter, changed: filterChanged, selectedFilter: filterString.joined(separator: "+"), typearray : typearray, formatarray : formatarray, ratingarray :ratingarray, versionarray: versionarray, accessarray : accessarray, languagearray : languagearray)
            }
        }
        navigationController?.popViewController(animated: true)
        
    }
}

// MARK: UITableView delegates
extension ResourcesAdvAndPolicySubFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter.subFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubFilterCell", for: indexPath) as! SubFilterCell
        cell.selectionStyle = .none
        cell.tintColor = UIColor.black
        var arr : [String] = []
        if(filter.name == "Type"){
            arr = self.typearray
        }else if(filter.name == "Format"){
            arr = self.formatarray
        }else if(filter.name == "Access"){
            arr = self.accessarray
        }else if(filter.name == "Rating System"){
            arr = self.ratingarray
        }else if(filter.name == "Versions"){
            arr = self.versionarray
        }else{
            arr = self.languagearray
        }
        if(arr.contains(filter.subFilters[indexPath.row].name)){
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }else{
            cell.accessoryType = .none
        }
        cell.subFilterLabel.text = filter.subFilters[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(filter.subFilters[indexPath.row])")
        var currentword = String()
        if(filter.subFilters.first(where: { $0.value == filter.subFilters[indexPath.row].value}) != nil){
            var dict = filter.subFilters.first(where: { $0.value == filter.subFilters[indexPath.row].value}) as! ResourcesAdvAndPolicySubFilter
            currentword = dict.name
        }
        
        
        if(filter.name == "Access" || filter.name == "Language"){
            if let cell = tableView.cellForRow(at: selectedIndexPath) {
                cell.accessoryType = .none
                filter.subFilters[selectedIndexPath.row].selected = false
                if((filterString.index(of: filter.subFilters[selectedIndexPath.row].value)) != nil){
                    filterString.remove(at: filterString.index(of: filter.subFilters[selectedIndexPath.row].value)!)
                }
            }
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                filterChanged = true
                filter.subFilters[indexPath.row].selected = true
                if(filterString.count == 1 && (filterString.first?.isEmpty)!){
                    //if(filterString.first?.isEmpty)!{
                    filterString[0] = filter.subFilters[indexPath.row].value
                    //}
                }else{
                    filterString.append(filter.subFilters[indexPath.row].value)
                }
            }
            if(filter.name == "Language"){
                languagearray.removeAll()
                languagearray.append(currentword)
            }else if(filter.name == "Access"){
                accessarray.removeAll()
                accessarray.append(currentword)
            }
            selectedIndexPath = indexPath
        }else{
            if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                filter.subFilters[indexPath.row].selected = false
                filterChanged = true
                //filterString.remove(at: filterString.index(of: filter.subFilters[indexPath.row].value)!)
                if(filter.name == "Type"){
                    if(typearray.contains(currentword)){
                        typearray.remove(at: typearray.index(of: currentword)!)
                    }
                }else if(filter.name == "Format"){
                    if(formatarray.contains(currentword)){
                        formatarray.remove(at: formatarray.index(of: currentword)!)
                    }
                }else if(filter.name == "Rating System"){
                    if(ratingarray.contains(currentword)){
                        ratingarray.remove(at: ratingarray.index(of: currentword)!)
                    }
                }else if(filter.name == "Versions"){
                    if(versionarray.contains(currentword)){
                        versionarray.remove(at: versionarray.index(of: currentword)!)
                    }
                }
            }else{
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                filter.subFilters[indexPath.row].selected = true
                filterChanged = true
                
                if(filter.name == "Type"){
                    typearray.append(currentword)
                }
                else if(filter.name == "Format"){
                    formatarray.append(currentword)
                }else if(filter.name == "Rating System"){
                    ratingarray.append(currentword)
                }else if(filter.name == "Versions"){
                    versionarray.append(currentword)
                }
            }
        }
        print("Selected Filter: ")
        print(filterString.joined(separator: "+"))
    }
}
