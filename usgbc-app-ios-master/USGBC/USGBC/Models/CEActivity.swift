//
//  CEActivity.swift
//  USGBC
//
//  Created by Vishal Raj on 20/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class CEActivity {
    var field_ce_course_activity_id_value = ""
    var field_ce_act_type_value = ""
    var field_ce_hours_reported_value = ""
    var field_ce_approval_status_value = ""
    var field_ce_course_title_value = ""
    var field_ce_course_provider_value = ""
    var field_ce_course_from_date_value = ""
    var field_ce_course_desc_value = ""
    var field_ce_specialty_value = ""
    var Nid = ""
    
    init() {}
    
    init(json: JSON) {
        //print(json)
        field_ce_course_activity_id_value = json["field_ce_course_activity_id_value"].stringValue
        field_ce_act_type_value = json["field_ce_act_type_value"].stringValue
        field_ce_hours_reported_value = json["field_ce_hours_reported_value"].stringValue
        field_ce_approval_status_value = json["field_ce_approval_status_value"].stringValue
        field_ce_course_title_value = json["field_ce_course_title_value"].stringValue
        field_ce_course_provider_value = json["field_ce_course_provider_value"].stringValue
        field_ce_course_from_date_value = json["field_ce_course_from_date_value"].stringValue
        field_ce_course_desc_value = json["field_ce_course_desc_value"].stringValue
        field_ce_specialty_value = json["field_ce_specialty_value"].stringValue
        print(field_ce_specialty_value)
        Nid = json["Nid"].stringValue
    }
}
