//
//  ProjectDataReportingViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 31/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SafariServices

class ProjectDataReportingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var reportings: [DataReporting] = []
    var selectedReporting: DataReporting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "DataReportingCell", bundle: nil), forCellReuseIdentifier: "DataReportingCell")
    }
    
    func refreshData(reportings: [DataReporting]) {
        print("ProjectDataReportingViewController: refreshData")
        self.reportings = reportings
        tableView.reloadData()
    }
    
    func handleUpdate(_ sender: UIButton){
        let svc = SFSafariViewController(url: URL(string:selectedReporting.url)!)
        present(svc, animated: true, completion: nil)
    }
}

// MARK: UITableView delegates
extension ProjectDataReportingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataReportingCell", for: indexPath) as! DataReportingCell
        cell.reportImageView.image = UIImage(named: reportings[indexPath.row].getImage())
        cell.titleLabel.text = reportings[indexPath.row].name
        cell.updateButton.addTarget(self, action: #selector(ProjectDataReportingViewController.handleUpdate(_:)), for: .touchUpInside)
        selectedReporting = reportings[indexPath.row]
        print("\(selectedReporting.name): \(selectedReporting.score)")
        if(reportings[indexPath.row].score == 0){
            cell.updateButton.isHidden = true
        }else{
            cell.updateButton.isHidden = false
        }
        return cell
    }
}
