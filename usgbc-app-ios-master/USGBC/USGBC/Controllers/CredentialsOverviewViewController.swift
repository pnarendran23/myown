//
//  CredentialsOverviewViewControllerNew.swift
//  USGBC
//
//  Created by Vishal Raj on 16/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON
import HGPlaceholders

class CredentialsOverviewViewController: UIViewController {
    //var placeholderTableView: TableView?
    var selectedOption = ""
    var reportedHours: Float = 0.0
    var approvedHours: Float = 0.0
    var bdcReportedHours: Float = 0.0
    var selected_array = CEActivity()
    var bdcApprovedHours: Float = 0.0
    var ceActivities: [CEActivity] = []
    var credentials = Credentials()
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            Utility.showLoading()
            self.getCredentials()
        }
        initViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "CE History"
        loadCredentials()
    }
    
    //MARK: Initialize UI controls
    func initViews(){
        view.backgroundColor = UIColor.hex(hex: Colors.listBack)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //placeholderTableView = tableView as? TableView
        //placeholderTableView?.placeholderDelegate = self
    }
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Load JSON from file
    func getCredentials(){
        Utility.showLoading()
        ApiManager.shared.getCredentials(email: Utility().getUserDetail(), callback: { (credentials, error) in
            if(error == nil){
                DispatchQueue.main.async {
                    Utility.hideLoading()
                if(credentials != nil){
                    self.credentials = credentials!
                    
                }else{
                    
                }
                }
            }else{
                DispatchQueue.main.async {
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong!")
                }
            }
        })
    }
    
    func loadCredentials(){
        Utility.showLoading()
        ApiManager.shared.getCEActivities(email: Utility().getUserDetail()) { (ceActivities, error) in
            if(error == nil){
                DispatchQueue.main.async{
                    Utility.hideLoading()
                }
                self.ceActivities = ceActivities!
                if(self.ceActivities.count > 0){
                    print("CE Activities count if: \(self.ceActivities.count)")
                    self.tableView.reloadData()
                }else{
                    print("CE Activities count else: \(self.ceActivities.count)")
                    //Utility.showToast(message: "No results found")
                    //let key = PlaceholderKey.custom(key: "starWars")
                    //self.placeholderTableView?.showCustomPlaceholder(with: key)
                    //self.placeholderTableView?.showNoResultsPlaceholder()
                }
            }else{
                DispatchQueue.main.async{
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong!")
                }
            }
        }
    }
}

//MARK: UITableView delegates
extension CredentialsOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction  = UITableViewRowAction(style: .normal , title: "Edit") { (rowAction, indexPath) in
            print("Share Button tapped. Row item value = \(indexPath.row)")
//            switch radioButton.tag {
//            case 1:
//                self.selectedOption = "ReportCEHourAuthorshipViewController"
//            case 2:
//                self.selectedOption = "ReportCeHourEducationViewController"
//            case 3:
//                self.selectedOption = "ReportCeHourProjectExperienceViewController"
//            case 4:
//                self.selectedOption = "ReportCEHourVolunteerWorkViewController"
//            default: break
//            }
//            self.didSelecedRadioButton = true
        
                //performSegue(withIdentifier: selectedOption, sender: self)
            self.selectedOption = ""
            if(self.ceActivities[indexPath.row].field_ce_act_type_value.lowercased().contains("authorship")){
                self.selectedOption = "ReportCEHourAuthorshipViewController"
            }else if(self.ceActivities[indexPath.row].field_ce_act_type_value.lowercased().contains("education")){
                self.selectedOption = "ReportCeHourEducationViewController"
            }else if(self.ceActivities[indexPath.row].field_ce_act_type_value.lowercased().contains("project experience")){
                //self.selectedOption = "ReportCeHourProjectExperienceViewController"
            }else if(self.ceActivities[indexPath.row].field_ce_act_type_value.lowercased().contains("volunteer work")){
                self.selectedOption = "ReportCEHourVolunteerWorkViewController"
            }
            if(self.selectedOption != ""){
                self.selected_array = self.ceActivities[indexPath.row]
                self.performSegue(withIdentifier: self.selectedOption, sender: nil)
            }
            //self.displayShareSheet(indexPath)
        }
        let deleteAction  = UITableViewRowAction(style: .destructive , title: "Delete") { (rowAction, indexPath) in
            print("Delete Button tapped. Row item value = \(indexPath.row)")
        }
        //shareAction.backgroundColor = UIColor.green
        return [deleteAction,editAction]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ReportCEHourAuthorshipViewController"){
            var v = segue.destination as! ReportCEHourAuthorshipViewController
            v.edit = true
            v.ceReport.start_date = self.selected_array.field_ce_course_from_date_value
            v.ceReport.end_date = self.selected_array.field_ce_course_to_date_value
            v.ceReport.title = self.selected_array.field_ce_course_title_value
            v.ceReport.provider = self.selected_array.field_ce_course_provider_value
            v.ceReport.hours = self.selected_array.field_ce_hours_reported_value
            v.ceReport.description = self.selected_array.field_ce_course_desc_value
            v.ceReport.url = self.selected_array.field_ce_url_value
            v.ceReport.Nid = self.selected_array.Nid
            v.cred_specific_record = credentials.cred_specific_record
        }else if(segue.identifier == "ReportCeHourEducationViewController"){
            var v = segue.destination as! ReportCeHourEducationViewController
            v.edit = true
            v.ceReport.course_id = self.selected_array.field_ce_course_activity_id_value
            v.ceReport.start_date = self.selected_array.field_ce_course_from_date_value
            v.ceReport.end_date = self.selected_array.field_ce_course_to_date_value
            v.ceReport.title = self.selected_array.field_ce_course_title_value
            v.ceReport.provider = self.selected_array.field_ce_course_provider_value
            v.ceReport.hours = self.selected_array.field_ce_hours_reported_value
            v.ceReport.description = self.selected_array.field_ce_course_desc_value
            v.ceReport.url = self.selected_array.field_ce_url_value
            v.ceReport.Nid = self.selected_array.Nid
            v.cred_specific_record = credentials.cred_specific_record
        }else if(segue.identifier == "ReportCEHourVolunteerWorkViewController"){
            var v = segue.destination as! ReportCEHourVolunteerWorkViewController
            v.edit = true
            v.ceReport.course_id = self.selected_array.field_ce_course_activity_id_value
            v.ceReport.start_date = self.selected_array.field_ce_course_from_date_value
            v.ceReport.end_date = self.selected_array.field_ce_course_to_date_value
            v.ceReport.title = self.selected_array.field_ce_course_title_value
            v.ceReport.provider = self.selected_array.field_ce_course_provider_value
            v.ceReport.hours = self.selected_array.field_ce_hours_reported_value
            v.ceReport.description = self.selected_array.field_ce_course_desc_value
            v.ceReport.url = self.selected_array.field_ce_url_value
            v.ceReport.Nid = self.selected_array.Nid
            v.cred_specific_record = credentials.cred_specific_record
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ceActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeHourTableViewCell", for: indexPath) as! CeHourTableViewCell
        //TO-DO: Init cell views
        cell.dateLabel.text = ceActivities[indexPath.row].field_ce_course_from_date_value + " : " + ceActivities[indexPath.row].field_ce_act_type_value
        cell.titleLabel.text = ceActivities[indexPath.row].field_ce_course_title_value.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.earnedLabel.text = ceActivities[indexPath.row].field_ce_hours_reported_value
        cell.earnedLabel.layer.cornerRadius = cell.earnedLabel.layer.bounds.size.width/2
        cell.earnedLabel.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TO-DO: Action on cell tap
    }
}

//extension CredentialsOverviewViewController: PlaceholderDelegate {
//    
//    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
//        print(placeholder.key.value)
//        placeholderTableView?.showDefault()
//    }
//}
//
//class CredentialsTableView: TableView {
//    
//    override func customSetup() {
//        placeholdersProvider = .summer
//    }
//}
