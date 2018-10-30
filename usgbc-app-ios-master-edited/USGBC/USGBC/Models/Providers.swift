//
//  Providers.swift
//  USGBC
//
//  Created by Vishal on 01/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Providers{
    var image = ""
    var title = ""
    var city = ""
    var state = ""
    var country = ""
    var associations = [String]()
    
    init() {}
    
    init(json: JSON) {
        image = json["image"].stringValue
        title = json["title"].stringValue
        city = json["city"].stringValue
        state = json["state"].stringValue
        country = json["country"].stringValue
        let tempAssociation = json["associations"].stringValue
        if(tempAssociation.isEmpty){
            for (_,association):(String, JSON) in json["associations"] {
                associations.append(association.stringValue)
            }
        }else{
            associations.append(tempAssociation)
        }
    }
}
