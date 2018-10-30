//
//  DataReporting.swift
//  USGBC
//
//  Created by Vishal Raj on 31/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataReporting {
    var name = ""
    var score = 0
    var url = ""
    
    init() {}
    
    func getImage() -> String{
        let image = name.components(separatedBy: " ").first
        if(score != 0){
            return image!.lowercased()
        }else{
            return "\(image!.lowercased())_black"
        }
    }
}
