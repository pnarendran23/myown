//
//  NotificationLog.swift
//  USGBC
//
//  Created by Vishal Raj on 06/11/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class NotificationLog: Object {
    var userid = ""
    var message = ""
    var timestamp = ""
    var category = ""
    
    func add(json: JSON) {
        userid = json["userid"].stringValue
        message = json["message"].stringValue
        timestamp = json["timestamp"].stringValue
        category = json["category"].stringValue
    }
}
