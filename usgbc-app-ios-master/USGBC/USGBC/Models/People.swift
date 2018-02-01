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
        title = json["title"].stringValue
        UID = json["UID"].stringValue
        job_title = json["job_title"].stringValue
        organization_name = json["organization_name"].stringValue
        ID = json["ID"].stringValue
        image = json["image"].stringValue
        address = json["address"].stringValue
    }
}
