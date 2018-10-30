//
//  Course.swift
//  USGBC
//
//  Created by Vishal on 24/04/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Course{
    var ID = ""
    var title = ""
    var path = ""
    var published_date = ""
    var image = ""
    var imageSmall = ""
    var type = ""
    var subscription = ""
    var provider_name = ""
    var price = ""
    var star_rating = ""
    
    init() {}
    
    init(json:JSON) {
        print(json)
        ID = (json["courses_id"].arrayValue.first?.stringValue)!
        title = (json["title"].arrayValue.first?.stringValue)!
        path = (json["courses_path"].arrayValue.first?.stringValue)!
        published_date = (json["courses_published_date"].arrayValue.first?.stringValue)!
        price = (json["courses_price"].arrayValue.first?.stringValue)!
        image = (json["courses_image"].arrayValue.first?.stringValue)!
        imageSmall = (json["courses_imagesmall"].arrayValue.first?.stringValue)!
        type = (json["courses_type"].arrayValue.first?.stringValue)!
        subscription = (json["courses_subscription"].arrayValue.first?.stringValue)!
        provider_name = (json["courses_provider_name"].arrayValue.first?.stringValue)!
        //price = (json["field_price"].arrayValue.first?.stringValue)!
        star_rating = (json["courses_star_rating"].arrayValue.first?.stringValue)!
    }
}
