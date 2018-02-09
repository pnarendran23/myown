//
//  ReportCEHourVolunteerWorkViewController
//  USGBC
//
//  Created by Vishal Raj on 16/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import DLRadioButton
import SwiftyJSON

class ReportCEHourVolunteerWorkViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var providerTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var greenAssociateRadioButton: DLRadioButton!
    @IBOutlet weak var bdcRadioButton: DLRadioButton!
    @IBOutlet weak var omRadioButton: DLRadioButton!
    @IBOutlet weak var idcRadioButton: DLRadioButton!
    @IBOutlet weak var ndRadioButton: DLRadioButton!
    @IBOutlet weak var homesRadioButton: DLRadioButton!
    @IBOutlet weak var grRadioButton: DLRadioButton!
    @IBOutlet weak var noneRadioButton: DLRadioButton!
    @IBOutlet weak var ceHoursTextField: UITextField!
    @IBOutlet weak var startlbl: UILabel!
    @IBOutlet weak var endlbl: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    
    let ceType: String = "5304"
    var startDates: NSDate!
    var endDates: NSDate!
    var leedSpecific: String = ""
    var cred_specific_record: [SpecificCredentials] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped(_:)))
        tap.numberOfTapsRequired = 1
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped1(_:)))
        tap1.numberOfTapsRequired = 1
        self.startlbl.tag = 0
        self.endlbl.tag = 1
        self.scrollview.keyboardDismissMode = .onDrag
        self.startlbl.layer.cornerRadius = 5
        self.startlbl.layer.masksToBounds = true
        self.startlbl.layer.borderColor = UIColor.lightGray.cgColor
        self.startlbl.layer.borderWidth = 1.0;
        self.endlbl.layer.cornerRadius = 5
        self.startlbl.textAlignment = .center
        self.endlbl.textAlignment = .center
        self.endlbl.layer.masksToBounds = true
        self.endlbl.layer.borderColor = UIColor.lightGray.cgColor
        self.endlbl.layer.borderWidth = 1.0;
        self.startlbl.isUserInteractionEnabled = true
        self.endlbl.isUserInteractionEnabled = true
        self.startlbl.addGestureRecognizer(tap)
        self.endlbl.addGestureRecognizer(tap1)
        initViews()
    }
    
    func doubleTapped(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        if(recognizer.view!.tag == 0){
            print("start label")
        }else{
            print("end label")
        }
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .date) { (date) in
            if let dt = date {
                self.startDates = dt as NSDate
                self.startlbl.text = "\(self.convertDate(date: dt as NSDate))"
            }
        }
    }
    
    func doubleTapped1(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        if(recognizer.view!.tag == 0){
            print("start label")
        }else{
            print("end label")
        }
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .date) { (date) in
            if let dt = date {
                self.endDates = dt as NSDate
                self.endlbl.text = "\(self.convertDate(date: dt as NSDate))"
            }
        }
    }
    
    func initViews(){
        view.backgroundColor = UIColor.white
        title = "Volunteer Work"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(ReportCEHourVolunteerWorkViewController.submit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.cornerRadius = 4
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        providerTextField.layer.borderWidth = 0.5
        providerTextField.layer.cornerRadius = 4
        providerTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        urlTextField.layer.borderWidth = 0.5
        urlTextField.layer.cornerRadius = 4
        urlTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        ceHoursTextField.layer.borderWidth = 0.5
        ceHoursTextField.layer.cornerRadius = 4
        ceHoursTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        greenAssociateRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        greenAssociateRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        greenAssociateRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        greenAssociateRadioButton.addTarget(self, action: #selector(ReportCEHourVolunteerWorkViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        greenAssociateRadioButton.tag = 1
        greenAssociateRadioButton.otherButtons = [noneRadioButton, bdcRadioButton, omRadioButton, idcRadioButton, ndRadioButton, homesRadioButton, grRadioButton]
        
        bdcRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        bdcRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        bdcRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        bdcRadioButton.addTarget(self, action: #selector(ReportCEHourVolunteerWorkViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        bdcRadioButton.tag = 2
        bdcRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, omRadioButton, idcRadioButton, ndRadioButton, homesRadioButton, grRadioButton]
        
        omRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        omRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        omRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        omRadioButton.addTarget(self, action: #selector(ReportCEHourVolunteerWorkViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        omRadioButton.tag = 3
        omRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, idcRadioButton, ndRadioButton, homesRadioButton, grRadioButton]
        
        idcRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        idcRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        idcRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        idcRadioButton.addTarget(self, action: #selector(ReportCEHourVolunteerWorkViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        idcRadioButton.tag = 4
        idcRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, omRadioButton, ndRadioButton, homesRadioButton, grRadioButton]
        
        ndRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        ndRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        ndRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        ndRadioButton.addTarget(self, action: #selector(ReportCEHourVolunteerWorkViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        ndRadioButton.tag = 5
        ndRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, omRadioButton, idcRadioButton, homesRadioButton, grRadioButton]
        
        homesRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        homesRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        homesRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        homesRadioButton.addTarget(self, action: #selector(ReportCEHourVolunteerWorkViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        homesRadioButton.tag = 6
        homesRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, omRadioButton, idcRadioButton, ndRadioButton, grRadioButton]
        
        grRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        grRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        grRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        grRadioButton.addTarget(self, action: #selector(ReportCEHourVolunteerWorkViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        grRadioButton.tag = 7
        grRadioButton.otherButtons = [noneRadioButton, greenAssociateRadioButton, bdcRadioButton, omRadioButton, idcRadioButton, ndRadioButton, homesRadioButton]
        
        noneRadioButton.setTitleColor(UIColor.hex(hex: Colors.primaryColor), for: UIControlState.normal)
        noneRadioButton.iconColor = UIColor.hex(hex: Colors.primaryColor)
        noneRadioButton.indicatorColor = UIColor.hex(hex: Colors.primaryColor)
        noneRadioButton.addTarget(self, action: #selector(ReportCEHourVolunteerWorkViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
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
        
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 4
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        titleTextField.delegate = self
        providerTextField.delegate = self
//        startDateTextField.delegate = self
//        endDateTextField.delegate = self
        urlTextField.delegate = self
        ceHoursTextField.delegate = self
        
        titleTextField.returnKeyType = .next
        providerTextField.returnKeyType = .next
        descriptionTextView.returnKeyType = .next
        urlTextField.returnKeyType = .next
        ceHoursTextField.returnKeyType = .go
        
//        let viewForDoneButtonOnKeyboard = UIToolbar()
//        viewForDoneButtonOnKeyboard.sizeToFit()
//        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone(_:)))
//        viewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
//        descriptionTextView.inputAccessoryView = viewForDoneButtonOnKeyboard
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
    
//    func handleDone(_ sender: UITextView){
//        urlTextField.becomeFirstResponder()
//    }
    
    func submit(){
        guard let title = titleTextField.text, !title.isEmpty else {
            titleTextField.shake()
            Utility.showToast(message: NSLocalizedString("Please enter title.", comment: "validation"))
            return
        }
        guard let provider = providerTextField.text, !provider.isEmpty else {
            providerTextField.shake()
            Utility.showToast(message: NSLocalizedString("Please enter provider.", comment: "validation"))
            return
        }
        guard let startDate = startlbl.text, !startDate.isEmpty else {
            startlbl.shake()
            Utility.showToast(message: NSLocalizedString("Please enter start date.", comment: "validation"))
            return
        }
        guard let endDate = endlbl.text, !endDate.isEmpty else {
            endlbl.shake()
            Utility.showToast(message: NSLocalizedString("Please enter end date.", comment: "validation"))
            return
        }
        guard let description = descriptionTextView.text, !description.isEmpty else {
            descriptionTextView.shake()
            Utility.showToast(message: NSLocalizedString("Please enter description.", comment: "validation"))
            return
        }
        guard let url = urlTextField.text, !url.isEmpty else {
            urlTextField.shake()
            Utility.showToast(message: NSLocalizedString("Please enter end url.", comment: "validation"))
            return
        }
        guard let ceHours = ceHoursTextField.text, !ceHours.isEmpty else {
            ceHoursTextField.shake()
            Utility.showToast(message: NSLocalizedString("Please enter ce hours.", comment: "validation"))
            return
        }
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDates as Date)
        let date2 = calendar.startOfDay(for: endDates as Date)
        
        let components = calendar.dateComponents([.second], from: date1, to: date2)
        if(components.second! < 0){
            startlbl.shake()
            endlbl.shake()
            Utility.showToast(message: NSLocalizedString("Invalid date range.", comment: "validation"))
            return
        }
        if(leedSpecific == ""){
            Utility.showToast(message: NSLocalizedString("Select LEED Specific.", comment: "validation"))
            return
        }
        let ceReport = CEReport()
        ceReport.title = title
        ceReport.provider = provider
        ceReport.start_date = startDate
        ceReport.end_date = endDate
        ceReport.description = description
        ceReport.url = "https://www.usgbc.org/test-link"//url
        ceReport.hours = ceHours
        ceReport.cehour_type = ceType
        ceReport.email = "esingh@usgbc.org"//Utility().getUserDetail()
        Utility.showLoading()
        ApiManager.shared.reportCEHours(ceReport: ceReport, callback: {(json, error) in
            if(error == nil){
                Utility.hideLoading()
                let message = json!["result"]["message"].stringValue
                if(!message.isEmpty){
                    Utility.showToast(message: message)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    Utility.showToast(message: "\(json!)")
                }
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Error")
            }
        })
    }
    
    @IBAction func startDateTapped(_ sender: UITextField) {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)

        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .date) { (date) in
            if let dt = date {
                self.startDates = dt as NSDate
                self.startlbl.text = "\(self.convertDate(date: dt as NSDate))"
            }
        }
    }
    
    @IBAction func endDateTapped(_ sender: UITextField) {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)

        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .date) { (date) in
            if let dt = date {
                self.endDates = dt as NSDate
                self.endlbl.text = "\(self.convertDate(date: dt as NSDate))"
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
}

extension ReportCEHourVolunteerWorkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            providerTextField.becomeFirstResponder()
        }else if textField == providerTextField {
            providerTextField.resignFirstResponder()
        }else if textField == urlTextField {
            ceHoursTextField.becomeFirstResponder()
        }else if textField == ceHoursTextField {
            ceHoursTextField.resignFirstResponder()
        }
        return false
    }
}
