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
        title = json["title"].stringValue
        image = json["image"].stringValue
        address = json["address"].stringValue
        level = json["level"].stringValue
        ID = json["ID"].stringValue
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
