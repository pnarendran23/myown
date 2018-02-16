//
//  Credentials.swift
//  USGBC
//
//  Created by Vishal Raj on 17/07/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Credentials {
    var gbci_id = ""
    var report_start_date = ""
    var report_period_end = ""
    var to_be_reported_hours = ""
    var required_ce_hours = ""
    var reported_cehours = ""
    var cred_specific_record = [SpecificCredentials]()
    
    init() {}
    
    init(json: JSON) {
        gbci_id = json["title"].stringValue
        report_start_date = json["report_start_date"].stringValue
        report_period_end = json["report_period_end"].stringValue
        to_be_reported_hours = json["to_be_reported_hours"].stringValue
        required_ce_hours = json["required_ce_hours"].stringValue
        reported_cehours = json["reported_cehours"].stringValue
    }
}
