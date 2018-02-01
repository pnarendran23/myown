//
//  Profile.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 10/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import SwiftyJSON

final class Profile {
    
    static let sharedInstance = Profile()
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
    //-----
    var address1 = ""
    var address2 = ""
    var city = ""
    var province = ""
    var country = ""
    var postal_code = ""
    //-----
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
        malingAddress = json["malingAddress"].stringValue
        billingAddress = json["billingAddress"].stringValue
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
        currentInstitute = json["educational_institution"].stringValue
    }
}

//"aslanumber" : null,
//"company" : null,
//"billingaddresscountry" : null,
//"country" : null,
//"profileimg" : null,
//"mailingaddressstreet" : null,
//"billingaddresscity" : null,
//"mailingaddresscountry" : null,
//"dob" : null,
//"linkedinlink" : null,
//"publicdirectory" : "61",
//"graduationdate" : null,
//"website" : null,
//"twitterlink" : null,
//"jobtitle" : null,
//"facebooklink" : null,
//"mailingaddressprovince" : null,
//"email" : "vidya129@hotmail.com",
//"mailingaddressadditional1" : null,
//"mailingaddresspostalcode" : null,
//"billingaddressprovince" : null,
//"billingaddresspostalcode" : null,
//"address2" : null,
//"postal_code" : null,
//"mailingaddresscity" : null,
//"school" : null,
//"city" : null,
//"mailingaddressattentionto" : null,
//"province" : null,
//"lastname" : "Rupert",
//"gender" : null,
//"billingaddress" : null,
//"firstname" : "Stacey",
//"aianumber" : null,
//"studentid" : null,
//"billingaddressstreet" : null,
//"address1" : null,
//"phone" : "2026097164",
//"department" : null,
//"billingaddressadditional1" : null
