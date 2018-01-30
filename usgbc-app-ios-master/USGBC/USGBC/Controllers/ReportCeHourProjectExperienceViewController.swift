//
//  ReportCeHourProjectExperienceViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 17/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import DLRadioButton
import DropDown

class ReportCeHourProjectExperienceViewController: UIViewController {
    
    @IBOutlet weak var leedIdTextField: UITextField!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var greenAssociateRadioButton: DLRadioButton!
    @IBOutlet weak var bdcRadioButton: DLRadioButton!
    @IBOutlet weak var omRadioButton: DLRadioButton!
    @IBOutlet weak var idcRadioButton: DLRadioButton!
    @IBOutlet weak var ndRadioButton: DLRadioButton!
    @IBOutlet weak var homesRadioButton: DLRadioButton!
    @IBOutlet weak var grRadioButton: DLRadioButton!
    @IBOutlet weak var noneRadioButton: DLRadioButton!
    @IBOutlet weak var ceHoursTextField: UITextField!
    @IBOutlet weak var involvementContainer: UIView!
    @IBOutlet weak var startDateTF: ImageTextField!
    @IBOutlet weak var endDateTF: ImageTextField!
    @IBOutlet weak var teamRoleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var involvementHeightConstraint: NSLayoutConstraint! //240
    @IBOutlet weak var referenceContainer: UIView!
    @IBOutlet weak var refFistNameTF: UITextField!
    @IBOutlet weak var refLastNameTF: UITextField!
    @IBOutlet weak var refCompanyTF: UITextField!
    @IBOutlet weak var refPhoneTF: UITextField!
    @IBOutlet weak var refEmailTF: UITextField!
    @IBOutlet weak var referenceHeightConstraint: NSLayoutConstraint! //40
    @IBOutlet weak var projectDetailsContainer: UIView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectIDLabel: UILabel!
    @IBOutlet weak var crossIV: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var roleDropDown = DropDown()
    var leedSearchButton: UIButton!
    var projectSearchButton: UIButton!
    var leedProjects: [LEEDProject] = []
    var projects: [LEEDProject] = []
    var roles = ["Architect","Artist","Biologist","Broker","Builder","Building Engineer","Building Operator","Civil Engineer","Client","Commissioning Agent","Construction Manager","Contractor","Cost Consultant","Custodial Supervisor","Developer","Ecologist","Energy Manager","Environmental Adviser","Environmental Health & Safety","Environmental Manager","Equipment Service Desk Supervisor","Facility Manager","Financial Manager","Historic Architect","Homeowner's Association","HVAC Engineer","HVAC Shop Supervisor","Interior Designer","Landscape Architect","Master Developer","Master Planner","MEP Engineer","Owner","Owner & Master Developer","Owner & Master Planner","Paint Shop Supervisor","Plumbing Shop Supervisor","Project Administrator","Project Manager","Property Manager","QA/QC","Site/Grounds Manager","Solid Waste Manager","Structural Engineer","Supply/Purchasing Manager","Tenant","Transportation Planner","Urban Designer"]
    
    let ceType: String = "5303"
    var startDates: NSDate!
    var endDates: NSDate!
    var leedSpecific: String = ""
    var cred_specific_record: [SpecificCredentials] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        involvementHeightConstraint.constant = 0
        involvementContainer.isHidden = true
        referenceHeightConstraint.constant = 0
        referenceContainer.isHidden = true
        projectDetailsContainer.isHidden = true
        tableView.isHidden = true
        DropDown.startListeningToKeyboard()
        initViews()
    }
    
    func initViews(){
        view.backgroundColor = UIColor.white
        title = "Project Experience"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(ReportCeHourProjectExperienceViewController.submit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 4
        tableView.layer.borderColor = UIColor.hex(hex: "#e7e7e7").cgColor
        
        leedIdTextField.layer.borderWidth = 0.5
        leedIdTextField.layer.cornerRadius = 4
        leedIdTextField.layer.borderColor = UIColor.lightGray.cgColor
        leedSearchButton = UIButton()
        leedSearchButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leedSearchButton.setBackgroundImage(UIImage(named: "search"), for: .normal)
        leedSearchButton.tintColor = UIColor.lightGray
        leedSearchButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.handleSearchProjectLEED(_:)), for: .touchUpInside)
        leedIdTextField.rightViewMode = .always
        leedIdTextField.rightView = leedSearchButton
        leedIdTextField.keyboardType = .phonePad
        
        projectNameTextField.layer.borderWidth = 0.5
        projectNameTextField.layer.cornerRadius = 4
        projectNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        projectSearchButton = UIButton()
        projectSearchButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        projectSearchButton.setBackgroundImage(UIImage(named: "search"), for: .normal)
        projectSearchButton.tintColor = UIColor.lightGray
        projectSearchButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.handleSearchProjectName(_:)), for: .touchUpInside)
        projectNameTextField.rightViewMode = .always
        projectNameTextField.rightView = projectSearchButton
        projectNameTextField.keyboardType = .alphabet
        projectNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        involvementContainer.layer.borderWidth = 1
        involvementContainer.layer.cornerRadius = 4
        involvementContainer.layer.borderColor = UIColor.hex(hex: "#e7e7e7").cgColor
        
        teamRoleTF.layer.borderWidth = 0.5
        teamRoleTF.layer.cornerRadius = 4
        teamRoleTF.layer.borderColor = UIColor.lightGray.cgColor
        
        roleDropDown.anchorView = teamRoleTF
        roleDropDown.dataSource = roles
        roleDropDown.direction = .bottom
        
        roleDropDown.selectionAction = { [unowned self] (index, item) in
            self.teamRoleTF.text = item
            self.teamRoleTF.resignFirstResponder()
        }
        
        descriptionTV.layer.borderWidth = 0.5
        descriptionTV.layer.cornerRadius = 4
        descriptionTV.layer.borderColor = UIColor.lightGray.cgColor
        
        referenceContainer.layer.borderWidth = 1
        referenceContainer.layer.cornerRadius = 4
        referenceContainer.layer.borderColor = UIColor.hex(hex: "#e7e7e7").cgColor
        
        refFistNameTF.layer.borderWidth = 0.5
        refFistNameTF.layer.cornerRadius = 4
        refFistNameTF.layer.borderColor = UIColor.lightGray.cgColor
        
        refLastNameTF.layer.borderWidth = 0.5
        refLastNameTF.layer.cornerRadius = 4
        refLastNameTF.layer.borderColor = UIColor.lightGray.cgColor
        
        refCompanyTF.layer.borderWidth = 0.5
        refCompanyTF.layer.cornerRadius = 4
        refCompanyTF.layer.borderColor = UIColor.lightGray.cgColor
        
        refPhoneTF.layer.borderWidth = 0.5
        refPhoneTF.layer.cornerRadius = 4
        refPhoneTF.layer.borderColor = UIColor.lightGray.cgColor
        
        refEmailTF.layer.borderWidth = 0.5
        refEmailTF.layer.cornerRadius = 4
        refEmailTF.layer.borderColor = UIColor.lightGray.cgColor
        
        ceHoursTextField.layer.borderWidth = 0.5
        ceHoursTextField.layer.cornerRadius = 4
        ceHoursTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        projectDetailsContainer.layer.borderWidth = 1
        projectDetailsContainer.layer.cornerRadius = 4
        projectDetailsContainer.layer.borderColor = UIColor.hex(hex: "#e7e7e7").cgColor
        
        crossIV.tintColor = UIColor.darkGray
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCross(tapGestureRecognizer:)))
        crossIV.isUserInteractionEnabled = true
        crossIV.addGestureRecognizer(tapGestureRecognizer)
        
        greenAssociateRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        greenAssociateRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        greenAssociateRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        greenAssociateRadioButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        greenAssociateRadioButton.tag = 1
        greenAssociateRadioButton.otherButtons = [noneRadioButton, bdcRadioButton, omRadioButton, idcRadioButton, ndRadioButton, homesRadioButton, grRadioButton]
        
        bdcRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        bdcRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        bdcRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        bdcRadioButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        bdcRadioButton.tag = 2
        bdcRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, omRadioButton, idcRadioButton, ndRadioButton, homesRadioButton, grRadioButton]
        
        omRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        omRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        omRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        omRadioButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        omRadioButton.tag = 3
        omRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, idcRadioButton, ndRadioButton, homesRadioButton, grRadioButton]
        
        idcRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        idcRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        idcRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        idcRadioButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        idcRadioButton.tag = 4
        idcRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, omRadioButton, ndRadioButton, homesRadioButton, grRadioButton]
        
        ndRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        ndRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        ndRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        ndRadioButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        ndRadioButton.tag = 5
        ndRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, omRadioButton, idcRadioButton, homesRadioButton, grRadioButton]
        
        homesRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        homesRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        homesRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        homesRadioButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        homesRadioButton.tag = 6
        homesRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, omRadioButton, idcRadioButton, ndRadioButton, grRadioButton]
        
        grRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        grRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        grRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        grRadioButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        grRadioButton.tag = 7
        grRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, omRadioButton, idcRadioButton, ndRadioButton, homesRadioButton]
        
        noneRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        noneRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        noneRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        noneRadioButton.addTarget(self, action: #selector(ReportCeHourProjectExperienceViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        noneRadioButton.tag = 8
        noneRadioButton.otherButtons = [greenAssociateRadioButton, bdcRadioButton, omRadioButton, idcRadioButton, ndRadioButton, homesRadioButton, grRadioButton]
        
        cred_specific_record.forEach { sr in
            switch (sr.name){
            case "Green Associate":
                greenAssociateRadioButton.isHidden = false
            case "BD+C":
                bdcRadioButton.isHidden = false
            case "O+M":
                omRadioButton.isHidden = false
            case "ID+C":
                idcRadioButton.isHidden = false
            case "ND":
                ndRadioButton.isHidden = false
            case "Homes":
                homesRadioButton.isHidden = false
            case "Green Rater":
                grRadioButton.isHidden = false
            default: break
            }
        }
    }
    
    func handleSearchProjectLEED(_ sender: Any){
        guard let leedID = leedIdTextField.text, !leedID.isEmpty else {
            leedIdTextField.shake()
            Utility.showToast(message: NSLocalizedString("Please enter LEED ID.", comment: "validation"))
            return
        }
        leedIdTextField.resignFirstResponder()
        Utility.showLoading()
        ApiManager.shared.getProjectByLeedId(id: leedID) { (projects, error) in
            if(error == nil){
                Utility.hideLoading()
                self.leedProjects = projects!
                print("Project count: \(self.leedProjects.count)")
                if(self.leedProjects.count > 0){
                    self.projectNameLabel.text = "Connected: \(self.leedProjects.first?.title ?? "Not available!")"
                    self.projectIDLabel.text = "Project ID: \(self.leedIdTextField.text ?? "Not available!")"
                    self.showContainers()
                }else{
                    Utility.showToast(message: "Project not found!")
                }
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        switch radioButton.tag {
        case 1:
            leedSpecific = "LEEDGreenAssociate"
        case 2:
            leedSpecific = "None"
        default:
            print("Error!")
        }
    }
    
    func handleSearchProjectName(_ sender: Any){
        guard let projectName = projectNameTextField.text, !projectName.isEmpty else {
            leedIdTextField.shake()
            Utility.showToast(message: NSLocalizedString("Please enter project name.", comment: "validation"))
            return
        }
        projectNameTextField.resignFirstResponder()
        Utility.showLoading()
        ApiManager.shared.getProjectByName(name: projectName) { (projects, error) in
            if(error == nil){
                Utility.hideLoading()
                self.leedProjects = projects!
                if(self.leedProjects.count > 0){
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }else{
                    Utility.showToast(message: "Project not found!")
                }
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
    
    func showContainers(){
        projectDetailsContainer.isHidden = false
        involvementContainer.isHidden = false
        involvementHeightConstraint.constant = 248
        referenceContainer.isHidden = false
        referenceHeightConstraint.constant = 400
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideContainers(){
        projectDetailsContainer.isHidden = true
        involvementContainer.isHidden = true
        involvementHeightConstraint.constant = 0
        referenceContainer.isHidden = true
        referenceHeightConstraint.constant = 0
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func submit(){
        if(projects.count == 0 ){
            Utility.showToast(message: NSLocalizedString("Please select project.", comment: "validation"))
            return
        }
    }
    
    func handleCross(tapGestureRecognizer: UITapGestureRecognizer){
        leedIdTextField.text = ""
        projectNameTextField.text = ""
        resignFirstResponder()
        hideContainers()
    }
    
    func textFieldDidChange(textField: UITextField){
        if(textField.text?.isEmpty)!{
            tableView.isHidden = true
        }
    }
    
    @IBAction func handleStartDate(_ sender: Any) {
        startDateTF.resignFirstResponder()
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .date) { (date) in
            if let dt = date {
                self.startDates = dt as NSDate
                self.startDateTF.text = "\(self.convertDate(date: dt as NSDate))"
            }
        }
    }
    
    @IBAction func handleEndDate(_ sender: Any) {
        endDateTF.resignFirstResponder()
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .date) { (date) in
            if let dt = date {
                self.endDates = dt as NSDate
                self.endDateTF.text = "\(self.convertDate(date: dt as NSDate))"
            }
        }
    }
    
    func convertDate(date: NSDate) -> String{
        let todaysDate:NSDate = date
        let dateFormatter:DateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: todaysDate as Date)
    }
    
    @IBAction func handleRole(_ sender: Any) {
        print("handleRole")
        roleDropDown.show()
    }
}

extension ReportCeHourProjectExperienceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leedProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        let titleLabel: UILabel = cell.viewWithTag(1)as! UILabel
        titleLabel.text = leedProjects[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        projectNameLabel.text = "Connected: \(self.leedProjects[indexPath.row].title)"
        projectIDLabel.text = "Project ID: \(self.leedProjects[indexPath.row].pid)"
        showContainers()
        tableView.isHidden = true
    }
}


