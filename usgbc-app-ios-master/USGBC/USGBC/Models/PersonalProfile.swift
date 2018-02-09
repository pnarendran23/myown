//
//  PersonalProfile.swift
//  USGBC
//
//  Created by Vishal Raj on 12/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class PersonalProfile {
    var fname = ""
    var lname = ""
    var image = ""
    var jobtitle = ""
    var department = ""
    var company = ""
    var bio = ""
    var location = ""
    var gender = ""
    var website = ""
    var linkedin = ""
    var facebook = ""
    var twitter = ""
    var dob = ""
    var phone = ""
    var email = ""
    var aia = ""
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
    var aslanumber = ""
    var address1 = ""
    var address2 = ""
    var city = ""
    var country = ""
    var publicdirectory = ""
    var province = ""
    var postal_code = ""
    init(){}
    
    init(json: JSON){
        fname = json["firstname"].stringValue
        lname = json["lastname"].stringValue
        image = json["profileimg"].stringValue
        jobtitle = json["jobtitle"].stringValue
        department = json["department"].stringValue
        company = json["company"].stringValue
        bio = json["bio"].stringValue
        location = json["mailingaddress"].stringValue
        website = json["website"].stringValue
        linkedin = json["linkedinlink"].stringValue
        facebook = json["facebooklink"].stringValue
        twitter = json["twitterlink"].stringValue
        aia = json["aianumber"].stringValue
        dob = json["dob"].stringValue
        postal_code = json["postal_code"].stringValue
        phone = json["phone"].stringValue
        email = json["email"].stringValue
        gender = json["gender"].stringValue
        city = json["city"].stringValue
        province = json["province"].stringValue
        country = json["country"].stringValue
        address1 = json["address1"].stringValue
        address2 = json["address2"].stringValue
        aslanumber = json["aslanumber"].stringValue
        mailingaddressadditional1 = json["mailingaddressadditional1"].stringValue
        mailingaddressstreet = json["mailingaddressstreet"].stringValue
        mailingaddresscity = json["mailingaddresscity"].stringValue
        mailingaddressprovince = json["mailingaddressprovince"].stringValue
        mailingaddresscountry = json["mailingaddresscountry"].stringValue
        mailingaddresspostalcode = json["mailingaddresspostalcode"].stringValue
        mailingaddressadditional1 = json["mailingaddressadditional1"].stringValue
        billingaddressstreet = json["billingaddressstreet"].stringValue
        billingaddresscity = json["billingaddresscity"].stringValue
        billingaddressprovince = json["billingaddressprovince"].stringValue
        billingaddresscountry = json["billingaddresscountry"].stringValue
        billingaddresspostalcode = json["billingaddresspostalcode"].stringValue
        publicdirectory = json["publicdirectory"].stringValue
    }
}
