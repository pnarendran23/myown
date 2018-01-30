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
    
    @IBOutlet weak var tableView: UITableView!
    //var placeholderTableView: TableView?
    
    var reportedHours: Float = 0.0
    var approvedHours: Float = 0.0
    var bdcReportedHours: Float = 0.0
    var bdcApprovedHours: Float = 0.0
    var ceActivities: [CEActivity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK: Load JSON from file
    func loadCredentials(){
        Utility.showLoading()
        ApiManager.shared.getCEActivities(email: Utility().getUserDetail()) { (ceActivities, error) in
            if(error == nil){
                Utility.hideLoading()
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
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
}

//MARK: UITableView delegates
extension CredentialsOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ceActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeHourTableViewCell", for: indexPath) as! CeHourTableViewCell
        //TO-DO: Init cell views
        cell.dateLabel.text = ceActivities[indexPath.row].field_ce_course_from_date_value + " : " + ceActivities[indexPath.row].field_ce_act_type_value
        cell.titleLabel.text = ceActivities[indexPath.row].field_ce_course_title_value.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.earnedLabel.text = ceActivities[indexPath.row].field_ce_hours_reported_value
        return cell
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
