//
//  Message.swift
//  Placer For Schools
//
//  Created by Group10 on 9/22/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

import UIKit

class Message:NSObject
{
    var messagesId:String
    var studentName:String
    var studentId:String
    var receivedTime:String
    var orgName:String
    var message:String
    var readOrUnread:String
    var serverTime:String
    
    override init()
    {
        self.messagesId = ""
        self.studentName = ""
        self.receivedTime = ""
        self.orgName = ""
        self.message = ""
        self.studentId = ""
        self.readOrUnread = "u" 
        self.serverTime = ""
    }
    
    init(messagesId:String, studentName:String,studentId:String,receivedTime:String,orgName:String,message:String,
        readOrUnread:String,serverTime:String)
    {
        self.messagesId = messagesId
        self.studentName = studentName
        self.receivedTime = receivedTime
        self.orgName = orgName
        self.message = message
        self.studentId = studentId
        self.readOrUnread = readOrUnread
        self.serverTime = serverTime
    }
}
