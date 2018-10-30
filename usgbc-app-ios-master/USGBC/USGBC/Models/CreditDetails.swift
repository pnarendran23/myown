//
//  CreditDetails.swift
//  USGBC
//
//  Created by Vishal Raj on 13/09/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreditDetails {
    var title = ""
    var short_id = ""
    var image = ""
    var required = ""
    var ID = ""
    var points_from = ""
    var points_to = ""
    var rpc = ""
    var rating_system = ""
    var version = ""
    var category = ""
    var intent = ""
    var requirements = ""
    var implemanetation = ""
    var path = ""
    
    init() {}
    
    init(json: JSON) {
        print(json)
        title = json["title"].stringValue
        short_id = json["short_id"].stringValue
        image = json["image"].stringValue
        required = json["required"].stringValue
        ID = json["ID"].stringValue
        points_from = json["points_from"].stringValue
        points_to = json["points_to"].stringValue
        rpc = json["rpc"].stringValue
        rating_system = json["rating_system"].stringValue
        version = json["version"].stringValue
        category = json["category"].stringValue
        intent = json["intent"].stringValue
        requirements = json["requirements"].stringValue
        implemanetation = json["implementation"].stringValue
        path = json["path"].stringValue
    }
    
    init(jsonfromelastic: JSON) {        
        title = checknil(obj: jsonfromelastic, key: "title")
        short_id = checknil(obj: jsonfromelastic, key: "title")//(jsonfromelastic["field_credit_id"].arrayValue.first?.stringValue)!
        image = checknil(obj: jsonfromelastic, key: "field_images")//(jsonfromelastic["field_credit_image"].arrayValue.first?.stringValue)!
        required = checknil(obj: jsonfromelastic, key: "field_required")//(jsonfromelastic["field_credit_required"].arrayValue.first?.stringValue)!
        ID = checknil(obj: jsonfromelastic, key: "field_id")//(jsonfromelastic["field_credit_id"].arrayValue.first?.stringValue)!
        points_from = checknil(obj: jsonfromelastic, key: "field_points_from")//(jsonfromelastic["field_credit_points_from"].arrayValue.first?.stringValue)!
        points_to = checknil(obj: jsonfromelastic, key: "field_points_to")//(jsonfromelastic["field_credit_points_to"].arrayValue.first?.stringValue)!
        rpc = checknil(obj: jsonfromelastic, key: "field_rpc")//(jsonfromelastic["field_p_id"].arrayValue.first?.stringValue)!
        rating_system = checknil(obj: jsonfromelastic, key: "field_rating_system")//(jsonfromelastic["field_p_id"].arrayValue.first?.stringValue)!
        version = checknil(obj: jsonfromelastic, key: "field_version")//(jsonfromelastic["field_p_id"].arrayValue.first?.stringValue)!
        category = checknil(obj: jsonfromelastic, key: "field_category")
        intent = checknil(obj: jsonfromelastic, key: "field_intent")//(jsonfromelastic["field_p_id"].arrayValue.first?.stringValue)!
        requirements = checknil(obj: jsonfromelastic, key: "field_requirements")
        requirements = requirements.replacingOccurrences(of: "\n", with: "")
        //(jsonfromelastic["field_p_id"].arrayValue.first?.stringValue)!
        implemanetation = ""//(jsonfromelastic["field_p_id"].arrayValue.first?.stringValue)!
        path = checknil(obj: jsonfromelastic, key: "field_path")//(jsonfromelastic["field_p_id"].arrayValue.first?.stringValue)!
    }
    
    func checknil(obj : JSON, key : String) -> String{
        if(obj[key] != nil){
            return (obj[key].arrayValue.first?.stringValue)!
        }
        return ""
    }
    
    func getHtmlContents(contents: String) -> String {
        var contents = contents
        contents = contents.replacingOccurrences(of: "{{title}}", with: "\(title) | \(version)")
        contents = contents.replacingOccurrences(of: "{{category}}", with: category)
        contents = contents.replacingOccurrences(of: "{{points}}", with: "Credit | \(points_from) point")
        contents = contents.replacingOccurrences(of: "{{image}}", with: image)
        contents = contents.replacingOccurrences(of: "{{intent}}", with: intent)
        contents = contents.replacingOccurrences(of: "{{requirements}}", with: requirements)
        contents = contents.replacingOccurrences(of: "{{body}}", with: implemanetation)
        return contents
    }
}
