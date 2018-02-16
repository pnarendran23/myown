//
//  Leaders.swift
//  USGBC
//
//  Created by Vishal on 01/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Leader{
    var first_name = ""
    var last_name = ""
    var job_title = ""
    var org_name = ""
    
    init() {}
    
    init(json: JSON) {
        first_name = json["first_name"].stringValue
        last_name = json["last_name"].stringValue
        job_title = json["job_title"].stringValue
        org_name = json["org_name"].stringValue
    }
}
