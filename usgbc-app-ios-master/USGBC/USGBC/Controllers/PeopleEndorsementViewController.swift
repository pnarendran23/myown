//
//  PeopleEndorsementViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 01/09/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class PeopleEndorsementViewController: UIViewController {
    
    @IBOutlet weak var endorsementlabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var endorsements: [PeopleEndorsement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    func refreshData(endorsements: [PeopleEndorsement]) {
        print("PeopleEndorsementViewController: refreshData")
        self.endorsements = endorsements
        if(endorsements.count > 0){
            tableView.reloadData()
            endorsementlabel.text = ""
        }
    }
}

// MARK: UITableView delegates
extension PeopleEndorsementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endorsements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EndorsementCell", for: indexPath) as! EndorsementCell
        cell.titleLabel.text = endorsements[indexPath.row].title
        cell.dateLabel.text = "on \(endorsements[indexPath.row].postDate)"
        cell.categoryLabel.text = "in \(endorsements[indexPath.row].endorsementType)"
        return cell
    }
}
