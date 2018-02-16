//
//  Overview.swift
//  USGBC
//
//  Created by Vishal on 11/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrganizationDetails {
    var image = ""
    var title = ""
    var address = ""
    var org_email = ""
    var overview = ""
    var foundation_statement = ""
    var website = ""
    var phone = ""
    var member_since = ""
    var map_link = ""
    var level = ""
    var path = ""
    
    init(){}
    
    init(json: JSON){
        print(json)
        image = json["image"].stringValue
        title = json["title"].stringValue
        address = json["address"].stringValue
        org_email = json["org_email"].stringValue
        overview = json["overview"].stringValue
        foundation_statement = json["foundation_statement"].stringValue
        website = json["website"].stringValue
        member_since = json["member_since"].stringValue
        map_link = json["map_link"].stringValue
        level = json["level"].stringValue
        phone = json["phone"].stringValue
        path = json["path"].stringValue
    }
    
    func getMemberLevelImage() -> String {
        var image = ""
        if(level == "Platinum"){
            image = "http://usgbc.org/sites/all/themes/usgbc/lib/img/mem-badges/platinum-large.png"
        }else if(level == "Gold"){
            image = "http://usgbc.org/sites/all/themes/usgbc/lib/img/mem-badges/gold-large.png"
        }else if(level == "Silver"){
            image = "http://usgbc.org/sites/all/themes/usgbc/lib/img/mem-badges/silver-large.png"
        }
       return image
    }
}


