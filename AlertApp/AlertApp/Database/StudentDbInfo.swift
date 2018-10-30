//
//  StudentDbInfo.swift
//  AlertApp
//
//  Created by Group10 on 13/02/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class StudentDbInfo: Object {
    
    
    @objc dynamic var memberName = ""
    @objc dynamic var memberUid = ""
    @objc dynamic var memberSection = ""
    @objc dynamic var memberParentName = ""
    @objc dynamic var memberPrimaryMobileNo = ""
    @objc dynamic var memberSecondaryMobileNo = ""
    @objc dynamic var date = ""
    @objc dynamic var timezone_type = ""
    @objc dynamic var timezone = ""
    @objc dynamic var memberId = ""
    @objc dynamic var pickupId = ""
    @objc dynamic var pickuppointLocation = ""
    @objc dynamic var p_lat=0.0
    @objc dynamic var p_lng=0.0
    @objc dynamic var pickupRadius=0
    @objc dynamic var expectedTime=""
    @objc dynamic var routeType=""
    @objc dynamic var rfid=""
    @objc dynamic var memberClass=""
    @objc dynamic var orgName=""
    
    @objc dynamic var pickupDropId = ""
    @objc dynamic var DroppointLocation = ""
    @objc dynamic var drop_lat=0.0
    @objc dynamic var drop_lng=0.0
    @objc dynamic var dropRadius=0
    @objc dynamic var dropexpectedTime=""
    
    @objc dynamic var routeId = ""
    @objc dynamic var routeName = ""
    
    @objc dynamic var appAlert = ""
    @objc dynamic var callAlert = ""
    @objc dynamic var emailAlert = ""
    
    @objc dynamic var smsAlert = ""
    @objc dynamic var orglocAddress = ""
    @objc dynamic var orgloclatitude = 0.0
    @objc dynamic var orgloclangitude = 0.0
    
    //    override static func primaryKey() -> String? {
    //        return "memberId"
    //    }
    
    
}
