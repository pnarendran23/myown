//
//  Resources.swift
//  USGBC
//
//  Created by Vishal on 01/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Resources{
    var url = ""
    var description = ""
    
    init() {}
    
    init(json: JSON) {
        url = json["url"].stringValue
        description = json["description"].stringValue
    }
}
