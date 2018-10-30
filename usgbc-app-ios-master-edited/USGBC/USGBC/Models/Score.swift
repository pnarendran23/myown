//
//  Score.swift
//  USGBC
//
//  Created by Vishal Raj on 31/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class Score {
    var name = ""
    var score = 0
    var total = 0
    
    init() {}
    
    init(json: JSON) {
        name = json["name"].stringValue
        score = json["score"].intValue
        total = json["total"].intValue
    }
    
    func getImage() -> String {
        var image = ""
        switch name {
            case "Sustainable sites":
                image = "ss"
            case "Water efficiency":
                image = "we"
            case "Energy & atmosphere":
                image = "ea"
            case "Material & resources":
                image = "mr"
            case "Indoor environmental quality":
                image = "iq"
            case "Innovation":
                image = "id"
            case "Regional priority credits":
                image = "rp"
            default:
                break
        }
        return image
    }
}
