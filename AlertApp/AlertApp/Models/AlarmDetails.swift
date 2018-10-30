//
//  AlarmDetails.swift
//  Placer For Schools
//
//  Created by Group10 on 11/6/15.
//  Copyright © 2015 Group10. All rights reserved.
//

import Foundation
class AlarmDetails
{
    var tripType:String
    var studentId:String
    var studentName:String
    var time:String
    var date:String
    
    init()
    {
        tripType = ""
        studentId = ""
        studentName = ""
        time = ""
        date = ""
    }
    
    init(studentId:String, studentName:String, tripType:String, time:String, date:String)
    {
        self.tripType = tripType
        self.studentId = studentId
        self.studentName = studentName
        self.time = time
        self.date = date
    }
}
