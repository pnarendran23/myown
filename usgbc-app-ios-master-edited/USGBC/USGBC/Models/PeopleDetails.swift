//
//  peopleDetails.swift
//  USGBC
//
//  Created by Vishal Raj on 12/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class PeopleDetails {
    var title = ""
    var UID = ""
    var email = ""
    var firstName = ""
    var lastName = ""
    var job_title = ""
    var organization_name = ""
    var image = ""
    var address = ""
    var overview = ""
    var website = ""
    var path = ""
    
    init(){}
    
    init(json: JSON) {
        title = json["title"].stringValue
        UID = json["UID"].stringValue
        email = json["email"].stringValue
        firstName = json["First Name"].stringValue
        lastName = json["Last Name"].stringValue
        job_title = json["job_title"].stringValue
        organization_name = json["organization_name"].stringValue
        image = json["image"].stringValue
        address = json["address"].stringValue
        overview = json["overview"].stringValue
        website = json["website"].stringValue
        path = json["path"].stringValue
    }
}
