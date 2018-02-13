//
//  ResourcesAdvAndPolicyFilterViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 24/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

protocol ResourcesAdvAndPolicyFilterDelegate: class {
    func userDidSelectedFilter(filters: [ResourcesAdvAndPolicyFilter], changed: Bool, type: String, format: String, ratingSystem: String, versions: String, access: String, language: String, totalCount: Int, typearray : [String], formatarray : [String], ratingarray : [String], versionarray : [String], accessarray : [String], languagearray : [String])
}

class ResourcesAdvAndPolicyFilterViewController: UIViewController {
    
    var filters: [ResourcesAdvAndPolicyFilter] = []
    weak var delegate: ResourcesAdvAndPolicyFilterDelegate?
    fileprivate var filterChanged = false
    var typearray : [String] = []
    var formatarray : [String] = []
    var ratingarray : [String] = []
    var versionarray : [String] = []
    var accessarray : [String] = []
    var languagearray : [String] = []
    var type: String = ""
    var format: String = ""
    var ratingSystem: String = ""
    var versions: String = ""
    var access: String = ""
    var language: String = ""
    var selectedFilter = ""
    var filter = "4937+1231+7386+1236+6/all/all/all/all/all"
    var totalCount = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalResultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loadResourcesLeedCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        self.tableView.reloadData()
    }
    
    func initViews(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        tableView.tableFooterView = UIView()
    }
    
    func loadResourcesLeedCount(){
 let parameter = Payloads().makePayloadForResources(typearray: typearray, formatarray: formatarray, ratingarray: ratingarray, versionarray: versionarray, accessarray: accessarray, languagearray: languagearray, currentcategory : "adv")
        print(parameter)
        filter = ((type.isEmpty) ? "all" : type) + "/" + ((ratingSystem.isEmpty) ? "all" : ratingSystem) + "/" + ((versions.isEmpty) ? "all" : versions) + "/" + ((language.isEmpty) ? "all" : language) + "/" + ((format.isEmpty) ? "all" : format) +  "/" + ((access.isEmpty) ? "all" : access)
        print(filter)
        ApiManager.shared.getResourcesCount(category: filter, parameter:  parameter) { count, error in
            if(error == nil){
                if(parameter == ""){
                    self.totalCount = count!
                }
                self.totalResultsLabel.text = "\(count!) of \(self.totalCount) resources"
            }
        }
    }
    
    @IBAction func handleClearFilter(_ sender: Any) {
            filter = "4937+1231+7386+1236+6/all/all/all/all/all"
            type = "4937+1231+7386+1236+6"
            format = ""
            ratingSystem = ""
            versions = ""
            access = ""
            language = ""
            filters.forEach({ resourceFilter in
                if(resourceFilter.name != "Type"){
                    resourceFilter.subFilters.forEach({ resourceSubFilter in
                        resourceSubFilter.selected = false
                    })
                }else{
                    resourceFilter.subFilters.forEach({ resourceSubFilter in
                        resourceSubFilter.selected = true
                    })
                }
            })
            self.filterChanged = true
            self.typearray = ["Advocacy briefs","LEED case studies","Market briefs","Public policies","Reports"]
            self.formatarray = []
            self.ratingarray = []
            self.versionarray = []
            self.accessarray = []
            self.languagearray = []
            loadResourcesLeedCount()
    }
    
    @IBAction func handleDone(_ sender: Any){
        if(filterChanged){
            if let delegate = self.delegate {
                delegate.userDidSelectedFilter(filters: filters, changed: filterChanged, type: type, format: format, ratingSystem: ratingSystem, versions: versions, access: access, language: language,  totalCount: totalCount, typearray : typearray, formatarray : formatarray, ratingarray :ratingarray, versionarray: versionarray,   accessarray : accessarray, languagearray : languagearray)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResourcesAdvAndPolicySubFilterViewController" {
            if let viewController = segue.destination as? ResourcesAdvAndPolicySubFilterViewController {
                viewController.filter = sender as! ResourcesAdvAndPolicyFilter
                viewController.delegate = self
                viewController.typearray = self.typearray
                viewController.formatarray = self.formatarray
                viewController.ratingarray = self.ratingarray
                viewController.accessarray = self.accessarray
                viewController.versionarray = self.versionarray
                viewController.languagearray = self.languagearray
                if(!selectedFilter.isEmpty){
                    viewController.filterString = selectedFilter.components(separatedBy: "+")
                }
            }
        }
    }
}

//MARK: UITableView delegates
extension ResourcesAdvAndPolicyFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var temp = [String]()
        if(indexPath.row == 0){
            temp = self.typearray
        }else if(indexPath.row == 1){
            temp = self.formatarray
        }else if(indexPath.row == 2){
            temp = self.ratingarray
        }else if(indexPath.row == 3){
            temp = self.versionarray
        }else if(indexPath.row == 4){
            temp = self.accessarray
        }else if(indexPath.row == 5){
            temp = self.languagearray
        }
        if(temp.count > 0){
            var str = temp.joined(separator: ", ")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            cell.textLabel?.text = filters[indexPath.row].name
            cell.detailTextLabel?.text = str
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.filterLabel.text = filters[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch filters[indexPath.row].name {
        case "Type":
            selectedFilter = type
        case "Format":
            selectedFilter = format
        case "Rating System":
            selectedFilter = ratingSystem
        case "Versions":
            selectedFilter = versions
        case "Access":
            selectedFilter = access
        case "Language":
            selectedFilter = language
        default: break
        }
        print(selectedFilter)
        performSegue(withIdentifier: "ResourcesAdvAndPolicySubFilterViewController", sender: filters[indexPath.row])
    }
}

extension ResourcesAdvAndPolicyFilterViewController: ResourcesAdvAndPolicySubFilterDelegate {
    func userDidSelectedSubFilter(filter: ResourcesAdvAndPolicyFilter, changed: Bool,  selectedFilter filterString: String, typearray : [String], formatarray : [String], ratingarray :[String], versionarray : [String], accessarray : [String], languagearray : [String]) {
        if(changed){
            filters[filters.index(of: filter)!] = filter
            switch filter.name {
            case "Type":
                type = filterString
            case "Format":
                format = filterString
            case "Rating System":
                ratingSystem = filterString
            case "Versions":
                versions = filterString
            case "Access":
                access = filterString
            case "Language":
                language = filterString
            default: break
            }
            self.typearray = typearray
            self.formatarray = formatarray
            self.accessarray = accessarray
            self.ratingarray = ratingarray
            self.versionarray = versionarray
            self.languagearray = languagearray            
            print("ResourcesAdvAndPolicySubFilterDelegate")
            print(filterString)
            filterChanged = true
            self.filter = ((type.isEmpty) ? "all" : type) + "/" + ((ratingSystem.isEmpty) ? "all" : ratingSystem) + "/" + ((versions.isEmpty) ? "all" : versions) + "/" + ((language.isEmpty) ? "all" : language) + "/" + ((format.isEmpty) ? "all" : format) +  "/" + ((access.isEmpty) ? "all" : access)
            loadResourcesLeedCount()
        }
    }
}
