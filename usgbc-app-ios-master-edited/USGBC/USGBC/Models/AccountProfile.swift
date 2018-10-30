//
//  AccountProfile.swift
//  USGBC
//
//  Created by Vishal Raj on 12/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class AccountProfile {
    var image: UIImage?
    var fname = ""
    var lname = ""
    var email = ""
    var password = ""
    var dob = ""
    var gender = ""
    var currentInstitute = ""
    var isStudent = false
    var studentID = ""
    var currentMajor = ""
    var currentDegree = ""
    var graduationDate = ""
    var malingAddress = ""
    var billingAddress = ""
    var phone = ""
    var aia = ""
    var customernumber = ""
    var aslanumber = ""
    var mailingaddressadditional1 = ""
    var mailingaddressstreet = ""
    var mailingaddresscity = ""
    var mailingaddresspostalcode = ""
    var mailingaddressprovince = ""
    var mailingaddresscountry = ""
    var billingaddressadditional1 = ""
    var billingaddressstreet = ""
    var billingaddresscity = ""
    var billingaddresspostalcode = ""
    var billingaddressprovince = ""
    var billingaddresscountry = ""
    
    init(){}
    
    init(json: JSON){
        fname = json["firstname"].stringValue
        lname = json["lastname"].stringValue
        phone = json["phone"].stringValue
        malingAddress = json["malingaddress"].stringValue
        billingAddress = json["billingaddress"].stringValue
        mailingaddressadditional1 = json["mailingaddressadditional1"].stringValue
        mailingaddressstreet = json["mailingaddressstreet"].stringValue
        mailingaddresscity = json["mailingaddresscity"].stringValue
        mailingaddressprovince = json["mailingaddressprovince"].stringValue
        mailingaddresscountry = json["mailingaddresscountry"].stringValue
        mailingaddresspostalcode = json["mailingaddresspostalcode"].stringValue
        billingaddressadditional1 = json["billingaddressadditional1"].stringValue
        billingaddressstreet = json["billingaddressstreet"].stringValue
        billingaddresscity = json["billingaddresscity"].stringValue
        billingaddressprovince = json["billingaddressprovince"].stringValue
        billingaddresscountry = json["billingaddresscountry"].stringValue
        billingaddresspostalcode = json["mailingaddresspostalcode"].stringValue
        customernumber = json["customernumber"].stringValue
        dob = json["dob"].stringValue
        gender = json["gender"].stringValue
        graduationDate = json["graduationdate"].stringValue
        studentID = json["studentid"].stringValue
        currentInstitute = json["educationalinstitution"].stringValue
        aia = json["aianumber"].stringValue
        aslanumber = json["aslanumber"].stringValue
    }
}
