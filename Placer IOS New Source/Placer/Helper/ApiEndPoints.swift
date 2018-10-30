//
//  ApiEndPoints.swift
//  Placer
//
//  Created by Vishal on 02/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation

class Api{
    static let baseUrl = "https://api.placer.in:443"
    //static let baseUrl = "https://dev-api.placer.in:443"
    static let authenticate = "/v1/authenticate.json"
    static let loggedMemberInfo = "/v1/Member/getLoggedMemberInfo.json"
    static let getDevices = "/v1/Tracker/getDevices.json"
    static let getCurrentlocation = "/v1/Tracker/getCurrentLocation.json"
    static let getLiveUpdateKey = "/v1/Tracker/getLiveUpdateKey.json"
//    daySummary.json
//  static let getDaySummary = "/v1/Reports/daySummaryNew.json"
    static let getDaySummary = "/v1/Reports/daySummary.json"
    static let getDeviceLog = "/v1/Reports/getDeviceLogs.json"
    static let registerFcm = "/v1/Notifications/addGCMDevice.json"
    static let getNotification = "/v1/Notifications/get.json"
    static let getWorkorders = "/v1/Workorder/getWorkOrder.json"
    static let appLogout = "/v1/Member/appLogout.json"
}
