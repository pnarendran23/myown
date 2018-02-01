//
//  SpecificCredentials.swift
//  USGBC
//
//  Created by Vishal Raj on 06/11/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class SpecificCredentials {
    var leed_specific_hours = ""
    var name = ""
    var specialty_hours_reported = ""
    var cehours_cred_percentage = ""
    
    init(){}
    
    init(json: JSON){
        leed_specific_hours = json["leed_specific_hours"].stringValue
        name = json["name"].stringValue
        specialty_hours_reported = json["specialty_hours_reported"].stringValue
        cehours_cred_percentage = json["cehours_cred_percentage"].stringValue
    }
    
    func getCredentialImage() -> UIImage {
        var image = UIImage()
        if(name.contains("Green Associate")){
            image = UIImage(named: "lga")!
        }else if(name.contains("BD+C")){
            image = UIImage(named: "bdc")!
        }else if(name.contains("O+M")){
            image = UIImage(named: "om")!
        }else if(name.contains("ID+C")){
            image = UIImage(named: "idc")!
        }else if(name.contains("ND")){
            image = UIImage(named: "nd")!
        }else if(name.contains("AP HOMES")){
            image = UIImage(named: "h")!
        }else if(name.contains("GREEN RATER")){
            image = UIImage(named: "gra")!
        }
        return image
    }
}
