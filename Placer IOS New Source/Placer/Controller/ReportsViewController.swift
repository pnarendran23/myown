//
//  ReportsController.swift
//  Placer
//
//  Created by Vishal on 29/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import DropDown
import TTGSnackbar

class ReportsViewController: UIViewController, UITextFieldDelegate {
    
    var reportTypeLabel = UILabel()
    var reportTypeTextField = DropDownLabel()
    var vehLabel = UILabel()
    var vehTextField = DropDownLabel()
    var startTimeLabel = UILabel()
    var startTimeTextField = DropDownTextField()
    var endTimeLabel = UILabel()
    var endTimeTextField = DropDownTextField()
    var reportDropDown = DropDown()
    var vehDropDown = DropDown()
    var rowOne = UIView()
    var rowTwo = UIView()
    var rowThree = UIView()
    var rowFour = UIView()
    var rowFive = UIView()
    var containerView = UIView()
    var generateReportButton = UIButton()
    var vehNames: [String] = []
    var popStartDatePicker : PopDatePicker?
    var popEndDatePicker : PopDatePicker?
    var startDate: NSDate?
    var endDate: NSDate?
    var vehicleLocations: [VehicleLocationResponse] = []
    var selectedVehicle: VehicleLocationResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popStartDatePicker = PopDatePicker(forTextField: startTimeTextField)
        startTimeTextField.delegate = self
        popEndDatePicker = PopDatePicker(forTextField: endTimeTextField)
        endTimeTextField.delegate = self
        self.initViews()
    }
    
    
    func navigateToNavigateReportDetails(_ sender: AnyObject?){
        if(self.reportTypeTextField.text != "Select Report Type" && self.vehTextField.text != "Select Vehicle" && self.startTimeTextField.text != "Select Start Time" && self.endTimeTextField.text != "Select End Time"){
            if(self.reportTypeTextField.text == "Movement Report"){
                //Max 24 hours
                let interval = endDate!.timeIntervalSince(startDate! as Date)
                print(Int(interval/3600))
                if(Int(interval/3600) > 24 || Int(interval/3600) < 0){
                    let snackbar = TTGSnackbar.init(message: "Movement Report: Invalid date range, Maximum 24 hours!", duration: .short)
                    snackbar.show()
                }else{
                    for veh in vehicleLocations{
                        if(veh.name == self.vehTextField.text){
                            self.selectedVehicle = veh
                            //print(selectedVehicle.name)
                        }
                    }
                    let movementReportDetailsViewController = MovementReportDetailsViewController()
                    movementReportDetailsViewController.vehicleLocation = self.selectedVehicle
                    movementReportDetailsViewController.movementStartDate = self.convertDate(self.startDate! as Date)
                    //print(self.convertDate(self.startDate!))
                    movementReportDetailsViewController.movementEndDate = self.convertDate(self.endDate! as Date)
                    //print(self.convertDate(self.endDate!))
                    self.navigationController?.pushViewController(movementReportDetailsViewController, animated: true)
                }
            }else if(self.reportTypeTextField.text == "Productivity Report"){
                //Max 30days
                let interval = endDate!.timeIntervalSince(startDate! as Date)
                print(Int(interval/86400))
                if(Int(interval/86400) > 30 || Int(interval/86400) < 0){
                    let snackbar = TTGSnackbar.init(message: "Productivity Report: Invalid date range, Maximium 30 days!", duration: .short)
                    snackbar.backgroundColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
                    snackbar.show()
                }else{
                    for veh in vehicleLocations{
                        if(veh.name == self.vehTextField.text){
                            self.selectedVehicle = veh
                            //print(selectedVehicle.name)
                        }
                    }
                    let productivityReportDetailsViewController = ProductivityReportDetailsViewController()
                    productivityReportDetailsViewController.vehicleLocation = self.selectedVehicle
                    productivityReportDetailsViewController.productivityStartDate = self.convertDateProductivity(self.startDate! as Date)
                    //print(self.convertDate(self.startDate!))
                    productivityReportDetailsViewController.productivityEndDate = self.convertDateProductivity(self.endDate! as Date)
                    //print(self.convertDate(self.endDate!))
                    self.navigationController?.pushViewController(productivityReportDetailsViewController, animated: true)
                }
            }
            
        }else{
            let snackbar = TTGSnackbar.init(message: "All fields are mandatory !", duration: .short)
            snackbar.backgroundColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
            snackbar.show()
        }
    }
    
    func convertDate(_ date: Date) -> String{
        let todaysDate:Date = date
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: todaysDate)
    }
    
    func convertDateProductivity(_ date: Date) -> String{
        let todaysDate:Date = date
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: todaysDate)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField === startTimeTextField) {
            resign()
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            print(self.getCurrentDate())
            let initDate : Date? = Date()//formatter.dateFromString(self.getCurrentDate())//startTimeTextField.text!)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                self.startDate = newDate
                // here we don't use self (no retain cycle)
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
                
            }
            
            popStartDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }
        else if (textField === endTimeTextField) {
            resign()
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let initDate : Date? = Date()//formatter.dateFromString(self.getCurrentDate())
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                self.endDate = newDate
                // here we don't use self (no retain cycle)
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
                
            }
            
            popEndDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }
        else {
            return true
        }
        
    }
    
    func getCurrentDate() -> String {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, hh:mm a"
        return dateFormatter.string(from: todaysDate)
    }
    
    func resign() {
        startTimeTextField.resignFirstResponder()
        endTimeTextField.resignFirstResponder()
    }
    
    func initViews(){
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //nav title
        self.title = ""
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: (self.navigationController?.navigationBar.frame.height)!))
        titleLabel.center = (navigationController?.navigationBar.center)!
        titleLabel.text = "Reports"
        titleLabel.font = UIFont(name: "Roboto-Light", size: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        self.initRowOne()
        self.initRowTwo()
        self.initRowThree()
        self.initRowFour()
        self.initRowFive()
        
    }
    
    func initRowOne(){
        self.containerView.frame = CGRect(x: 0, y: 0, width: 300, height: 280)
        //self.containerView.backgroundColor = UIColor.purpleColor()
        
        self.rowOne.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        //self.rowOne.backgroundColor = UIColor.greenColor()
        
        self.reportTypeLabel.frame = CGRect(x: 0, y: 5, width: 100, height: 40)
        self.reportTypeLabel.text = "Report Type "
        self.reportTypeLabel.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.reportTypeLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        //self.reportTypeLabel.backgroundColor = UIColor.redColor()
        
        self.reportTypeTextField.frame = CGRect(x: 105, y: 5, width: 195, height: 40)
        self.reportTypeTextField.layer.cornerRadius = 8
        self.reportTypeTextField.layer.borderWidth = 1
        self.reportTypeTextField.layer.borderColor = UIColor.black.cgColor
        self.reportTypeTextField.text = "Select Report Type"
        self.reportTypeTextField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.reportTypeTextField.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        //self.reportTypeTextField.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.reportTypeTextField.isUserInteractionEnabled = true
        let reportTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(ReportsViewController.handleReportType))
        reportTapRecogniser.numberOfTapsRequired = 1
        self.reportTypeTextField.addGestureRecognizer(reportTapRecogniser)
        //self.reportTypeTextField.backgroundColor = UIColor.redColor()
        
        self.rowOne.addSubview(self.reportTypeLabel)
        self.rowOne.addSubview(self.reportTypeTextField)
        self.containerView.addSubview(self.rowOne)
        
        self.reportDropDown.anchorView = self.reportTypeTextField
        self.reportDropDown.dataSource = ["Movement Report", "Productivity Report"]
        //, "Fuel Sensor Report", "Box Disconnect Report"]
        self.reportDropDown.direction = .bottom
        
        reportDropDown.selectionAction = { [unowned self] (index, item) in
            self.reportTypeTextField.text = item
        }
    }
    
    func initRowTwo(){
        self.rowTwo.frame = CGRect(x: 0, y: 50, width: 300, height: 50)
        //self.rowTwo.backgroundColor = UIColor.greenColor()
        
        self.vehLabel.frame = CGRect(x: 0, y: 5, width: 100, height: 40)
        self.vehLabel.text = "Vehicle "
        self.vehLabel.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.vehLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        //self.vehLabel.backgroundColor = UIColor.redColor()
        
        self.vehTextField.frame = CGRect(x: 105, y: 5, width: 195, height: 40)
        self.vehTextField.layer.cornerRadius = 8
        self.vehTextField.layer.borderWidth = 1
        self.vehTextField.layer.borderColor = UIColor.black.cgColor
        self.vehTextField.text = "Select Vehicle"
        self.vehTextField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.vehTextField.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        
        
        self.vehTextField.isUserInteractionEnabled = true
        let reportTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(ReportsViewController.handleVehType))
        reportTapRecogniser.numberOfTapsRequired = 1
        self.vehTextField.addGestureRecognizer(reportTapRecogniser)
        //self.vehTextField.backgroundColor = UIColor.redColor()
        
        self.rowTwo.addSubview(self.vehLabel)
        self.rowTwo.addSubview(self.vehTextField)
        self.containerView.addSubview(self.rowTwo)
        
        self.vehDropDown.anchorView = self.vehTextField
        self.vehDropDown.dataSource = self.vehNames
        self.vehDropDown.direction = .any
        
        vehDropDown.selectionAction = { [unowned self] (index, item) in
            self.vehTextField.text = item
        }
    }
    
    func initRowThree(){
        self.rowThree.frame = CGRect(x: 0, y: 100, width: 300, height: 50)
        //self.rowThree.backgroundColor = UIColor.greenColor()
        
        self.startTimeLabel.frame = CGRect(x: 0, y: 5, width: 100, height: 40)
        self.startTimeLabel.text = "Start Time "
        self.startTimeLabel.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.startTimeLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        //self.startTimeLabel.backgroundColor = UIColor.redColor()
        
        self.startTimeTextField.frame = CGRect(x: 105, y: 5, width: 195, height: 40)
        self.startTimeTextField.layer.cornerRadius = 8
        self.startTimeTextField.layer.borderWidth = 1
        self.startTimeTextField.layer.borderColor = UIColor.black.cgColor
        self.startTimeTextField.text = "Select Start Time"
        self.startTimeTextField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.startTimeTextField.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        //self.startTimeTextField.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 4)
        //self.startTimeTextField.userInteractionEnabled = true
        //let reportTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(ReportsViewController.handleStartTime))
        //reportTapRecogniser.numberOfTapsRequired = 1
        //self.startTimeTextField.addGestureRecognizer(reportTapRecogniser)
        //self.startTimeTextField.backgroundColor = UIColor.redColor()
        
        self.rowThree.addSubview(self.startTimeLabel)
        self.rowThree.addSubview(self.startTimeTextField)
        self.containerView.addSubview(self.rowThree)
        
    }
    
    func initRowFour(){
        self.rowFour.frame = CGRect(x: 0, y: 150, width: 300, height: 50)
        //self.rowFour.backgroundColor = UIColor.greenColor()
        
        self.endTimeLabel.frame = CGRect(x: 0, y: 5, width: 100, height: 40)
        self.endTimeLabel.text = "End Time "
        self.endTimeLabel.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.endTimeLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        //self.endTimeLabel.backgroundColor = UIColor.redColor()
        
        self.endTimeTextField.frame = CGRect(x: 105, y: 5, width: 195, height: 40)
        self.endTimeTextField.layer.cornerRadius = 8
        self.endTimeTextField.layer.borderWidth = 1
        self.endTimeTextField.layer.borderColor = UIColor.black.cgColor
        self.endTimeTextField.text = "Select End Time"
        self.endTimeTextField.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.endTimeTextField.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        //self.startTimeTextField.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 4)
//        self.endTimeTextField.userInteractionEnabled = true
//        let reportTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(ReportsViewController.handleEndTime))
//        reportTapRecogniser.numberOfTapsRequired = 1
//        self.endTimeTextField.addGestureRecognizer(reportTapRecogniser)
        //self.endTimeTextField.backgroundColor = UIColor.redColor()
        
        self.rowFour.addSubview(self.endTimeLabel)
        self.rowFour.addSubview(self.endTimeTextField)
        self.containerView.addSubview(self.rowFour)

    }
    
    func initRowFive(){
        self.rowFive.frame = CGRect(x: 0, y: 240, width: 300, height: 50)
        //self.rowFive.backgroundColor = UIColor.greenColor()
        
        self.generateReportButton.frame = CGRect(x: 35, y: 0, width: 230, height: 50)
        self.generateReportButton.setTitle("Generate Report", for: UIControlState())
        self.generateReportButton.setTitleColor(UIColor.hexStringToUIColor("#323754"), for: UIControlState())
        self.generateReportButton.layer.cornerRadius = 25
        self.generateReportButton.layer.borderWidth = 1
        self.generateReportButton.backgroundColor = UIColor.hexStringToUIColor("#8C93BA")
        self.generateReportButton.layer.borderColor = UIColor.hexStringToUIColor("#8C93BA").cgColor
        //self.generateReportButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height-105)
        self.generateReportButton.addTarget(self, action: #selector(ReportsViewController.navigateToNavigateReportDetails(_:)), for: .touchUpInside)
        self.rowFive.addSubview(self.generateReportButton)
        self.containerView.addSubview(self.rowFive)
        self.view.addSubview(self.containerView)
        self.containerView.center.x = self.view.center.x
        self.containerView.center.y = self.view.center.y - 135
    }

    
    func handleReportType(){
        print("handleReport tapped!")
        self.reportDropDown.show()
    }
    
    func handleVehType(){
        print("handleVeh tapped!")
        self.vehDropDown.show()
    }
    
}
