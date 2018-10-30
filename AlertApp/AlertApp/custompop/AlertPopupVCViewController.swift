//
//  AlertPopupVCViewController.swift
//  AlertApp
//
//  Created by Group10 on 28/02/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import UIKit

protocol alertsDelegate : class {
    func onAlertsUpdated(alertsarray : NSMutableArray)
}

class AlertPopupVCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var delegate : alertsDelegate?
    
    private let titlesArray = ["Sms",
                               "Call",
                               "Alert",
                               "Email"]
    var alertsarray : NSMutableArray = []
    
    
    @IBAction func dismissController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savealert(_ sender: Any) {
        
        delegate?.onAlertsUpdated(alertsarray: alertsarray)
        
       
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var tblAlerts: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblAlerts.dataSource = self
        self.tblAlerts.delegate = self
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(titlesArray[indexPath.row] == alertsarray[indexPath.row] as! String){
            alertsarray.replaceObject(at: indexPath.row, with: "")
        }else if(titlesArray[indexPath.row] != alertsarray[indexPath.row] as! String){
            alertsarray.replaceObject(at: indexPath.row, with: titlesArray[indexPath.row])
        }
        tableView.reloadData()
        
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertsPopupTableViewCell", for: indexPath) as! AlertsPopupTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.lblAlertsType.text = titlesArray[indexPath.row]
        if(alertsarray.contains(titlesArray[indexPath.row])){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0
        return 50
    }
    
   
    
}
