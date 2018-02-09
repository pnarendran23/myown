//
//  DirectoryPeopleFilterViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 24/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift

protocol PeopleFilterDelegate: class {
    func userDidSelectedFilter(filter: String)
}

class DirectoryPeopleFilterViewController: UIViewController {

    var filter: String!
    fileprivate var filterChanged = false
    fileprivate var filters: [DirectoryPeopleFilter] = []
    weak var delegate: PeopleFilterDelegate?
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
    var totalCount = 0
    
    @IBOutlet weak var totalResultsLabel: UILabel!
    @IBOutlet weak var clearFilterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var all = 0, chapter_members = 0, experts = 0, leed_fellows = 0, member_employees = 0, usgbc_faculty = 0, usgbc_staff = 0, usgbc_students = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loadFilters()
        loadPeopleCount()
    }
    
    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SubFilterCell", bundle: nil), forCellReuseIdentifier: "SubFilterCell")
        tableView.tableFooterView = UIView()
        
    }
    
    func loadFilters(){
        JsonManager.shared.getDirectoryPeopleFilters { (filters: [DirectoryPeopleFilter]?, error: NSError?) in
            if(error == nil){
                self.filters = filters!
                self.filters.filter ({($0.name.lowercased()).replacingOccurrences(of: " ", with: "-") == self.filter}).first?.selected = true
                //self.tableView.reloadData()
            }
        }
    }
    
    
    
    func loadPeopleCount(){
        
        var strarr = [String]()
        for str in filters{
            if(str.name == "experts"){
                strarr.append("all/all/expert")
            }else if(str.name == "usgbc staffs"){
                strarr.append("all/all/usgbc-staff")
            }else if(str.name == "leed fellows"){
                strarr.append("all/all/leed-fellow")
            }else if(str.name == "usgbc students"){
                strarr.append("all/all/usgbc-student")
            }else{
                strarr.append(str.name)
            }
        }
        self.filters.removeAll()
        self.tableView.reloadData()
        ApiManager.shared.getdirectorycounts(category : "peoplelist", strarr :strarr, callback: {(people, error) in
                var people = people! as! NSMutableDictionary
                if(error == nil && people.count == strarr.count){
                    print(people)
                    self.all = people["all"] as! Int
                    self.chapter_members = people["chapter-members"] as! Int
                    self.experts = people["experts"] as! Int
                    self.leed_fellows = people["leed-fellows"] as! Int
                    self.member_employees = people["member-employees"] as! Int
                    self.usgbc_faculty = people["usgbc-faculty"] as! Int
                    self.usgbc_staff = people["usgbc-staff"] as! Int
                    self.usgbc_students = people["usgbc-students"] as! Int
//                    self.all = organizations["all"] as! Int
//                    self.education = organizations["education-partners"] as! Int
//                    self.homes = organizations["homes-providers"] as! Int
//                    self.roundtable = organizations["leed-international-roundtable-member"] as! Int
//                    self.members = organizations["members"] as! Int
//                    self.regions = organizations["regions"] as! Int
                    self.loadFilters()
                    self.tableView.reloadData()
                }else{
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                    }
                }

            })
//        ApiManager.shared.getPeopleCount(category: filter) { count, error in
//            if(error == nil){
//                if(self.filter == "all"){
//                    self.totalCount = count!
//                }
//                self.totalResultsLabel.text = "\(count!) of \(self.totalCount) people"
//            }
//        }
    }
    
    @IBAction func handleDone(_ sender: Any){
        if(filterChanged){
            if let delegate = self.delegate {
                delegate.userDidSelectedFilter(filter: (filter.lowercased()).replacingOccurrences(of: " ", with: "-"))
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableView delegates
extension DirectoryPeopleFilterViewController: UITableViewDelegate, UITableViewDataSource {
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
        }else if(filters[indexPath.row].name.lowercased() == "chapter members"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.chapter_members))"
        }else if(filters[indexPath.row].name.lowercased() == "member employees"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.member_employees))"
        }else if(filters[indexPath.row].name.lowercased() == "experts"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.experts))"
        }else if(filters[indexPath.row].name.lowercased() == "usgbc faculty"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.usgbc_faculty))"
        }else if(filters[indexPath.row].name.lowercased() == "usgbc students"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.usgbc_students))"
        }else if(filters[indexPath.row].name.lowercased() == "usgbc staff"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.usgbc_staff))"
        }else if(filters[indexPath.row].name.lowercased() == "leed fellows"){
            cell.subFilterLabel.text = "\(filters[indexPath.row].name) (\(self.leed_fellows))"
        }
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
        filter = filters[indexPath.row].name
        filterChanged = true
        loadPeopleCount()
    }
}
