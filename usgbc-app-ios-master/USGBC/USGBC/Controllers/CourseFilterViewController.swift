//
//  EducationFilterViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 21/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

protocol CourseFilterDelegate: class {
    func userDidSelectedFilter(filters: [CourseFilter], changed: Bool, playlists: String, courseFeature: String, continuingEducation: String, ratingSystemVersion: String, leedCreditCategory: String, courseFormat: String, courseLevel: String, courseLanguage: String,  continuousarray : NSMutableArray, versionarrar : NSMutableArray, categoryarray : NSMutableArray, formatarray : NSMutableArray,levelarray : NSMutableArray,languagearr : NSMutableArray)
}

class CourseFilterViewController: UIViewController {
    var continuousarray = NSMutableArray()
    var versionarrar = NSMutableArray()
    var categoryarray = NSMutableArray()
    var formatarray = NSMutableArray()
    var levelarray = NSMutableArray()
    var languagearr = NSMutableArray()
    
    var filters: [CourseFilter] = []
    weak var delegate: CourseFilterDelegate?
    fileprivate var filterChanged = false
    @IBOutlet weak var totalResultsLabel: UILabel!
    @IBOutlet weak var clearFilterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var playlists = ""
    var courseFeature = ""
    var continuingEducation = ""
    var ratingSystemVersion = ""
    var leedCreditCategory = ""
    var courseFormat = ""
    var courseLevel = ""
    var courseLanguage = ""
    var selectedFilter = ""
    var filter = "all/all/all/all/all/all/all"
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loadTotalCoursesCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    func initViews(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        tableView.tableFooterView = UIView()
        
        filters.forEach { (temp) in
            print(temp)
        }
    }
    
    @IBAction func handleDone(_ sender: Any) {
        if(filterChanged){
            if let delegate = self.delegate {
                delegate.userDidSelectedFilter(filters: filters, changed: filterChanged, playlists: playlists, courseFeature: courseFeature, continuingEducation: continuingEducation, ratingSystemVersion: ratingSystemVersion, leedCreditCategory: leedCreditCategory, courseFormat: courseFormat, courseLevel: courseLevel, courseLanguage: courseLanguage,  continuousarray : self.continuousarray, versionarrar : self.versionarrar, categoryarray : self.categoryarray, formatarray : self.formatarray,levelarray : self.levelarray,languagearr : self.languagearr)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleClearFilter(_ sender: Any) {
        if(self.filter != "all/all/all/all/all/all/all"){
            filter = "all/all/all/all/all/all/all"
            playlists = ""
            courseFeature = ""
            continuingEducation = ""
            ratingSystemVersion = ""
            leedCreditCategory = ""
            courseFormat = ""
            courseLevel = ""
            courseLanguage = ""
            self.continuousarray = NSMutableArray()
            self.versionarrar = NSMutableArray()
            self.levelarray = NSMutableArray()
            self.categoryarray = NSMutableArray()
            self.formatarray = NSMutableArray()
            self.languagearr = NSMutableArray()
            filters.forEach({ courseFilter in
                courseFilter.subFilters.forEach({ courseSubFilter in
                    courseSubFilter.selected = false
                })
            })
            //selectedFilter = ""
            loadTotalCoursesCount()
        }
    }
    
    func loadTotalCoursesCount(){
        
        
        if(courseLevel.characters.count == 0){
            filter = "all"
        }else{
            filter = courseLevel
        }
        
        if(continuingEducation.characters.count == 0){
            filter = self.filter + "/" + "all"
        }else{
            filter = self.filter + "/" + continuingEducation
        }
        
        if(ratingSystemVersion.characters.count == 0){
            filter = self.filter + "/" +  "all"
        }else{
            filter = self.filter + "/" + ratingSystemVersion
        }
        
        if(leedCreditCategory.characters.count == 0){
            filter = self.filter + "/" + "all"
        }else{
            filter = self.filter + "/" + leedCreditCategory
        }
        
        if(courseFormat.characters.count == 0){
            filter = self.filter + "/" + "all"
        }else{
            filter = self.filter + "/" + courseFormat
        }
        
        if(courseLanguage.characters.count == 0){
            filter = self.filter + "/" + "all"
        }else{
            filter = self.filter + "/" + courseLanguage
        }
        
        if(courseFeature.characters.count == 0){
            filter = self.filter + "/" + "all"
        }else{
            filter = self.filter + "/" + courseFeature
        }
        
        
        //filter = ((courseLevel.isEmpty) ? "all" : courseLevel) + "/" + ((continuingEducation.isEmpty) ? "all" : continuingEducation) + "/" + ((ratingSystemVersion.isEmpty) ? "all" : ratingSystemVersion) + "/" + ((leedCreditCategory.isEmpty) ? "all" : leedCreditCategory) + "/" + ((courseFormat.isEmpty) ? "all" : courseFormat) + "/" + ((courseLanguage.isEmpty) ? "all" : courseLanguage) + "/" + ((courseFeature.isEmpty) ? "all" : courseFeature)
        Utility.showLoading()
        var parameter = Payloads().makePayloadForCourses(continuousarr: continuousarray, versionarr: versionarrar, categoryarr: categoryarray, formatarr: formatarray, levelarr: levelarray, languagearr: languagearr)
        
        ApiManager.shared.getCourseCount(category: filter, parameter: parameter, callback: { (count, error) in
            if(error == nil){
                if(self.filter == "all/all/all/all/all/all/all"){
                    self.totalCount = count!
                }
                Utility.hideLoading()
                self.totalResultsLabel.text = "\(count!) of \(self.totalCount) courses"
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CourseSubFilterViewController" {
            if let viewController = segue.destination as? CourseSubFilterViewController {
                viewController.delegate = self
                viewController.filter = sender as! CourseFilter
                if(!selectedFilter.isEmpty){
                    viewController.filterString = selectedFilter.components(separatedBy: "+")
                    viewController.continuousarray = self.continuousarray
                    viewController.formatarray = self.formatarray
                    viewController.versionarrar = self.versionarrar
                    viewController.languagearr = self.languagearr
                    viewController.levelarray = self.levelarray
                    viewController.categoryarray = self.categoryarray
                }
            }
        }
    }
}

//MARK: UITableView delegates
extension CourseFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.filterLabel.text = filters[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch filters[indexPath.row].name {
        case "Playlists":
            selectedFilter = playlists
        case "Course features":
            selectedFilter = courseFeature
        case "Continuing education":
            selectedFilter = continuingEducation
        case "Rating system version":
            selectedFilter = ratingSystemVersion
        case "LEED credit category":
            selectedFilter = leedCreditCategory
        case "Course format":
            selectedFilter = courseFormat
        case "Course level":
            selectedFilter = courseLevel
        case "Course language":
            selectedFilter = courseLanguage
        default: break
        }
        selectedFilter = "a"
        print(selectedFilter)
        performSegue(withIdentifier: "CourseSubFilterViewController", sender: filters[indexPath.row])
    }
}

extension CourseFilterViewController: CourseSubFilterDelegate {
    func userDidSelectedSubFilter(filter: CourseFilter, changed: Bool,  selectedFilter filterString: String, continuousarray : NSMutableArray, versionarrar : NSMutableArray, categoryarray : NSMutableArray, formatarray : NSMutableArray,levelarray : NSMutableArray,languagearr : NSMutableArray) {
        if(changed){
            filters[filters.index(of: filter)!] = filter
            switch filter.name {
            case "Playlists":
                playlists = filterString
            case "Course features":
                courseFeature = filterString
            case "Continuing education":
                continuingEducation = filterString
            case "Rating system version":
                ratingSystemVersion = filterString
            case "LEED credit category":
                leedCreditCategory = filterString
            case "Course format":
                courseFormat = filterString
            case "Course level":
                courseLevel = filterString
            case "Course language":
                courseLanguage = filterString
            default: break
            }
            print("CourseSubFilterDelegate")
            print(filterString)
            filterChanged = true
            
            if(courseLevel.characters.count == 0){
                self.filter = "all"
            }else{
                self.filter = courseLevel
            }
            
            if(continuingEducation.characters.count == 0){
                self.filter = self.filter + "/" + "all"
            }else{
                self.filter = self.filter + "/" + continuingEducation
            }
            
            if(ratingSystemVersion.characters.count == 0){
                self.filter = self.filter + "/" +  "all"
            }else{
                self.filter = self.filter + "/" + ratingSystemVersion
            }
            
            if(leedCreditCategory.characters.count == 0){
                self.filter = self.filter + "/" + "all"
            }else{
                self.filter = self.filter + "/" + leedCreditCategory
            }
            
            if(courseFormat.characters.count == 0){
                self.filter = self.filter + "/" + "all"
            }else{
                self.filter = self.filter + "/" + courseFormat
            }
            
            if(courseLanguage.characters.count == 0){
                self.filter = self.filter + "/" + "all"
            }else{
                self.filter = self.filter + "/" + courseLanguage
            }
            
            if(courseFeature.characters.count == 0){
                self.filter = self.filter + "/" + "all"
            }else{
                self.filter = self.filter + "/" + courseFeature
            }
            self.categoryarray = categoryarray
            self.continuousarray = continuousarray
            self.levelarray = levelarray
            self.formatarray = formatarray
            self.languagearr = languagearr
            self.versionarrar = versionarrar
            //self.filter = ((courseLevel.isEmpty) ? "all" : courseLevel) + "/" + ((continuingEducation.isEmpty) ? "all" : continuingEducation) + "/" + ((ratingSystemVersion.isEmpty) ? "all" : ratingSystemVersion) + "/" + ((leedCreditCategory.isEmpty) ? "all" : leedCreditCategory) + "/" + ((courseFormat.isEmpty) ? "all" : courseFormat) + "/" + ((courseLanguage.isEmpty) ? "all" : courseLanguage) + "/" + ((courseFeature.isEmpty) ? "all" : courseFeature)
            loadTotalCoursesCount()
        }
    }
}
