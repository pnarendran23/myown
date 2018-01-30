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
        ID = (json["field_id"].arrayValue.first?.stringValue)!
        title = (json["title"].arrayValue.first?.stringValue)!
        path = (json["field_path"].arrayValue.first?.stringValue)!
        published_date = (json["field_published_date"].arrayValue.first?.stringValue)!
        price = (json["field_price"].arrayValue.first?.stringValue)!
        image = "usgbc"//json["image"].stringValue
        imageSmall = "usgbc"//json["imageSmall"].stringValue
        type = (json["field_type"].arrayValue.first?.stringValue)!
        subscription = (json["field_subscription"].arrayValue.first?.stringValue)!
        provider_name = (json["field_provider_name"].arrayValue.first?.stringValue)!
        price = (json["field_price"].arrayValue.first?.stringValue)!
        star_rating = (json["field_star_rating"].arrayValue.first?.stringValue)!
    }
}
