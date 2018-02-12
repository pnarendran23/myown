//
//  People.swift
//  USGBC
//
//  Created by Vishal on 05/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class People{
    var title = ""
    var UID = ""
    var job_title = ""
    var organization_name = ""
    var ID = ""
    var image = ""
    var address = ""
    
    init() {}
    
    init(json: JSON) {
        title = (json["title"].arrayValue.first?.stringValue)!
        if(json["uid"] == nil){
            UID = ""
        }else{
            UID = (json["uid"].arrayValue.first?.stringValue)!
        }
        job_title = (json["job_title"].arrayValue.first?.stringValue)!
        organization_name = (json["organization_name"].arrayValue.first?.stringValue)!
        ID = (json["id"].arrayValue.first?.stringValue)!
        image = (json["image"].arrayValue.first?.stringValue)!
        address = (json["address"].arrayValue.first?.stringValue)!
    }
}
