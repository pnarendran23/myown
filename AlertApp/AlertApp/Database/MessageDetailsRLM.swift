//
//  MessageDetailsRLM.swift
//  AlertApp
//
//  Created by Group10 on 19/03/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class MessageDetailsRLM : Object {
    
    @objc dynamic var messagesId = ""
    @objc dynamic var studentName = ""
    @objc dynamic var studentId = ""
    @objc dynamic var receivedTime = ""
    @objc dynamic var orgName = ""
    @objc dynamic var message = ""
    @objc dynamic var readOrUnread = ""
    @objc dynamic var serverTime = ""
   

}
