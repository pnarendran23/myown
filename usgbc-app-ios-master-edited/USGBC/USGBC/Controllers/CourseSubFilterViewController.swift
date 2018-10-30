//
//  CourseSubFilterViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 21/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

protocol CourseSubFilterDelegate: class {
    func userDidSelectedSubFilter(filter: CourseFilter, changed: Bool, selectedFilter: String, continuousarray : NSMutableArray, versionarrar : NSMutableArray, categoryarray : NSMutableArray, formatarray : NSMutableArray,levelarray : NSMutableArray,languagearr : NSMutableArray)
}

class CourseSubFilterViewController: UIViewController {
    var continuousarray = NSMutableArray()
    var versionarrar = NSMutableArray()
    var categoryarray = NSMutableArray()
    var formatarray = NSMutableArray()
    var levelarray = NSMutableArray()
    var languagearr = NSMutableArray()
    
    var filter: CourseFilter!
    weak var delegate: CourseSubFilterDelegate?
    fileprivate var filterChanged = false
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var filterString: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews(){
        title = filter.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SubFilterCell", bundle: nil), forCellReuseIdentifier: "SubFilterCell")
        tableView.tableFooterView = UIView()
        print(filter)
    }

    @IBAction func hanldeApply(){
        if(filterChanged){
            if let delegate = self.delegate {
                delegate.userDidSelectedSubFilter(filter: filter, changed: filterChanged, selectedFilter: filterString.joined(separator: "+"), continuousarray : self.continuousarray, versionarrar : self.versionarrar, categoryarray : self.categoryarray, formatarray : self.formatarray,levelarray : self.levelarray,languagearr : self.languagearr)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UITableView delegates
extension CourseSubFilterViewController: UITableViewDelegate, UITableViewDataSource {
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
        var arr = NSMutableArray()
        if(filter.name == "Continuing education"){
            arr = self.continuousarray
        }else if(filter.name == "Rating system version"){
            arr = self.versionarrar
        }else if(filter.name == "LEED credit category"){
            arr = self.categoryarray
        }else if(filter.name == "Course format"){
            arr = self.formatarray
        }else if(filter.name == "Course level"){
            arr = self.levelarray
        }else{
            arr = self.languagearr
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
        
        var currentword = String()
        if(filter.subFilters.first(where: { $0.value == filter.subFilters[indexPath.row].value}) != nil){
            var dict = filter.subFilters.first(where: { $0.value == filter.subFilters[indexPath.row].value}) as! CourseSubFilter
            currentword = dict.name
        }
        
        
        
        if(filter.name == "Playlists" || filter.name == "Course language"){
            if let cell = tableView.cellForRow(at: selectedIndexPath) {
                cell.accessoryType = .none
                //filter.subFilters[selectedIndexPath.row].selected = false
                
            }
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                filterChanged = true
                filter.subFilters[indexPath.row].selected = true
                
            }
            if(filter.name == "Course language"){
                self.languagearr.removeAllObjects()
                self.languagearr.add(currentword)
            }
            
            selectedIndexPath = indexPath
        }else{
            if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                filter.subFilters[indexPath.row].selected = false
                filterChanged = true
                //filterString.remove(at: filterString.index(of: filter.subFilters[indexPath.row].value)!)
                
                if(filter.name == "Continuing education"){
                    if(self.continuousarray.contains(currentword)){
                        self.continuousarray.removeObject(at: self.continuousarray.index(of: currentword))
                    }
                }else if(filter.name == "Rating system version"){
                    if(versionarrar.contains(currentword)){
                        self.versionarrar.removeObject(at: self.versionarrar.index(of: currentword))
                    }
                }else if(filter.name == "LEED credit category"){
                    if(categoryarray.contains(currentword)){
                        self.categoryarray.removeObject(at: self.categoryarray.index(of: currentword))
                    }
                }else if(filter.name == "Course format"){
                    if(formatarray.contains(currentword)){
                        self.formatarray.removeObject(at: self.formatarray.index(of: currentword))
                    }
                }else if(filter.name == "Course level"){
                    if(levelarray.contains(currentword)){
                        self.levelarray.removeObject(at: self.levelarray.index(of: currentword))
                    }
                }
                
            }else{
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                filter.subFilters[indexPath.row].selected = true
                filterChanged = true
                if(filterString.count == 1 && (filterString.first?.isEmpty)!){
                    //if(filterString.first?.isEmpty)!{
                        filterString[0] = filter.subFilters[indexPath.row].value
                    //}
                }else{
                    filterString.append(filter.subFilters[indexPath.row].value)
                }
                
                if(filter.name == "Continuing education"){
                    self.continuousarray.add(currentword)
                }else if(filter.name == "Rating system version"){
                    self.versionarrar.add(currentword)
                }else if(filter.name == "LEED credit category"){
                    self.categoryarray.add(currentword)
                }else if(filter.name == "Course format"){
                    self.formatarray.add(currentword)
                }else if(filter.name == "Course level"){
                  self.levelarray.add(currentword)
                }
            }
            
          
        }
        print("Selected Filter: ")
        print(filterString.joined(separator: "+"))
    }
}
