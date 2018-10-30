//
//  Alert.swift
//  Placer For Schools
//
//  Created by Group10 on 10/19/15.
//  Copyright © 2015 Group10. All rights reserved.
//

import UIKit

class Alert:NSObject
{
    var alertsId:String
    var studentName:String
    var studentId:String
    var receivedTime:String
    var orgName:String
    var alert:String
    var readOrUnread:String
    var serverTime:String
    
    override init()
    {
        self.alertsId = ""
        self.studentName = ""
        self.receivedTime = ""
        self.orgName = ""
        self.alert = ""
        self.studentId = ""
        self.readOrUnread = "u"
        self.serverTime = ""
    }
    
    init(alertsId:String,studentName:String,studentId:String,receivedTime:String,orgName:String,alert:String,
        readOrUnread:String,serverTime:String)
    {
        self.alertsId = alertsId
        self.studentName = studentName
        self.receivedTime = receivedTime
        self.orgName = orgName
        self.alert = alert
        self.studentId = studentId
        self.readOrUnread = readOrUnread
        self.serverTime = serverTime
    }
}
