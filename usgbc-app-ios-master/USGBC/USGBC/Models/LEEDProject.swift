//
//  LEEDProject.swift
//  USGBC
//
//  Created by Vishal Raj on 23/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class LEEDProject {
    var title = ""
    var published = ""
    var saved = ""
    var certification_date = ""
    var certification_level = ""
    var rating_system = ""
    var nid = ""
    var pid = ""
    
    init() {}
    
    init(json: JSON){
        print(json)
        title = json["title"].stringValue
        published = json["Published"].stringValue
        saved = json["Saved"].stringValue
        certification_date = json["Certification date"].stringValue
        certification_level = json["Certification level"].stringValue
        rating_system = json["Rating system"].stringValue
        nid = json["Nid"].stringValue
        pid = json["pid"].stringValue
    }
}
