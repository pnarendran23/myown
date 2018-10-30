//
//  Organization.swift
//  USGBC
//
//  Created by Vishal on 05/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Organization{
    var title:String = ""
    var image:String = ""
    var address:String = ""
    var level:String = ""
    var ID: String = ""
    
    init() {}
    
    init(json: JSON) {
        if(json["title"] != nil){
            title = (json["title"].arrayValue.first?.stringValue)!
        }
        if(json["image"] != nil){
            image = (json["image"].arrayValue.first?.stringValue)!
        }
        if(json["address"] != nil){
            address =  (json["address"].arrayValue.first?.stringValue)!
        }else{
            address = ""
        }
        if(json["level"] != nil){
            level = (json["level"].arrayValue.first?.stringValue)!
        }
        if(json["id"] != nil){
            ID = (json["id"].arrayValue.first?.stringValue)!
        }
    }
    
    func getLevelImage() -> UIImage {
        var levelImage = UIImage()
        if(level == "Platinum"){
            levelImage = UIImage(named: "platinum")!
        }else if(level == "Gold"){
            levelImage = UIImage(named: "gold")!
        }else if(level == "Silver"){
            levelImage = UIImage(named: "silver")!
        }
        return levelImage
    }
}
