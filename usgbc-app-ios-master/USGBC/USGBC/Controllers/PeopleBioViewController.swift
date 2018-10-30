//
//  PeopleBioViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 21/06/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class PeopleBioViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bioLabel: UILabel!
    
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
    
        tableView.tableFooterView = UIView()
    }
    
    func refreshData(bio: String) {
        print("PeopleBioViewController: refreshData")
        if(!bio.isEmpty){
            bioLabel.setHTMLFromString(htmlText: bio)
            bioLabel.attributedText = Utility.linespacedString(string: bioLabel.text!, lineSpace: 8)
        }else{
            bioLabel.text = "Not available"
        }
    }
}

// MARK: UITableView delegates
extension PeopleBioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
