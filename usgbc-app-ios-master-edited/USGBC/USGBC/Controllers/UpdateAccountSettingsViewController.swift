//
//  UpdateAccountSettingsViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 10/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import Former

class UpdateAccountSettingsViewController: FormViewController {
    
    let countriesArray = ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]
    
    var newPassword = ""
    var repeatPassword = ""
    var profile: AccountProfile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Accounts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(UpdateAccountSettingsViewController.update))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        configure()
    }
    
    func update(){
        //navigationController?.popViewController(animated: true)
        ApiManager.shared.updatePersonalProfile()
    }
    
    func configure(){
        
        let basicHeaderView = LabelViewFormer<FormLabelHeaderView>() {
            $0.contentView.backgroundColor = .clear
            $0.titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
            $0.titleLabel.textColor = .black
            }.configure { view in
                view.viewHeight = 30
                view.text = "Basic Info"
            }
    
        let fnameTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "First Name"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = "First Name"
                $0.text = self.profile.fname
            }.onTextChanged { name in
                self.profile.fname = name
            }
        
        let lnameTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Last Name"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = "Last Name"
                $0.text = self.profile.lname
            }.onTextChanged { name in
                self.profile.lname = name
        }
        
        let emailTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Email"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = "Email"
                $0.text = self.profile.email
            }.onTextChanged { email in
                self.profile.email = email
            }
        
//        let passwordHeaderView = LabelViewFormer<FormLabelHeaderView>() {
//            $0.contentView.backgroundColor = .clear
//            $0.titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
//            $0.titleLabel.textColor = .black
//            }.configure { view in
//                view.viewHeight = 30
//                view.text = "Password"
//            }
//        
//        let oldpassTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
//            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
//            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
//            $0.textField.isSecureTextEntry = true
//            $0.textField.textAlignment = .right
//            $0.titleLabel?.text = "Old Password"
//            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
//            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
//            }.configure {
//                $0.placeholder = ""
//                $0.text = "12345"
//            }.onTextChanged { password in
//                Profile.sharedInstance.password = password
//                print(password)
//            }
//        
//        let newpassTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
//            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
//            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
//            $0.textField.isSecureTextEntry = true
//            $0.textField.textAlignment = .right
//            $0.titleLabel?.text = "New Password"
//            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
//            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
//            }.configure {
//                $0.placeholder = "required"
//                $0.text = ""
//            }.onTextChanged { password in
//                self.newPassword = password
//                print(password)
//        }
//        
//        let repeatnewpassTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
//            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
//            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
//            $0.textField.isSecureTextEntry = true
//            $0.textField.textAlignment = .right
//            $0.titleLabel?.text = "Repeat Password"
//            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
//            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
//            }.configure {
//                $0.placeholder = "required"
//                $0.text = ""
//            }.onTextChanged { password in
//                self.repeatPassword = password
//                print(password)
//        }
        
        let aboutHeaderView = LabelViewFormer<FormLabelHeaderView>() {
            $0.contentView.backgroundColor = .clear
            $0.titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
            $0.titleLabel.textColor = .black
            }.configure { view in
                view.viewHeight = 30
                view.text = "About"
            }
        
        let dobRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Date of birth"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFont(ofSize: 14)
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .dateAndTime
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.onDateChanged({ date in
                Profile.sharedInstance.dob = "\(date)"
                print(date)
            }).displayTextFromDate(String.fullDate)
        
        let genderRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Gender"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                let genders = ["Male", "Female"]
                $0.pickerItems = genders.map {
                    InlinePickerItem(title: $0)
                }
            }.onValueChanged { gender in
                Profile.sharedInstance.gender = gender.title
                print(gender.title)
        }
        
        let studentCheckRow = CheckRowFormer<FormCheckCell>() {
            $0.titleLabel.text = "I am a student"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            }.configure {
                let check = UIImage(named: "check")!.withRenderingMode(.alwaysTemplate)
                let checkView = UIImageView(image: check)
                checkView.tintColor = .formerSubColor()
                $0.customCheckView = checkView
        }.onCheckChanged { isStudent in
            self.profile.isStudent = isStudent
        }
        
        let currentInstituteTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Current Institute"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.currentInstitute
            }.onTextChanged { currentInstitute in
                self.profile.currentInstitute = currentInstitute
        }
        
        let studentIdTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Student ID"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.studentID
            }.onTextChanged { studentID in
                Profile.sharedInstance.studentID = studentID
                print(studentID)
        }
        
        let currentMajorTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Current Major"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.currentMajor
            }.onTextChanged { currentMajor in
                self.profile.currentMajor = currentMajor
        }
        
        let currentDegreeTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Current Degree"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.currentDegree
            }.onTextChanged { currentDegree in
                self.profile.currentDegree = currentDegree
        }
        
        let graduationDateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Graduation Date"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFont(ofSize: 14)
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .dateAndTime
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.onDateChanged({ date in
                Profile.sharedInstance.graduationDate = "\(date)"
                print(date)
            }).displayTextFromDate(String.fullDate)
        
        let mailingHeaderView = LabelViewFormer<FormLabelHeaderView>() {
            $0.contentView.backgroundColor = .clear
            $0.titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
            $0.titleLabel.textColor = .black
            }.configure { view in
                view.viewHeight = 30
                view.text = "Mailing address"
        }
        
        let mailingCountryRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Country"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                let counties = self.countriesArray
                $0.pickerItems = counties.map {
                    InlinePickerItem(title: $0)
                }
            }.onValueChanged { country in
                self.profile.mailingaddresscountry = country.title
        }
        
        let mailindAddTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Address"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.mailingaddressstreet
            }.onTextChanged { mailindAddress in
                self.profile.mailingaddressstreet = mailindAddress
        }
        
        let mailingCityTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "City"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.mailingaddresscity
            }.onTextChanged { mailingCity in
                self.profile.mailingaddresscity = mailingCity
        }
        
        let mailingStateTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "State/Province"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.mailingaddressprovince
            }.onTextChanged { mailingState in
                self.profile.mailingaddressprovince = mailingState
        }
        
        let mailingZipTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Zip/Postal code"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.mailingaddresspostalcode
            }.onTextChanged { mailingZip in
                self.profile.mailingaddresspostalcode = mailingZip
        }
        
        let billingHeaderView = LabelViewFormer<FormLabelHeaderView>() {
            $0.contentView.backgroundColor = .clear
            $0.titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
            $0.titleLabel.textColor = .black
            }.configure { view in
                view.viewHeight = 30
                view.text = "Billing address"
        }
        
        let billingCountryRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Country"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                let counties = self.countriesArray
                $0.pickerItems = counties.map {
                    InlinePickerItem(title: $0)
                }
            }.onValueChanged {country in
                self.profile.billingaddresscountry = country.title
        }
        
        let billindAddTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Address"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.billingaddressstreet
            }.onTextChanged { billindAddress in
                self.profile.billingaddressstreet = billindAddress
        }
        
        let billingCityTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "City"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.billingaddresscity
            }.onTextChanged { billingCity in
                self.profile.billingaddresscity = billingCity
        }
        
        let billingStateTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "State/Province"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.billingaddressprovince
            }.onTextChanged { billingState in
                self.profile.billingaddressprovince = billingState
        }
        
        let billingZipTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Zip/Postal code"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.billingaddresspostalcode
            }.onTextChanged { billingZip in
                self.profile.billingaddresspostalcode = billingZip
        }
        
        let phoneHeaderView = LabelViewFormer<FormLabelHeaderView>() {
            $0.contentView.backgroundColor = .clear
            $0.titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
            $0.titleLabel.textColor = .black
            }.configure { view in
                view.viewHeight = 30
                view.text = "Contact number"
        }
        
        let phoneTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Phone"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = "Name"
                $0.text = self.profile.phone
            }.onTextChanged { phone in
                self.profile.phone = phone
        }
        
        let aiaHeaderView = LabelViewFormer<FormLabelHeaderView>() {
            $0.contentView.backgroundColor = .clear
            $0.titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
            $0.titleLabel.textColor = .black
            }.configure { view in
                view.viewHeight = 30
                view.text = "AIA#"
        }
        
        let aiaTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "AIA number"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.aia
            }.onTextChanged { aia in
                self.profile.aia = aia
        }
        
        let alsaHeaderView = LabelViewFormer<FormLabelHeaderView>() {
            $0.contentView.backgroundColor = .clear
            $0.titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
            $0.titleLabel.textColor = .black
            }.configure { view in
                view.viewHeight = 30
                view.text = "ALSA member #"
        }
        
        let alsaTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "ALSA member #"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = self.profile.aslanumber
            }.onTextChanged { asla in
                self.profile.aslanumber = asla
        }
        
        let basicInfoSection = SectionFormer(rowFormer: fnameTextFieldRow, lnameTextFieldRow, emailTextFieldRow).set(headerViewFormer: basicHeaderView)
//        let passwordSection = SectionFormer(rowFormer: oldpassTextFieldRow, newpassTextFieldRow, repeatnewpassTextFieldRow).set(headerViewFormer: passwordHeaderView)
        let aboutSection = SectionFormer(rowFormer: dobRow, genderRow, studentCheckRow, currentInstituteTextFieldRow, studentIdTextFieldRow, currentMajorTextFieldRow, currentDegreeTextFieldRow, graduationDateRow).set(headerViewFormer: aboutHeaderView)
        let mailindAddSection = SectionFormer(rowFormer: mailingCountryRow, mailindAddTextFieldRow, mailingCityTextFieldRow, mailingStateTextFieldRow, mailingZipTextFieldRow).set(headerViewFormer: mailingHeaderView)
        let billindAddSection = SectionFormer(rowFormer: billingCountryRow, billindAddTextFieldRow, billingCityTextFieldRow, billingStateTextFieldRow, billingZipTextFieldRow).set(headerViewFormer: billingHeaderView)
        let phoneSection = SectionFormer(rowFormer: phoneTextFieldRow).set(headerViewFormer: phoneHeaderView)
        let aiaSection = SectionFormer(rowFormer: aiaTextFieldRow).set(headerViewFormer: aiaHeaderView)
        let alsaSection = SectionFormer(rowFormer: alsaTextFieldRow).set(headerViewFormer: alsaHeaderView)
        former.append(sectionFormer: basicInfoSection, /*passwordSection,*/ aboutSection, mailindAddSection, billindAddSection, phoneSection, aiaSection, alsaSection)
    }

}
