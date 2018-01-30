//
//  Resource.swift
//  USGBC
//
//  Created by Vishal on 09/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Resource {
    var title = ""
    var image = ""
    var format = ""
    var ID = ""
    var res_type = ""
    var path = ""
    
    init() {}
    
    init(json: JSON) {
        title = (json["title"].arrayValue.first?.stringValue)!
        image = (json["field_resources_images"].arrayValue.first?.stringValue)!
        format = (json["field_format"].arrayValue.first?.stringValue)!
        ID = (json["field_res_id"].arrayValue.first?.stringValue)!
        res_type = (json["field_res_type"].arrayValue.first?.stringValue)!
        path = (json["field_res_path"].arrayValue.first?.stringValue)!
    }
}

