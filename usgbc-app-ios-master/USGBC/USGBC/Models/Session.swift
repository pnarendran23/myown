//
//  Sessions.swift
//  USGBC
//
//  Created by Vishal on 01/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Session {
    var image = ""
    var course_name = ""
    var type = ""
    var courseid = ""
    var price = ""
    var title = ""
    var subscription = ""
    var path = ""
    var gbci_number = ""
    var video_url = ""
    var org_name = ""
    var provider_name = ""
    var parent_title = ""
    var parent_image = ""
    var in_series_session = ""
    var parent_nid = ""
    
    init() {}
    
    init(json: JSON) {
        image = json["image"].stringValue
        course_name = json["course_name"].stringValue
        type = json["type"].stringValue
        courseid = json["courseid"].stringValue
        price = json["price"].stringValue
        title = json["title"].stringValue
        subscription = json["subscription"].stringValue
        path = json["path"].stringValue
        gbci_number = json["gbci_number"].stringValue
        video_url = json["video_url"].stringValue
        org_name = json["org_name"].stringValue
        provider_name = json["provider_name"].stringValue
        parent_title = json["parent_title"].stringValue
        parent_image = json["parent_image"].stringValue
        in_series_session = json["in_series_session"].stringValue
        parent_nid = json["parent_nid"].stringValue
    }
}
