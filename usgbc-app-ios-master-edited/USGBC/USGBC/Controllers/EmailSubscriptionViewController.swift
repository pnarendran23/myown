//
//  EmailSubscriptionViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 19/07/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import DLRadioButton

class EmailSubscriptionViewController:UIViewController{
    
    let subscriptions: [String] = ["All USGBC articles", "Advocacy", "Community", "Education", "Industry", "LEED", "Center for Green Schools", "GBCI", "Green Home Guide", "Parksmart", "PEER", "SITES",]
    
    
    @IBOutlet weak var unsubscribeCheckBox: DLRadioButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var unsubscribeSaveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.title = "Email Subscription"
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func initViews(){
        view.backgroundColor = UIColor.white
        
        unsubscribeCheckBox.isMultipleSelectionEnabled = true
        saveButton.layer.cornerRadius = 4
        unsubscribeSaveButton.layer.cornerRadius = 4
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SubFilterCell", bundle: nil), forCellReuseIdentifier: "SubFilterCell")
    }
}

// MARK: UITableView delegates
extension EmailSubscriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubFilterCell", for: indexPath) as! SubFilterCell
        cell.selectionStyle = .none
        cell.tintColor = UIColor.hex(hex: Colors.primaryColor)
        let emptyCheckImage = UIImage(named: "ic_checkbox_empty")
        let emptyCheckmark = UIImageView(image: emptyCheckImage)
        emptyCheckmark.tintColor = UIColor.hex(hex: Colors.primaryColor)
        cell.accessoryView = emptyCheckmark
//        if(filter.subFilters[indexPath.row].selected){
//            cell.accessoryType = .checkmark
//            selectedIndexPath = indexPath
//        }else{
//            cell.accessoryType = .none
//        }
        cell.subFilterLabel.text = subscriptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let emptyCheckImage = UIImage(named: "ic_checkbox_empty")
        let emptyCheckmark = UIImageView(image: emptyCheckImage)
        emptyCheckmark.tintColor = UIColor.hex(hex: Colors.primaryColor)
        
        let checkImage = UIImage(named: "ic_checkbox_selected")
        let checkmark = UIImageView(image: checkImage)
        checkmark.tintColor = UIColor.hex(hex: Colors.primaryColor)
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryView = emptyCheckmark
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: indexPath)?.accessoryView = checkmark
        }
    }
}
