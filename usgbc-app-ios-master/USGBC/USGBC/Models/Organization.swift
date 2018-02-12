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
        title = (json["title"].arrayValue.first?.stringValue)!
        image = (json["image"].arrayValue.first?.stringValue)!
        if(json["address"] != nil){
            address =  (json["address"].arrayValue.first?.stringValue)!
        }else{
            address = ""
        }
        level = (json["level"].arrayValue.first?.stringValue)!
        ID = (json["id"].arrayValue.first?.stringValue)!
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
