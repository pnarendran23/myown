//
//  Student.swift
//  Placer For Schools
//
//  Created by Group10 on 9/21/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

import UIKit

class Student:NSObject
{
    var studentId:String
    var studentName:String
    var studentClass:String
    var vehName:String?
    var orgId:String
    var orgName:String
    var timeTillNextTrip:Int
    var tripId:String?
    var ppLat:String?
    var ppLng:String?
    var ppLocationName:String?
    var routeName:String?
    var pickup_start:String?
    var pickup_end:String?
    var drop_start:String?
    var drop_end:String?
    
    override init()
    {
        //Datas will be updated in DBHelper getAllStudentData
        self.studentId = ""
        self.studentName = ""
        self.studentClass = ""
        self.vehName = ""
        self.orgId = ""
        self.orgName = ""
        self.timeTillNextTrip = 0
        self.tripId = ""
        self.ppLat = ""
        self.ppLng = ""
        self.ppLocationName = ""
        self.routeName = ""
        self.pickup_start = ""
        self.pickup_end = ""
        self.drop_start = ""
        self.drop_end = ""
        super.init()
    }
    
    init(studentId:String, studentName: String, studentClass:String, vehName:String, orgId:String, orgName:String, timeTillNextTrip:Int, tripId:String?, ppLat:String?, ppLng:String?, ppLocationName:String?, routeName:String?, pickup_start:String?,pickup_end:String?, drop_start:String?, drop_end:String?)
    {
        self.studentId = studentId
        self.studentName = studentName
        self.studentClass = studentClass
        self.orgId = orgId
        self.orgName = orgName
        self.timeTillNextTrip = timeTillNextTrip
        self.tripId = tripId
        self.ppLat = ppLat
        self.ppLng = ppLng
        self.ppLocationName = ppLocationName
        self.routeName = routeName
        self.pickup_start = pickup_start
        self.pickup_end = pickup_end
        self.drop_start = drop_start
        self.drop_end = drop_end
        self.vehName = vehName
        super.init()
    }
    
}