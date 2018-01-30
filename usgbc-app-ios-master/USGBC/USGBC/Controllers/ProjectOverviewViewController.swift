//
//  ProjectOverviewViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 31/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class ProjectOverviewViewController: UIViewController {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sepView: UIView!
    var projectDetails: ProjectDetails!
    var details: [Details] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        tableView.tableHeaderView = headerView
    }
    
    func initViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        detailsLabel.isHidden = true
        sepView.isHidden = true
        
        tableView.register(UINib(nibName: "OverviewCell", bundle: nil), forCellReuseIdentifier: "OverviewCell")
        tableView.tableFooterView = UIView()
    }
    
    func refreshData(projectDetails: ProjectDetails) {
        print("ProjectOverviewViewController: refreshData")
        if(details.count == 0){
            let d1 = Details()
            d1.key = "Size"
            d1.value = projectDetails.project_size + "sf"
            details.append(d1)
            let d2 = Details()
            d2.key = "Use"
            d2.value = projectDetails.project_type
            details.append(d2)
            let d3 = Details()
            d3.key = "Setting"
            d3.value = projectDetails.project_setting
            details.append(d3)
            let d4 = Details()
            d4.key = "Certified"
            d4.value = projectDetails.certification_date
            details.append(d4)
            let d5 = Details()
            d5.key = "Walk Score®"
            d5.value = projectDetails.project_walkscore
            details.append(d5)
        }
        overviewLabel.setHTMLFromString(htmlText: projectDetails.description_full)
        overviewLabel.attributedText = Utility.linespacedString(string: overviewLabel.text!, lineSpace: 8)
        detailsLabel.isHidden = false
        sepView.isHidden = false
        tableView.reloadData()
    }
}

// MARK: UITableView delegates
extension ProjectOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as! OverviewCell
        cell.keyLabel.text = details[indexPath.row].key
        cell.valueLabel.text = details[indexPath.row].value
        return cell
    }
}
