//
//  ProjectLEEDScoreViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 31/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class ProjectLEEDScoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    var scorecards: [Scorecard] = []
    var totalAwarded = 0
    var totalPossible = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ScorecardCell", bundle: nil), forCellReuseIdentifier: "ScorecardCell")
    }
    
    func refreshData(scorecards: [Scorecard]) {
        print("ProjectLEEDScoreViewController: refreshData")
        scorecards.forEach{ scorecard in
            totalAwarded += Int(scorecard.awarded)!
            totalPossible += Int(scorecard.possible)!
        }
        self.scorecards = scorecards
        tableView.reloadData()
        if(totalAwarded != 0){
            totalScoreLabel.text = "Certified \(totalAwarded)/\(totalPossible)"
        }
    }
}

// MARK: UITableView delegates
extension ProjectLEEDScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scorecards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScorecardCell", for: indexPath) as! ScorecardCell
        cell.titleLabel.text = scorecards[indexPath.row].name.uppercased()
        cell.scoreLabel.text = "\(scorecards[indexPath.row].awarded) OF \(scorecards[indexPath.row].possible)"
        cell.scoreImageView.image = UIImage(named: scorecards[indexPath.row].getImage())
        return cell
    }
}
