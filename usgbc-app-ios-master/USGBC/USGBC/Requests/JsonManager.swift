//
//  JsonManager.swift
//  USGBC
//
//  Created by Vishal Raj on 16/09/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class JsonManager {
    
    static let shared = JsonManager()
    
    func getQuickMenus(callback: @escaping ([QuickMenu]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "Quick_menu", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var quickMenus: [QuickMenu] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json {
            for (_,innerJson):(String, JSON) in subJson {
                let quickMenu = QuickMenu()
                quickMenu.name = innerJson["name"].stringValue
                quickMenu.controller = innerJson["controller"].stringValue
                quickMenu.image = innerJson["image"].stringValue
                quickMenus.append(quickMenu)
            }
        }
        callback(quickMenus, nil)
    }
    
    func getSettings(callback: @escaping ([SettingsMenu]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "Settings_menu", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var settingsMenus: [SettingsMenu] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json {
            for (_,innerJson):(String, JSON) in subJson {
                let settingsMenu = SettingsMenu()
                settingsMenu.sectionName = innerJson["name"].stringValue
                for(_, subSettingsJson):(String, JSON) in innerJson["sub-settings"]{
                    let settingsSubMenu = SettingsSubMenu()
                    settingsSubMenu.name = subSettingsJson["name"].stringValue
                    settingsMenu.sectionList.append(settingsSubMenu)
                }
                settingsMenus.append(settingsMenu)
            }
        }
        callback(settingsMenus, nil)
    }
    
    func getCourseFilters(callback: @escaping ([CourseFilter]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "Course_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var courseFilters: [CourseFilter] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json {
            for (_,filterJson):(String, JSON) in subJson {
                let courseFilter = CourseFilter()
                courseFilter.name = filterJson["name"].stringValue
                for(_, subFilterJson):(String, JSON) in filterJson["sub-filters"]{
                    let subFilter = CourseSubFilter()
                    subFilter.name = subFilterJson["name"].stringValue
                    subFilter.value = subFilterJson["value"].stringValue
                    courseFilter.subFilters.append(subFilter)
                }
                courseFilters.append(courseFilter)
            }
        }
        callback(courseFilters, nil)
    }
    
    func getResourcesLeedFilters(callback: @escaping ([ResourcesLeedFilter]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "ResourcesLeed_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var filters: [ResourcesLeedFilter] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json {
            for (_,filterJson):(String, JSON) in subJson {
                let filter = ResourcesLeedFilter()
                filter.name = filterJson["name"].stringValue
                for(_, subFilterJson):(String, JSON) in filterJson["sub-filters"]{
                    let subFilter = ResourcesLeedSubFilter()
                    subFilter.name = subFilterJson["name"].stringValue
                    subFilter.value = subFilterJson["value"].stringValue
                    if(filter.name == "Type"){
                        subFilter.selected = true
                    }
                    filter.subFilters.append(subFilter)
                }
                filters.append(filter)
            }
        }
        callback(filters, nil)
    }
    
    func getResourcesCredentialingFilters(callback: @escaping ([ResourcesCredentialingFilter]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "ResourcesCredentialing_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var filters: [ResourcesCredentialingFilter] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json {
            for (_,filterJson):(String, JSON) in subJson {
                let filter = ResourcesCredentialingFilter()
                filter.name = filterJson["name"].stringValue
                for(_, subFilterJson):(String, JSON) in filterJson["sub-filters"]{
                    let subFilter = ResourcesCredentialingSubFilter()
                    subFilter.name = subFilterJson["name"].stringValue
                    subFilter.value = subFilterJson["value"].stringValue
                    if(filter.name == "Type"){
                        subFilter.selected = true
                    }
                    filter.subFilters.append(subFilter)
                }
                filters.append(filter)
            }
        }
        callback(filters, nil)
    }
    
    func getResourcesAdvAndPolicyFilters(callback: @escaping ([ResourcesAdvAndPolicyFilter]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "ResourcesAdvAndPolicy_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var filters: [ResourcesAdvAndPolicyFilter] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json {
            for (_,filterJson):(String, JSON) in subJson {
                let filter = ResourcesAdvAndPolicyFilter()
                filter.name = filterJson["name"].stringValue
                for(_, subFilterJson):(String, JSON) in filterJson["sub-filters"]{
                    let subFilter = ResourcesAdvAndPolicySubFilter()
                    subFilter.name = subFilterJson["name"].stringValue
                    subFilter.value = subFilterJson["value"].stringValue
                    if(filter.name == "Type"){
                        subFilter.selected = true
                    }
                    filter.subFilters.append(subFilter)
                }
                filters.append(filter)
            }
        }
        callback(filters, nil)
    }
    
    func getArticleFilters(callback: @escaping ([ArticleFilter]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "Article_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var articleFilters: [ArticleFilter] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json["filters"] {
            let articleFilter = ArticleFilter()
            articleFilter.name = subJson["name"].stringValue
            articleFilters.append(articleFilter)
        }
        callback(articleFilters, nil)
    }
    
    func getCreditFilters(callback: @escaping ([CreditFilter]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "Credit_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var creditFilters: [CreditFilter] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json["filters"] {
            let creditFilter = CreditFilter()
            creditFilter.name = subJson["name"].stringValue
            creditFilters.append(creditFilter)
        }
        callback(creditFilters, nil)
    }
    
    func getDirectoryOrganizationFilters(callback: @escaping ([DirectoryOrganizationFilter]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "DirectoryOrganization_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var filters: [DirectoryOrganizationFilter] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json["filters"] {
            let filter = DirectoryOrganizationFilter()
            filter.name = subJson["name"].stringValue
            filters.append(filter)
        }
        callback(filters, nil)
    }
    
    func getDirectoryPeopleFilters(callback: @escaping ([DirectoryPeopleFilter]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "DirectoryPeople_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var filters: [DirectoryPeopleFilter] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json["filters"] {
            let filter = DirectoryPeopleFilter()
            filter.name = subJson["name"].stringValue
            filters.append(filter)
        }
        callback(filters, nil)
    }
    
    func getDirectoryProjectFilters(callback: @escaping ([DirectoryProjectFilter]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "DirectoryProject_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var filters: [DirectoryProjectFilter] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json["filters"] {
            let filter = DirectoryProjectFilter()
            filter.name = subJson["name"].stringValue
            filter.value = subJson["value"].stringValue
            filters.append(filter)
        }
        callback(filters, nil)
    }
}
