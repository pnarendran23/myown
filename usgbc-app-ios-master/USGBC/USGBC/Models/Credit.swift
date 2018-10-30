//
//  Credit.swift
//  USGBC
//
//  Created by Vishal on 09/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Credit {
    var title = ""
    var image = ""
    var required = ""
    var ID = ""
    var points_from = ""
    var points_to = ""
    var category = ""
    
    init() {}
    
    init(json: JSON) {
        print(json)
        if(json["title"] != nil){
            title = (json["title"].arrayValue.first?.stringValue)!
        }
        if(json["field_credit_image"] != nil){
            image = (json["field_credit_image"].arrayValue.first?.stringValue)!
        }
        if(json["field_credit_required"] != nil){
            required = (json["field_credit_required"].arrayValue.first?.stringValue)!
        }
        if(json["field_credit_id"] != nil){
            ID = (json["field_credit_id"].arrayValue.first?.stringValue)!
        }
        if(json["field_credit_points_from"] != nil){
            points_from = (json["field_credit_points_from"].arrayValue.first?.stringValue)!
        }
        if(json["field_credit_points_to"] != nil){
            points_to = (json["field_credit_points_to"].arrayValue.first?.stringValue)!
        }        
        if(json["field_credit_category"] != nil){
            category = (json["field_credit_category"].arrayValue.first?.stringValue)!
        }
    }
}
