//
//  AlarmRingDetailsRLM.swift
//  AlertApp
//
//  Created by Group10 on 19/03/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class AlarmRingDetailsRLM: Object {
    
  @objc dynamic var tripType:String = ""
  @objc dynamic  var studentId:String = ""
  @objc dynamic  var studentName:String = ""
  @objc dynamic  var time:String = ""
  @objc dynamic  var date:String = ""
    
}
