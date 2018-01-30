//
//  Project.swift
//  USGBC
//
//  Created by Vishal on 05/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Project: NSObject{
    var title = ""
    var certification_level = ""
    var rating_system_version = ""
    var image = ""
    var ID = ""
    var address = ""
    var lat = ""
    var long = ""
    
    override init() {}
    
    init(json: JSON) {
        title = json["title"].stringValue
        certification_level = json["certification_level"].stringValue
        rating_system_version = json["rating_system_version"].stringValue
        image = json["image"].stringValue
        ID = json["ID"].stringValue
        address = json["address"].stringValue
        lat = json["lat"].stringValue
        long = json["long"].stringValue
    }
    
    func getCertificationLevelImage() -> UIImage {
        var image = UIImage()
        if(certification_level == "Platinum"){
            image = UIImage(named: "platinum_project")!
        }else if(certification_level == "Gold"){
            image = UIImage(named: "gold_project")!
        }else if(certification_level == "Silver"){
            image = UIImage(named: "silver_project")!
        }else if(certification_level == "Certified"){
            image = UIImage(named: "certified_project")!
        }
        return image
    }
}
