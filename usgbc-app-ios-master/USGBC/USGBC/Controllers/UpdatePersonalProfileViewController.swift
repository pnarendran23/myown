//
//  UpdatePersonalProfileViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 11/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import Former

class UpdatePersonalProfileViewController: FormViewController {
    
    let countriesArray = ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(UpdatePersonalProfileViewController.update))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        configure()
    }
    
    lazy var imageRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
            $0.iconView.image = Profile.sharedInstance.image
            print("lazy imageRow")
            print($0.iconView.image ?? "no image")
             }.configure { row in
                row.text = "Choose profile image from library"
                row.rowHeight = 100
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
                self?.presentImagePicker()
        }
    }()
    
    func update(){
        navigationController?.popViewController(animated: true)
    }
    
    func configure(){
        let jobTitleTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Job title"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = ""
        }
        
        let deptTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Department"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = ""
        }
        
        let companyTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Company"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = ""
        }
        
        let bioTextViewRow = TextViewRowFormer<FormTextViewCell>() {
            $0.textView.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textView.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textView.textAlignment = .left
            $0.titleLabel?.text = "Bio"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = ""
        }
        
        let countryRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Country"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                let counties = self.countriesArray
                $0.pickerItems = counties.map {
                    InlinePickerItem(title: $0)
                }
                //                if let gender = Profile.sharedInstance.gender {
                //                    $0.selectedRow = genders.index(of: gender) ?? 0
                //                }
            }.onValueChanged {_ in
                //Profile.sharedInstance.gender = $0.title
        }
        
        let addTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Address"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = ""
        }
        
        let cityTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "City"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = ""
        }
        
        let stateTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "State/Province"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = ""
        }
        
        let zipTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Zip/Postal code"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = ""
        }
        
        let webTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
            $0.textField.font = UIFont(name: "Gotham-Medium", size: 14.0)
            $0.textField.textAlignment = .right
            $0.titleLabel?.text = "Website"
            $0.titleLabel.textColor = UIColor.hex(hex: Colors.textColor)
            $0.titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
            }.configure {
                $0.placeholder = ""
                $0.text = ""
        }
        
        let imageSection = SectionFormer(rowFormer: imageRow)
            .set(headerViewFormer: createHeader("Photo of you"))
        let aboutSection = SectionFormer(rowFormer: jobTitleTextFieldRow, deptTextFieldRow, companyTextFieldRow, bioTextViewRow).set(headerViewFormer: createHeader("About"))
        let locationSection = SectionFormer(rowFormer: countryRow, addTextFieldRow, cityTextFieldRow, stateTextFieldRow, zipTextFieldRow).set(headerViewFormer: createHeader("Location"))
        let webSection = SectionFormer(rowFormer: webTextFieldRow)
            .set(headerViewFormer: createHeader("Website"))
        former.append(sectionFormer: imageSection, aboutSection, locationSection, webSection)
    }
    
    let createHeader: ((String) -> ViewFormer) = { text in
        return LabelViewFormer<FormLabelHeaderView>(){
            $0.titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
            $0.titleLabel.textColor = .black
            }.configure {
                $0.viewHeight = 30
                $0.text = text
        }
    }
    
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }

}

extension UpdatePersonalProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        Profile.sharedInstance.image = selectedImage
                imageRow.cellUpdate {
                    print("picker delegate")
                    $0.iconView.image = selectedImage
                }
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}
