//
//  Publication.swift
//  USGBC
//
//  Created by Vishal on 04/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Publication: Object{
    dynamic var expirationDate = ""
    dynamic var fileName = ""
    dynamic var edition = ""
    dynamic var image = ""
    dynamic var fileKey = ""
    dynamic var fid = ""
    dynamic var fileDescription = ""
    dynamic var type = ""
    dynamic var publishedDate = ""
    dynamic var ratingsystem = ""
    
    func initObject(json: JSON) {
        expirationDate = json["expirationDate"].stringValue
        fileName = json["fileName"].stringValue
        edition = json["edition"].stringValue
        image = json["image"].stringValue
        fileKey = json["fileKey"].stringValue
        fid = json["fid"].stringValue
        fileDescription = json["description"].stringValue
        type = json["type"].stringValue
        publishedDate = json["publishedDate"].stringValue
        ratingsystem = json["ratingsystem"].stringValue
        expirationDate = json["expirationDate"].stringValue
    }
}
