//
//  AlertsDetailsRLM.swift
//  AlertApp
//
//  Created by Group10 on 19/03/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class AlertsDetailsRLM: Object {
    
    @objc dynamic var alertsId:String = ""
    @objc dynamic var studentName:String = ""
    @objc dynamic var studentId:String = ""
    @objc dynamic var receivedTime:String = ""
    @objc dynamic var orgName:String = ""
    @objc dynamic var alert:String = ""
    @objc dynamic var readOrUnread:String = ""
    @objc dynamic var serverTime:String = ""
    @objc dynamic var tripType : String = ""
    
    
}
