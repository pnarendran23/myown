//
//  PeopleEndorsement.swift
//  USGBC
//
//  Created by Vishal Raj on 12/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class PeopleEndorsement {
    var endorsee = ""
    var statement = ""
    var name = ""
    var title = ""
    var uid = ""
    var updatedDate = ""
    var postDate = ""
    var endorsementType = ""
    var nid = ""
    
    init(){}
    
    init(json: JSON){
        endorsee = json["Endorsee"].stringValue
        statement = json["Statement"].stringValue
        name = json["Name"].stringValue
        title = json["Title"].stringValue
        uid = json["Uid"].stringValue
        updatedDate = json["Updated date"].stringValue
        postDate = json["Post date"].stringValue
        endorsementType = json["Endorsement type"].stringValue
        nid = json["Nid"].stringValue
    }
}
