//
//  CredentialsCEActivityViewControllerNew.swift
//  USGBC
//
//  Created by Vishal Raj on 17/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import DLRadioButton
import SafariServices

class CredentialsCEActivityViewController: UIViewController {
    
    @IBOutlet weak var img_1: UIImageView!
    @IBOutlet weak var img_2: UIImageView!
    @IBOutlet weak var img_3: UIImageView!
    @IBOutlet weak var img_4: UIImageView!
    @IBOutlet weak var img_5: UIImageView!
    @IBOutlet weak var img_6: UIImageView!
    @IBOutlet weak var img_7: UIImageView!
    @IBOutlet weak var totalCeHoursReportedLabel: UILabel!
    @IBOutlet weak var reportingEndDateLabel: UILabel!
    @IBOutlet weak var authorshipRadioButton: DLRadioButton!
    @IBOutlet weak var educationRadioButton: DLRadioButton!
    @IBOutlet weak var projectExperienceRadioButton: DLRadioButton!
    @IBOutlet weak var volunteerWorkRadioButton: DLRadioButton!
    @IBOutlet weak var reportCeHoursButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var noCredentialsView: UIView!
    @IBOutlet weak var clickHereButton: UIButton!
    @IBOutlet weak var credentialsMessageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var didSelecedRadioButton: Bool = false
    var selectedOption: String = ""
    var credentials: Credentials!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "Overview"
        loadCredentials()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.tableView.contentSize.height
    }
    
    func loadCredentials(){
        Utility.showLoading()
        ApiManager.shared.getCredentials(email: Utility().getUserDetail(), callback: { (credentials, error) in
            if(error == nil){
                Utility.hideLoading()
                if(credentials != nil){
                    self.credentials = credentials!
                    if(self.credentials.cred_specific_record.count > 0){
                        self.noCredentialsView.isHidden = true
                        self.updateViews()
                    }else{
                        self.noCredentialsView.isHidden = false
                        self.credentialsMessageLabel.isHidden = false
                        self.clickHereButton.isHidden = false
                    }
                }else{
                    self.noCredentialsView.isHidden = false
                    self.credentialsMessageLabel.isHidden = false
                    self.clickHereButton.isHidden = false
                }
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        })
    }
    
    func updateViews(){
        var i = 1
        credentials.cred_specific_record.forEach { sc in
            switch (i){
                case 1: img_1.image = sc.getCredentialImage()
                case 2: img_2.image = sc.getCredentialImage()
                case 3: img_3.image = sc.getCredentialImage()
                case 4: img_4.image = sc.getCredentialImage()
                case 5: img_5.image = sc.getCredentialImage()
                case 6: img_6.image = sc.getCredentialImage()
                case 7: img_7.image = sc.getCredentialImage()
                default: break
            }
            i += 1
        }
        totalCeHoursReportedLabel.text = "\((credentials.reported_cehours.isEmpty ? "0" : credentials.reported_cehours))/\(credentials.required_ce_hours)"
        reportingEndDateLabel.text = credentials.report_period_end
        if(!credentials.reported_cehours.isEmpty && !credentials.required_ce_hours.isEmpty){
            DispatchQueue.main.async() {
                if(Int(self.credentials.required_ce_hours)! > 0){
                    self.progressView.setProgress(Float(self.credentials.reported_cehours)! / Float(self.credentials.required_ce_hours)!, animated: true)
                }
            }
        }
        tableView.reloadData()
    }
    
    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isScrollEnabled = false
        authorshipRadioButton.addTarget(self, action: #selector(CredentialsCEActivityViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        authorshipRadioButton.tag = 1
        
        educationRadioButton.addTarget(self, action: #selector(CredentialsCEActivityViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        educationRadioButton.tag = 2
        
        projectExperienceRadioButton.addTarget(self, action: #selector(CredentialsCEActivityViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        projectExperienceRadioButton.tag = 3
        
        volunteerWorkRadioButton.addTarget(self, action: #selector(CredentialsCEActivityViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        volunteerWorkRadioButton.tag = 4
        
        authorshipRadioButton.otherButtons = [educationRadioButton, projectExperienceRadioButton, volunteerWorkRadioButton]
        educationRadioButton.otherButtons = [authorshipRadioButton, projectExperienceRadioButton, volunteerWorkRadioButton]
        projectExperienceRadioButton.otherButtons = [authorshipRadioButton, educationRadioButton, volunteerWorkRadioButton]
        volunteerWorkRadioButton.otherButtons = [authorshipRadioButton, educationRadioButton, projectExperienceRadioButton]
        
        reportCeHoursButton.layer.cornerRadius = 4
        reportCeHoursButton.layer.backgroundColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        
        progressView.trackTintColor = UIColor.white
        progressView.layer.cornerRadius = 8
        progressView.layer.borderWidth = 1.2
        progressView.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        progressView.clipsToBounds = true
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
            switch radioButton.tag {
                case 1:
                    selectedOption = "ReportCEHourAuthorshipViewController"
                case 2:
                    selectedOption = "ReportCeHourEducationViewController"
                case 3:
                    selectedOption = "ReportCeHourProjectExperienceViewController"
                case 4:
                    selectedOption = "ReportCEHourVolunteerWorkViewController"
                default: break
            }
            self.didSelecedRadioButton = true
    }
    
    @IBAction func handleReportCeButton(_ sender: Any) {
        if(didSelecedRadioButton){
            performSegue(withIdentifier: selectedOption, sender: self)
        }
    }
    
    @IBAction func handleClickHere(_ sender: Any) {
        let svc = SFSafariViewController(url: URL(string: "http://dev.usgbc.org/account/credentials")!)
        self.present(svc, animated: true, completion: nil)
    }
    
    //MARK: Segue Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReportCEHourAuthorshipViewController" {
            if let viewController = segue.destination as? ReportCEHourAuthorshipViewController {
                viewController.cred_specific_record = credentials.cred_specific_record
            }
        }else if segue.identifier == "ReportCEHourVolunteerWorkViewController" {
            if let viewController = segue.destination as? ReportCEHourVolunteerWorkViewController {
                viewController.cred_specific_record = credentials.cred_specific_record
            }
        }else if segue.identifier == "ReportCeHourEducationViewController" {
            if let viewController = segue.destination as? ReportCeHourEducationViewController {
                viewController.cred_specific_record = credentials.cred_specific_record
            }
        }else if segue.identifier == "ReportCeHourProjectExperienceViewController" {
            if let viewController = segue.destination as? ReportCeHourProjectExperienceViewController {
                viewController.cred_specific_record = credentials.cred_specific_record
            }
        }
    }
}

//MARK: UITableView delegates
extension CredentialsCEActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (credentials != nil ) ? credentials.cred_specific_record.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CredentialsCell", for: indexPath)
        //TO-DO: Init cell views
        let credentialsName: UILabel = cell.viewWithTag(1)as! UILabel
        credentialsName.text = "\(credentials.cred_specific_record[indexPath.row].name) specific hours"
        let credentialsTotal: UILabel = cell.viewWithTag(2)as! UILabel
        credentialsTotal.text = "\(credentials.cred_specific_record[indexPath.row].specialty_hours_reported)/\(credentials.cred_specific_record[indexPath.row].leed_specific_hours)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TO-DO: Action on cell tap
    }
}
