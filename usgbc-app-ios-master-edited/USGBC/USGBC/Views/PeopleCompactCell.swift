//
//  PeopleCompactCollectionViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 20/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class PeopleCompactCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    
    func initViews(){
        titleLabel.font = UIFont.gothamMedium(size: 14)
        designationLabel.font = UIFont.gothamBook(size: 12)
        organizationLabel.font = UIFont.gothamBook(size: 12)
        addressLabel.font = UIFont.gothamMedium(size: 12)
    }
    
    func updateViews(people: People){
        let image = UIImage(named: "placeholder")
        imageView.kf.setImage(with: URL(string: people.image), placeholder: image)
        imageView.clipsToBounds = true
        titleLabel.text = people.title
        addressLabel.text = people.address.replacingOccurrences(of: "\n", with: "")
        if(people.job_title == " "){
            designationLabel.isHidden = true
        }else{
            designationLabel.isHidden = false
            designationLabel.text = people.job_title
        }
        if(people.organization_name == " "){
            organizationLabel.isHidden = true
        }else{
            organizationLabel.isHidden = false
            organizationLabel.text = people.organization_name
        }
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            separatorView.isHidden = true
        }
    }
}
