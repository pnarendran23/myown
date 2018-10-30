//
//  TripData.swift
//  Placer For Schools
//
//  Created by Group10 on 10/19/15.
//  Copyright © 2015 Group10. All rights reserved.
//

import UIKit

class TripData:NSObject
{
    var studentId:String
    var tripId:String
    var vehLat:String
    var vehLng:String
    var vehDeviceDateTime:String
    var vehSpeed:String
    
    init(studentId:String,tripId:String,vehLat:String,vehLng:String,
        vehDeviceDateTime:String,vehSpeed:String)
    {
        self.studentId = studentId
        self.tripId = tripId
        self.vehLat = vehLat
        self.vehLng = vehLng
        self.vehDeviceDateTime = vehDeviceDateTime
        self.vehSpeed = vehSpeed
    }
}